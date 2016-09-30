require 'spec_helper'
require 'collector'

RSpec.describe Collector do
  subject { described_class.new }

  let(:queue_1) { instance_double(Sidekiq::Queue, name: 'queue_1', size: 10) }
  let(:queue_2) { instance_double(Sidekiq::Queue, name: 'queue_2', size: 20) }
  let(:queue_3) { instance_double(Sidekiq::Queue, name: 'queue_3', size: 0) }

  it 'collects stats for queue lengths' do
    expect(Sidekiq::Queue).to receive(:all).and_return([queue_1, queue_2, queue_3])
    allow_any_instance_of(Sidekiq::Workers).to receive(:each)

    stats = subject.stats

    expect(stats).to include('queue_1.length' => 10)
    expect(stats).to include('queue_2.length' => 20)
    expect(stats).to include('queue_3.length' => 0)
  end

  it 'collects stats for queue WIPs' do
    expect(Sidekiq::Queue).to receive(:all).and_return([queue_1, queue_2, queue_3])
    expect_any_instance_of(Sidekiq::Workers).to receive(:each) do |_, &block|
      [
        [nil, nil, { 'queue' => 'queue_1' }],
        [nil, nil, { 'queue' => 'queue_2' }],
        [nil, nil, { 'queue' => 'queue_1' }],
        [nil, nil, { 'queue' => 'queue_1' }],
        [nil, nil, { 'queue' => 'queue_1' }]
      ].each { |*args| block.call(*args) }
    end

    stats = subject.stats

    expect(stats).to include('queue_1.wip' => 4)
    expect(stats).to include('queue_2.wip' => 1)
    expect(stats).to include('queue_3.wip' => 0)
  end
end

require 'spec_helper'
require 'reporter'

RSpec.describe Reporter do
  subject { described_class.new }

  let(:stats) do
    {
      'queue_1.length' => 10,
      'queue_1.wip' => 1,
      'queue_2.length' => 0,
      'queue_2.wip' => 0
    }
  end

  it 'sends given metrics to HostedGraphite' do
    stats.each_pair do |queue, value|
      expect(subject.graphite).to receive(:send_metric).once.with(queue, value)
    end

    subject.send(stats)
  end

  context 'namespaced' do
    subject { described_class.new namespace: %w(sidekiq test) }

    it 'sends given metrics to HostedGraphite' do
      stats.each_pair do |queue, value|
        expect(subject.graphite).to receive(:send_metric).once.with("sidekiq.test.#{queue}", value)
      end

      subject.send(stats)
    end
  end
end

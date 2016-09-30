class Collector
  def stats
    {}.tap do |metrics|
      Sidekiq::Queue.all.each do |queue|
        metrics[key_for(queue.name, 'length')] = queue.size
        metrics[key_for(queue.name, 'wip')] = 0
      end

      Sidekiq::Workers.new.each do |_process_id, _thread_id, work|
        metrics[key_for(work['queue'], 'wip')] += 1
      end
    end
  end

  private

  def key_for(queue, type)
    [queue, type].join('.')
  end
end

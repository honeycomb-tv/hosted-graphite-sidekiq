class Reporter
  attr_reader :graphite, :namespace

  def initialize(namespace: nil)
    @namespace = namespace
    @graphite = HostedGraphite
  end

  def send(stats)
    stats.each do |key, value|
      graphite.send_metric [*namespace, key].compact.join('.'), value
    end
  end
end

class HGSLogger
  class << self
    attr_accessor :path, :level

    [:debug, :warn, :info, :error].each do |level|
      define_method level do |*args|
        instance.send level, *args
      end
    end

    def instance
      @instance ||= begin
        dir = File.dirname(path)
        FileUtils.mkdir_p dir unless File.exists?(dir)
        FileUtils.touch path

        logger = Logger.new(path)
        logger.level = level
        logger
      end
    end
  end
end

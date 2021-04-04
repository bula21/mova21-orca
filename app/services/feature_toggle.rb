
class FeatureToggle
  class << self
    def with(name, &block)
      block.call if enabled?(name)
    end

    def enabled?(name)
      enabled_features.include?(name.to_sym)
    end

    def enable(name)
      enabled_features << name.to_sym
    end

    def enabled_features
      @enabled_features ||= ENV.fetch('FEATURES', '').split(%r{[,;:]}).map(&:to_sym)
    end
  end
end


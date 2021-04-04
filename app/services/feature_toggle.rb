# frozen_string_literal: true

class FeatureToggle
  class << self
    def with(name)
      yield if enabled?(name)
    end

    def enabled?(name)
      enabled_features.include?(name.to_sym)
    end

    def enable(name)
      enabled_features << name.to_sym
    end

    def enabled_features
      @enabled_features ||= ENV.fetch('FEATURES', '').split(/[,;:]/).map(&:to_sym)
    end
  end
end

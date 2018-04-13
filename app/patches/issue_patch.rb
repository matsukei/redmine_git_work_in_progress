require_dependency 'issue'

module GitWip
  module IssuePatch
    extend ActiveSupport::Concern

    included do
    end

  end
end

GitWip::IssuePatch.tap do |mod|
  Issue.send :include, mod unless Issue.include?(mod)
end

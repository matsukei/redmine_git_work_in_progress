require 'pathname'

module GitWip
  def self.root
    @root ||= Pathname.new File.expand_path('..', File.dirname(__FILE__))
  end
end

# Load patches for Redmine
Rails.configuration.to_prepare do
  Dir[GitWip.root.join('app/patches/**/*_patch.rb')].each { |f| require_dependency f }

  ### e.g. Rewrite existing method
  # require_dependency 'users_helper'
  #
  # module GitWip
  #   module UsersHelperPatch
  #     def user_settings_tabs
  #       TODO
  #     end
  #   end
  # end
  #
  # GitWip::UsersHelperPatch.tap do |mod|
  #   UsersHelper.send :prepend, mod unless UsersHelper.ancestors.include?(mod)
  # end

  ### e.g. Add method only
  # require_dependency 'project'
  #
  # module GitWip
  #   module ProjectPatch
  #     extend ActiveSupport::Concern
  #
  #     included do
  #       has_one :hogehoge, dependent: :destroy
  #       has_many :fugafugas, dependent: :destroy
  #     end
  #   end
  # end
  #
  # GitWip::ProjectPatch.tap do |mod|
  #   Project.send :include, mod unless Project.include?(mod)
  # end
end

Dir[GitWip.root.join('app/hooks/**/*_hook.rb')].each { |f| require_dependency f }
### e.g. See: https://github.com/matsukei/redmine_serial_number_field/tree/master/app/patches

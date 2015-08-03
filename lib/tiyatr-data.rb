module TiyatrData
	Version = File.read(File.expand_path('../../VERSION', __FILE__))
	DefaultApiRoot = 'localhost:3000/api'

	class Configuration
		attr_accessor :api_root
		attr_accessor :access_token
	end

	class << self
		attr_accessor :config

		def configure &block
			@config ||= TiyatrData::Configuration.new
			yield(config)
			config.api_root = DefaultApiRoot unless config.api_root.present?
			config.access_token = 'no access token' unless config.access_token.present?			
		end
	end
	
end

require 'rest-client'
require 'active_support'
require 'active_support/core_ext'

require 'byebug'

require 'tiyatr-data/model'
require 'tiyatr-data/filters'
require 'tiyatr-data/status_codes'
Gem.find_files("tiyatr-data/models/*").each { |path| require path }
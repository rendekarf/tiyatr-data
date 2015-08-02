module TiyatrData
	VERSION = File.read(File.expand_path('../../VERSION', __FILE__))
end

require 'rest-client'
require 'active_support'
require 'active_support/core_ext'

require 'byebug'

require 'tiyatr-data/model'
require 'tiyatr-data/filters'
require 'tiyatr-data/status_codes'
Gem.find_files("tiyatr-data/models/*").each { |path| require path }
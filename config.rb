require 'singleton'
require 'yaml'

class Config
  @@instance = nil

  attr_reader :config

  def initialize
    @config = YAML.load_file('config.yml')
  end

  def self.[](key)
    @@instance ||= Config.new
    puts @@instance.config
    @@instance.config[key]
  end
end
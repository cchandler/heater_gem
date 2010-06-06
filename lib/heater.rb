$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rest_client'
require 'json'
require 'cgi'
require 'singleton'

require 'heater/point_set'
require 'heater/point'

module Heater
  class NoApiKey < Exception
  end
  
  class API
    include Singleton

    API_ENDPOINT = 'http://heater.flatlab.info'.freeze
    VERSION = 1.freeze
    
    attr_accessor :api_key
    attr_accessor :api_endpoint
    
    def api_endpoint
      @api_endpoint = API_ENDPOINT if @api_endpoint.nil?
      @api_endpoint
    end
    
    # def initialize(params)
    #   @api_key = params[:api_key]
    #   @api_endpoint = params[:api_endpoint] || API_ENDPOINT
    # end
    
    def get_api_key(url = 'http://localhost:3000')
      result = JSON.parse(RestClient.post("#{self.api_endpoint}/api_keys", :api_key => {:url => url}).body)
      @api_key = result['api_key']
      result
    end
    
    # def create_point_set(name="MyPointSet")
    #   PointSet.create(name, @api_key, @api_endpoint)
    # end
    # 
    # def find_point_set(name="MyPointSet")
    #   PointSet.find(name, @api_key, @api_endpoint)
    # end
    # 
    # def get_point_sets
    #   JSON.parse(RestClient.get("#{@api_endpoint}/point_sets?api_key=#{@api_key}", :content_type => "application/json").body)
    # end
    
  end
end
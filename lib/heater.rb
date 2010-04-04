$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rest_client'
require 'json'
require 'cgi'

module Heater
  class API

    API_ENDPOINT = 'http://localhost:3000'.freeze
    VERSION = 1.freeze
    
    attr_accessor :api_key

    def initialize(params)
      @api_key = params[:api_key]
    end
    
    def get_api_key(url = 'http://localhost:3000')
      JSON.parse(RestClient.post("#{API_ENDPOINT}/api_keys", :api_key => {:url => url}).body)
    end
    
    def create_point_set(name="MyPointSet")
      JSON.parse(RestClient.post("#{API_ENDPOINT}/point_sets", :point_set => {:name => name}, :api_key => @api_key, :content_type => "application/json").body)
    end
    
    def update_point_set(id, name=nil)
      JSON.parse(RestClient.put("#{API_ENDPOINT}/point_sets/#{id}", :point_set => {:name => name}, :api_key => @api_key ).body)
    end
    
    def delete_point_set(id)
      JSON.parse(RestClient.delete(id, :api_key => @api_key, :content_type => "application/json").body)
    end
    
    def get_point_sets_points(path)
      JSON.parse(RestClient.get(path, :api_key => @api_key, :content_type => "application/json").body)
    end
    
    def add_point_to_set(set, lat, lng)
      JSON.parse(RestClient.post(set, :point => {:lat => lat, :lng => lng}, :api_key => @api_key).body)
    end
    
    def get_points_in_set(set)
      JSON.parse(RestClient.get("#{set}?api_key=#{@api_key}").body)
    end
    
    def delete_point_in_set(point)
      JSON.parse(RestClient.delete("#{point}?api_key=#{@api_key}", :api_key => @api_key, :content_type => "application/json").body)
    end
    
  end
end

class NoApiKey < Exception
end
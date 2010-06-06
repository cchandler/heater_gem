module Heater
  class PointSet
    attr_accessor :id, :name, :created_at, :updated_at, :points
  
    def initialize(options={})
      options.each do |key,value|
        self.send("#{key}=",value) if self.respond_to?(key.to_sym)
      end
    end
  
    def example_url
      result = JSON.parse(RestClient.get("#{Heater::API.instance.api_endpoint}/point_sets/#{@name}/examples.json?api_key=#{Heater::API.instance.api_key}").body)
      result['public_url']
    end
  
    def add_point(lat,lng)
      result = JSON.parse(RestClient.post(@points, :point => {:lat => lat, :lng => lng}, :api_key => Heater::API.instance.api_key).body)
      Point.new(result['point'])
    end
  
    # Must be array of points
    def add_points(points)
      return false unless points.is_a?(Array)
      return false unless points.all? {|item| item.is_a?(Point) }
      result = JSON.parse(RestClient.post(@points, :points => points.to_json, :api_key => Heater::API.instance.api_key).body)
      result
    end
  
    def remove_point(lat,lng)
      JSON.parse(RestClient.delete("#{@points}/(#{lat},#{lng}).json?api_key=#{Heater::API.instance.api_key}", :content_type => "application/json").body)
    end
  
    ### What does this do? :-)
    def get_points_in_set
      JSON.parse(RestClient.get("#{@id}?api_key=#{Heater::API.instance.api_key}").body)
    end
  
    def save
      JSON.parse(RestClient.put("#{@id}", :point_set => {:name => @name}, :api_key => Heater::API.instance.api_key ).body)
    end
  
    def destroy
      JSON.parse(RestClient.delete("#{@id}?api_key=#{Heater::API.instance.api_key}", :api_key => Heater::API.instance.api_key, :content_type => "application/json").body)
    end
  
    def self.create(name)
      result = JSON.parse(RestClient.post("#{Heater::API.instance.api_endpoint}/point_sets", 
        :point_set => {:name => name}, :api_key => Heater::API.instance.api_key, 
        :content_type => "application/json").body)
      
      PointSet.new(result['point_set'])
    end
  
    # def self.find(name,api_key,Heater::API.instance.api_endpoint)
    def self.find(name)
      result = JSON.parse(RestClient.get("#{Heater::API.instance.api_endpoint}/point_sets/#{name}?api_key=#{Heater::API.instance.api_key}").body)
      PointSet.new(result['point_set'])
    end
  
  end
end
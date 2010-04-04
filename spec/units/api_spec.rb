require File.dirname(__FILE__) + '/units_helper'

describe Heater::API do
  before(:each) do
    @api = Heater::API.new({:api_key => 'moo'})
    @valid_api = Heater::API.new( {:api_key => @api.get_api_key['api_key'] })
  end
  
  it "should generate an API key" do
    @api.get_api_key().should have_key('public_read')
  end
  
  it "should generate a pointset" do
    result = @valid_api.create_point_set('test set')
    
    # p result
    result.should have_key('point_set')
    #Nested results
    result = result['point_set']
    result.should have_key('id')
    result.should have_key('points')
    result.should have_key('name')
  end
  
  it "should add a point to a set" do
    result = @valid_api.create_point_set('test set for points')
    result = @valid_api.add_point_to_set(result['point_set']['points'], 33.455, -111.909)['point']
    
    result.should have_key('id')
    result.should have_key('lat')
    result.should have_key('lng')
  end
  
  it "should retrieve points in a set" do
    result = @valid_api.create_point_set('test set for point list')
    @valid_api.add_point_to_set(result['point_set']['points'], 33.455, -111.909)['point']
    result = @valid_api.get_points_in_set(result['point_set']['points'])
    result['points'].size.should == 1
  end
  
  it "should not allow more than 100 points" do
    # result = @valid_api.create_point_set('test set for point list')
    # 101.times do
    #   @valid_api.add_point_to_set(result['point_set']['points'], 33.455, -111.909)['point']
    # end
    
  end
  
  it "should remove points from a set" do
    result = @valid_api.create_point_set('test set for point list')
    @valid_api.add_point_to_set(result['point_set']['points'], 33.455, -111.909)['point']
    point_data = @valid_api.get_points_in_set(result['point_set']['points'])
    @valid_api.delete_point_in_set(point_data['points'].first['id'])
    point_data = @valid_api.get_points_in_set(result['point_set']['points'])
    
    point_data['points'].should be_empty
  end
  
end
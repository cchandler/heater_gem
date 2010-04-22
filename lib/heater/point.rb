class Point
  attr_accessor :lat,:lng
  
  def initialize(options={})
    options.each do |key,value|
      self.send("#{key}=",value) if self.respond_to?(key.to_sym)
    end
  end
  
  
end
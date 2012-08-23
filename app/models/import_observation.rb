class ImportObservation
  class InvalidLookupException < Exception;end
  include Mongoid::Document

  def to_observation
    observation_attributes = lookup_code_to_id(self.attributes)
    observation_attributes.delete("_id")
    Observation.new observation_attributes
  end
  
  
  def self.from_file file, params={}
    imports = case params[:content_type]
    when "application/zip"
      self.from_zip file, params
    when "application/json"
      data = JSON.parse(File.read(file))
      self.from_json data, params
    when "text/csv"
      self.from_csv
    else
      
    end
    imports
  end
  
  def self.from_zip file, params={}
    imports = []
    Zip::ZipFile.open(file) do |z|
      if(z.file.exists?("METADATA"))
        md = YAML.load((z.file.read("METADATA")))
        file = md[:assist_version] == "1.0" ? "aorlich_summer_2012.observations.json" : md[:observations]
      elsif(z.file.exists?("observation.json"))
        file = "observation.json"
      end
      data = ::JSON.parse(z.file.read(file))
      imports = self.from_json(data, params)
    end
    imports
  end
  
  def self.from_json data, params={}
    imports = []
    data.each do |obs|
      obs = JSON.parse(obs)
      obs[:imported_as_cruise_id] = params[:cruise_id] unless params[:cruise_id].nil?
      imports << ImportObservation.new(obs)
    end
    imports
  end
  
private
  def lookup_code_to_id attrs
    attrs.inject(Hash.new) do |h,(k,v)|
      key = k.gsub(/lookup_code$/, "lookup_id")

      if key =~ /lookup_id$/  and not v.nil?
        table = key.gsub(/^thi(n|ck)_ice_lookup_id$/,"ice_lookup_id")
        lookup = table.chomp("_id").camelcase.constantize.where(code: v).first
        raise InvalidLookupException if lookup.nil?
        v = lookup.id
      end
      
      case v.class.to_s
      when "Hash"
        h[key] = lookup_code_to_id(v)
      when "Array"
        h[key] = v.collect{|el| el.is_a?(Hash) ? lookup_code_to_id(el) : el}
      else
        h[key] = v
      end
  
      h
    end
  end
end
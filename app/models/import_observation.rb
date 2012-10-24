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
      self.from_csv file, params
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
      obs = JSON.parse(obs) if obs.is_a? String
      obs[:imported_as_cruise_id] = params[:cruise_id] unless params[:cruise_id].nil?
      imports << ImportObservation.new(obs)
    end
    imports
  end
  
  def self.from_csv file, params={}
    imports = []
    import_map_filename = Rails.root.join("vendor", "csv", "#{params[:filename].split(".").first}.yml")
    import_map_file = ::YAML.load_file(import_map_filename)
  
    csv_data = ::CSV.open(file,{headers: true, return_headers: false, converters: :all})
    
    csv_data.each do |row|
      obs = ImportObservation.new(csv_to_hash(row, import_map_file)) 
      obs[:cruise_id] = params[:cruise_id]
      obs[:ship_name] = Cruise.where(id: params[:cruise_id]).first.try(:ship)
      obs[:hexcode] = Digest::MD5.hexdigest(hexcode_string(obs))
      imports << obs
    end
    imports
  end 
  
  private
  def lookup_code_to_id attrs
    attrs.inject(Hash.new) do |h,(k,v)|
      key = k.to_s.gsub(/lookup_code$/, "lookup_id")

      if key =~ /lookup_id$/ and not v.nil?
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
  
  def self.csv_to_hash(row, mapping)
    data = Hash.new
    mapping.each do |k,v|
      case v.class.to_s
      when "String"
        case k
        when :primary_observer
          el = row[v].split(" ")
          val = {firstname: el.first, lastname: el.last}
        when :additional_observers
          val = []
          row[v].split(":").each do |name|
            el = name.split(" ")
            val << {firstname: el.first, lastname: el.last}
          end
        else
          logger.info("#{k}=#{row[v]} - #{row[v].class}")
          val = row.include?(v) ? row[v] : v
        end
        data[k] = val
      when "Hash"
        data[k] = self.csv_to_hash(row, v)
      when "Array"
        data[k] = v.collect{|i| self.csv_to_hash(row, i) }
      end
    end
    data
  end
  
  def self.hexcode_string obs = {}
    begin
      logger.info(obs.inspect)
      code = "#{obs['obs_datetime']}#{obs['latitude']}#{obs['longitude']}#{obs['primary_observer']['first_name']} #{obs['primary_observer']['last_name']}"
    rescue
      code = ""
    end
    code
  end
end
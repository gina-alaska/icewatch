module Lookupable
  extend ActiveSupport::Concern

  ######################################
  # lookup :thin_ice_lookup, IceLookup #
  ######################################
  # belongs_to :thin_ice_lookup, class_name: IceLookup
  # def thin_ice_lookup_code=(value)
  #   self.send("thin_ice_lookup_id=", IceLookup.where(code: code).first)
  # end
  # def thin_ice_lookup_code
  #   self.send("thin_ice_lookup").try(&:code)
  # end
  class_methods do
    def lookup(name, opts={})
      class_name = (opts[:class_name] || name.to_s.camelize).constantize

      belongs_to name, class_name: class_name

      define_method("#{name}_code=") do |code|
        self.send("#{name}=", class_name.where(code: code).first)
      end

      define_method("#{name}_code") do
        self.send(name).try(&:code)
      end
    end
  end
end
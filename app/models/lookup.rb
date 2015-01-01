class Lookup < ActiveRecord::Base
  validates_presence_of :code, :name
  validates_uniqueness_of :code, {scope: :type}

  def code
    super.send(code_datatype)
  end

  def code_with_name
    "#{code} :: #{name}"
  end

  def code_datatype
    :to_i
  end

end

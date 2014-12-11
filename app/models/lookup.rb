class Lookup < ActiveRecord::Base
  CODE_DATATYPE = :to_i

  validates_presence_of :code, :name
  validates_uniqueness_of :code, {scope: :type}

  def code
    super.send(CODE_DATATYPE)
  end

end

module LookupsHelper

  def sort_by_code lookups
    lookups.sort_by{ |l| l.code.to_i }
  end

end

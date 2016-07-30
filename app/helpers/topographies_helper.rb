module TopographiesHelper
  def concentration_ids
    TopographyLookup.codes_between(200,499).pluck(:id)
  end

  def ridge_ids
    TopographyLookup.codes_between(500,599).pluck(:id)
  end
end

module CruisesHelper
  def ymd(date)
    date.try(:strftime,"%Y-%m-%d") || nil
  end
end

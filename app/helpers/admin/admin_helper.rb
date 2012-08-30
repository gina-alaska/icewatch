module Admin::AdminHelper
  def first_and_last_name observer
   "#{observer['firstname']} #{observer['lastname']}"
  end
end
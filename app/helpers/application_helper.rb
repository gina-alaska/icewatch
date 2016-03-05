module ApplicationHelper
  def assist?
    Rails.application.secrets.icewatch_assist
  end

  def bootstrap_class_for(flash_type)
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym] || "alert-#{flash_type}"
  end

  def flash_messages(opts = {})
    capture do
      concat(content_tag(:div, '', class: 'flash-messages') do
        flash.each do |msg_type, message|
          concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} fade in") do
            concat content_tag(:button, '&times;'.html_safe, class: "close", data: { dismiss: 'alert' })
            concat message
          end)
        end
      end)
    end
  end
end

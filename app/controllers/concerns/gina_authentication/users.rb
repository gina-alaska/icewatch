module GinaAuthentication
  module Users
    extend ActiveSupport::Concern
    
    included do
      before_filter :login_required!
    end

    def disable_provider
      current_user.authorizations.where(provider: params[:provider]).first.try(:destroy)
  
      redirect_to preferences_path
    end
  end
end
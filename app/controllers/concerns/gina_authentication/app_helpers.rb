module GinaAuthentication
  module AppHelpers
    extend ActiveSupport::Concern

    included do
      helper_method :current_user, :signed_in?, :mirror_api
    end

    protected

    def login_required!
      unless signed_in?
        flash[:warning] = 'You must be logged in to view this page'
        redirect_to '/'
      end
    end

    def membership_required!
      unless signed_in? and current_user.member?
        flash[:warning] = 'You do not have permission to view this page'
        redirect_to '/'
      end
    end

    def current_user
      @current_user ||= User.find_by_id(session[:user_id])

      @current_user ||= User.new(name: 'Guest')

      @current_user
    end

    def signed_in?
      !current_user.new_record?
    end


    def current_user=(user)
      @current_user = user
      session[:user_id] = user.id
    end

    def redirect_back_or_default(default_url)
      if session[:redirect_back_to]
        redirect_to session.delete(:redirect_back_to)
      else
        redirect_to default_url
      end
    end
  end
end

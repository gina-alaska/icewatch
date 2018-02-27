module GinaAuthentication
  module Sessions
    extend ActiveSupport::Concern

    def create
      if @auth = Authorization.find_from_hash(auth_hash)
        # Update a user with any new identify information
        @auth.user.update_from_hash!(auth_hash)
      else
        # Create a new user or add an auth to existing user, depending on
        # whether there is already a user signed in.
        @auth = Authorization.create_from_hash(auth_hash, current_user)
        AdminMailer.new_user(@auth.user).deliver_later
      end

      # Log the authorizing user in.
      self.current_user = @auth.user

      if current_user.id
        flash[:success] = 'Logged in succesfully'
      else
        flash[:danger] = 'Unable to create your account, if you have logged in previously using a different method please login using that method instead.'
      end

      redirect_back_or_default('/')
    end

    def destroy
      signout
      flash[:success] = 'You have been logged out'
      redirect_back_or_default('/')
    end

    def failure
      flash[:notice] = params[:message] # if using sinatra-flash or rack-flash
      redirect_to '/'
    end

    protected

    def signout
      session[:user_id] = nil
    end

    def auth_hash
      request.env['omniauth.auth']
    end
  end
end

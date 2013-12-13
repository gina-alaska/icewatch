class Admin::UsersController < AdminController
  before_filter :prevent_self_edit, only: [:edit, :update]
  def index
    @users = User.all
        
    respond_to do |format|
      format.html
    end
  end

  def show
    @user = User.where(id: params[:id]).first

    if @user
      unless @user.update_attributes( authorization_attributes )
        flash[:errors] = @user.errors
      end
      respond_to do |format|
        format.html { render 'users/show'}
      end
      
    end
  end
  
  def approve
    @user = User.where(id:params[:id]).first
    
    if @user
      @user.approved = approve_params
      if @user.save
        respond_to do |format|
          format.html { redirect_to admin_users_url }
        end
      end
    end
  end
  
  def edit
    @user = User.where(id: params[:id]).first
    
    if @user
      respond_to do |format|
        format.html 
      end
    else
      flash[:error] = "That user could not be found"
      redirect_to admin_users_url
    end
  end
  
  def update
    @user = User.where(id: params[:id]).first

    if @user.update_attributes(update_params)
      flash[:notice] = "User successfully updated."
      
      redirect_to admin_users_url
    else
      render 'edit'
    end
  end
  
  def toggle_environment
    cookies[:icewatch_environment] = cookies[:icewatch_environment] == "Live" ? "Development" : "Live"
    redirect_to root_url
  end
  

protected
  def authorization_attributes
    params[:approve]
  end

  def approve_params
    params[:value] == "yes" ? true : false
  end
  
  def update_params
    params[:user].slice(:admin, :approved)
  end

private
  def prevent_self_edit
    @user = User.find(params[:id])
    
    if @user == current_user
      redirect_to user_url(@user)
    end
  end
end
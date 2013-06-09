# encoding: utf-8


class UsersController < BaseController

  before_filter :user_needed!, :only => [:show, :edit, :update]

  # GET /users
  def index
    if (current_user.try(:admin?))
      @users = User.all
      render json: @users, :each_serializer => UserLazySerializer
     end
  end

  # GET /users/:id
  def show
    if params[:id].to_i == current_user.id || current_user.try(:admin?)
      @user = User.find(params[:id])
      render json: @user
    else
      render json: { error: "Permission denied"}, status: 401
    end
  end

  # PUT users/:id
  def update
    @user = User.find(params[:id])
    if(current_user.try(:admin?))
      if @user.update_attributes(params[:user])
       render json: @user
     else
       render :json => {:errors => @user.errors.full_messages}, :status => :unprocessable_entity
     end
    else
      # Password update
      if current_user.id == @user.id and params[:user][:current_password] and @user.update_with_password(params[:user])
        sign_in @user, :bypass => true
        render json: @user
      # Other update
      elsif current_user.id == @user.id and @user.update_attributes(params[:user])
        render json: @user
      else
        render :json => {:errors => @user.errors.full_messages}, :status => :unprocessable_entity
      end
    end
  end

  def edit
    @user = User.find(params[:id])
    render :layout => "pages"
  end

  def destroy
    user = User.find(params[:id])
    if (current_user.try(:admin?) or user ==curent_user)   
      user.destroy
      render json: {success => "User deleted"}, :status => 200
    else
      render json: {Error => "You have to be admin or current user"}, :status => 401
  end

end
end
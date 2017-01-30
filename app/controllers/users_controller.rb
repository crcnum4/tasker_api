class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  # GET /users/1.json
  def show
    render json: @user
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(email: params[:email], username: params[:username].downcase, password: params[:password])

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end
  
  def login
    if params[:username] && params[:password]
      @user = User.find_by_username(params[:username])
      if @user
        if params[:password] == @user.password
          @json = {status: "success", username: @user.username, id: @user.id}
          render json: @json
        else
          @json = {status: "error", message: "username and password did not match"}
          render json: @json, status: :unprocessable_entity
        end
      else
        @json = {status: "error", message: "username not found"}
        render json: @json, status: :unprocessable_entity
      end
    else
      render nothing: true, status: :unauthorized
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      head :no_content
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy

    head :no_content
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.permit(:username, :email, :password)
    end
end

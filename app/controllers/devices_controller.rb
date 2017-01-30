class DevicesController < ApplicationController
  before_action :set_device, only: [:show, :update, :destroy]

  # GET /devices
  # GET /devices.json
  def index
    @devices = Device.all

    render json: @devices
  end

  # GET /devices/1
  # GET /devices/1.json
  def show
    render json: @device
  end

  # POST /devices
  # POST /devices.json
  def create
    @device = Device.new(user_id: params[:user_id], uuid: params[:uuid], model: params[:model])
    token = "0"
    begin
      token = SecureRandom.hex
    end while Device.exists?(token: token)
    @device.token = token
    @device.confirmed = false
    @device.name = params[:name]

    if @device.save
      render json: @device, status: :created, location: devices_url
    else
      render json: @device.errors, status: :unprocessable_entity
    end
  end
  
  def new_device
    if params[:uuid] && params[:username] && params[:model] && params[:name]
      token = 0
      begin
        token = SecureRandom.hex
      end while Device.exists?(token: token)
      user = User.find_by_username(params[:username])
      @device = Device.new(user_id: user.id, uuid: params[:uuid], model: params[:model], name: params[:name], confirmed: false, token: token)
      
      if @device.save
        @json = {status: "success"}
        render json: @json
      else
        @json = {status: "error", message: "failed to save new device"}
        render json: @json, status: :unprocessable_entity
      end
    else
      @json = {status: "error", message: "missing parameters"}
      render json: @json, status: :unprocessable_entity
    end
  end
  
  def get_token
    if params[:username] && params[:uuid]
      @user = User.find_by_username(params[:username])
      @device = Device.find_by_uuid(params[:uuid])
      
      if @device
        if @device.user_id == @user.id
          @json = {status: "success", token: @device.token}
          render json: @json
        else
          @json = {status: "error", message: "device registered to other account. Unregister device to use on this account"}
          render json: @json, status: :unprocessable_entity
        end
      else
        #new device used to log in.
        @json = {status: "new_device"}
        render json: @json
      end
    end
  end
  
  def check_token
    if params[:token] && params[:uuid]
      @device = Device.find_by_token(params[:token])
      if @device
        if @device.confirmed
          if params[:uuid] == @device.uuid
            @json = {status: "success"}
            render json: @json
          else
            @json = {status: "mismatch", message: "authentication does not match device. Please unregister device. (provide other options)"}
            render json: @json, status: :unprocessable_entity
          end
        else
          @json = {status: "unconfirmed", message: "unconfirmed device, check your email"}
          render json: @json, status: :unprocessable_entity
        end
      else
        @json = {status: "bad_token", message: "no device match with authentication"}
        render json: @json, status: :unprocessable_entity
      end
    else
      @json = {status: "error", message: "missing params"}
      render json: @json, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /devices/1
  # PATCH/PUT /devices/1.json
  def update
    @device = Device.find(params[:id])

    if @device.update(device_params)
      head :no_content
    else
      render json: @device.errors, status: :unprocessable_entity
    end
  end

  # DELETE /devices/1
  # DELETE /devices/1.json
  def destroy
    @device.destroy

    head :no_content
  end

  private
  
    def generate_access_token
        begin
            self.token = SecureRandom.hex
        end while self.class.exists?(token: token)
    end

    def set_device
      @device = Device.find(params[:id])
    end

    def device_params
      params.require(:device).permit(:uuid, :model, :confirmed, :name)
    end
end

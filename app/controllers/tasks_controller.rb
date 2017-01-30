class TasksController < ApplicationController
  before_action :set_task, only: [:show, :update, :destroy]
  before_filter :parse_request, :authenticate_user_from_token!

  # GET /tasks
  # GET /tasks.json
  def index
    time = Time.new
    if params[:token]
      @device = Device.find_by_token(params[:token])
      if @device
        if @device.confirmed
          @user = User.find_by_id(@device.user_id)
          if @user
            @tasks = @user.tasks.where(complete: false)
            if @tasks
              @json = {:status => {:status => "success"}, :tasks => @tasks.as_json(:only => [:name, :created_at])}
              render json: @json
            else
              @json = {:status => {:status => "no_tasks"}, :tasks => {:name => "No Tasks", :created_at => time.inspect}}
              render json: @json
            end
          else
            @json = {:status => {:status => "error", :message => "no user found for device."}}
            render json: @json, status: unprocessable_entity
          end
        else
          @json = {:status => {:status => "error", :message => "device not confirmed. check your email."}}
          render json: @json, status: :unprocessable_entity
        end
      else
        @json = {:status => {:status => "error", :message => "no device found for authentication key provided"}}
        render json: @json, status: :unprocessable_entity
      end
    else
      @json = {:status => {:status => "error", :message => "unauthorized connection"}}
      render json: @json, status: :unprocessable_entity
    end
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    render json: @task
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)

    if @task.save
      render json: @task, status: :created, location: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      head :no_content
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy

    head :no_content
  end

  private

    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.permit(:name, :description)
    end
    
    def authenticate_user_from_token!
      if !@json['token']
        render nothing: true, status: :unauthorized
      else
        device = Device.find_by_token(@json['token'])
        @user = User.find(device.user_id)
      end
    end
    
    def parse_request
      @json = params
      puts(params)
    end
end

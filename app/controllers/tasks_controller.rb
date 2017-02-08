class TasksController < ApplicationController
  before_action :set_task, only: [:show, :update, :destroy]
  before_filter :parse_request, :authenticate_user_from_token!

  # GET /tasks
  # GET /tasks.json
  def update_list
    def render_error(message)
      @json = {:status => "error", :message => message}
      render json: @json, status: :unprocessable_entity
    end
    
    if params[:token] && params[:time]
      @device = Device.find_by_token(params[:token])
      if @device
        if @device.confirmed
          @user = User.find_by_id(@device.user_id)
          if @user
            @tasks = Task.created_between(params[:time])
            if @tasks.count > 0
              @json = {:status => {:status => "success"}, :tasks => @tasks.as_json(:only => [:name, :created_at, :id])}
              render json: @json
            else
              @json = {:status => {:status => "no_tasks"}}
              render json: @json
            end
          else
            render_error("No user assigned to device")
          end
        else
          render_error("device not confirmed")
        end
      else
        render_error("device not found")
      end
    else
      render_error("invalid parameters")
    end
  end
  
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
              @json = {:status => {:status => "success"}, :tasks => @tasks.as_json(:only => [:name, :created_at, :id])}
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
    if params[:token] && params[:id]
      @device = Device.find_by_token(params[:token])
      if @device
        if @device.confirmed
          @user = User.find_by_id(@device.user_id)
          if @user
            @task = Task.find_by_id(params[:id])
            if @task
              if @task.user_id == @user.id
                @json = {:status => "success", :name => @task.name, :description => @task.description}
                render json: @json
              else
                @json = {:status => "error", :message => "trying to view another users task"}
                render json: @json, status: :unprocessable_entity
              end
            else
              @json = {:status => "error", :message => "task not found"}
              render json: @json, status: :unprocessable_entity
            end
          else
            @json = {:status => "error", :message => "could not find user registered to device"}
            render json: @json, status: :unprocessable_entity
          end
        else
          @json = {:status => "error", :message => "Device unconfirmed. Please check your email."}
          render json: @json, status: :unprocessable_entity
        end
      else
        @json = {:status => "error", :message => "Un-authorized device"}
        render json: @json, status: :unprocessable_entity
      end
    else
      @json = {:status => "error", :message => "invalid parameters"}
      render json: @json, status: :unprocessable_entity
    end
  end
  
  # GET /tasks/check
  def complete
    if params[:token] && params[:id]
      @device = Device.find_by_token(params[:token])
      if @device
        if @device.confirmed
          @user = User.find_by_id(@device.user_id)
          if @user
            @task = Task.find_by_id(params[:id])
            if @task
              if @task.user_id == @user.id
                if @task.update(complete: true)
                  @json = {:status => "success"}
                  render json: @json
                else
                  @json = {:status => "error", :message => "task failed to complete"}
                  render json: @json, status: :unprocessable_entity
                end
              else
                @json = {:status => "error", :message => "Task does not belong to current user"}
                render json: @json, status: :unprocessable_entity
              end
            else
              @json = {:status => "error", :message => "Task not found"}
              render json: @json, status: :unprocessable_entity
            end
          else
            @json = {:status => "error", :message => "no user assigned to device"}
            render json: @json, status: :unprocessable_entity
          end
        else
          @json = {:status => "error", :message => "Device not confirmed"}
          render json: @json, status: :unprocessable_entity
        end
      else
        @json = {:status => "error", :message => "device not found"}
        render json: @json, status: :unprocessable_entity
      end
    else
      @json = {:status => "error", :message => "incorrect parameters"}
      render json: @json, status: :unprocessable_entity
    end
  end
  

  # POST /tasks
  # POST /tasks.json
  def create
    if params[:token] && params[:name] && params[:description]
      @device = Device.find_by_token(params[:token])
      if @device
        if @device.confirmed
          @user = User.find(@device.user_id)
          if @user
            #user found allowed to create the task
            @task = Task.new(name: params[:name], description: params[:description], complete: false, user_id: @user.id)
            if @task.save
              @json = {:status => "success", :id => "#{@task.id}"}
              render json: @json, status: :unprocessable_entity
            end
          else
            #user not found
            @json = {:status => "error", :message => "no user found for device." }
          end
        else
          # device not confirmed
          @json = {:status => "error", :message => "device not confirmed. check your email"}
          render json: @json, status: :unprocessable_entity
        end
      else
        #token did not match a device.
        @json = {:status => "error", :message => "Invalid Authentication token"}
        render json: @json, status: :unprocessable_entity
        
      end
    else
      @json = {:status => "error", :message => "missing parameters"}
      render json: @json, status: :unprocessable_entity
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

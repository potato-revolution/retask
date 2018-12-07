class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  
  def index
    @tasks = Task.where(user_id: session[:user_id]).page(params[:page]).per(10)
  end
  
  def show
    @task = Task.where(user_id: session[:user_id]).where(id: params[:id]).first
  end
  
  def new
    @task = Task.new
  end
  
  def create
    @task = current_user.tasks.build(task_params)
     if @task.save
       flash[:success] = 'タスクを決定しました。'
       redirect_to root_url
     else
       @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
       flash.now[:danger] = 'タスクの決定に失敗しました。'
       render 'toppages/index'
     end

  end
  
  def edit
  end
  
  def update
    
    if @task.update(task_params)
      flash[:success] = 'タスクは正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'タスクは更新されませんでした'
      render :edit
    end
    
  end
  
  def destroy
    
    @task.destroy

    flash[:success] = 'タスクは正常に削除されました'
    redirect_to tasks_url
  end
  
  private
  
  def set_task
    @task = Task.find(params[:id])
  end
  
  def task_params
    params.require(:task).permit(:content, :status)
  end
  
  
end

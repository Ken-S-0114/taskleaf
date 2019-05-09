class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    # ログインしているユーザーに紐づくTaskだけを表示
    @tasks = current_user.tasks.recent
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    # ログインしているユーザーのidをuser_idに入れた状態でTaskデータを登録
    @task = current_user.tasks.new(task_params)

    if @task.save
      logger.debug "task: #{@task.attributes.inspect}"
      redirect_to tasks_url, notice: "タスク「#{@task.name}」を登録しました．"
    else
      render :new
    end
  end

  def update
    @task.update!(task_params)
    redirect_to tasks_url, notice: "タスク「#{@task.name}」を更新しました．"
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: "タスク「#{@task.name}」を削除しました．"
  end

  def confirm_new
    @task = current_user.tasks.new(task_params)
    render :new unless @task.valid?

  def task_logger
    @task_logger ||= Logger.new('log/task.log', 'daily')
  end

  # task_logger.debug 'taskのログを出力'

  private

  def task_params
    params.require(:task).permit(:name, :description)
  end

  def set_task
    @task = current_user.tasks.find(params[:id])
  end
end

class Admin::OyatsusController < Admin::BaseController
  before_action :set_oyatsu, only: %i[show edit update destroy]

  def index
    @q = Oyatsu.ransack(params[:q])
    @oyatsus = @q.result(distinct: true).order(created_at: :desc).page(params[:page])
  end

  def new
    @oyatsu = Oyatsu.new
  end

  def create
    @oyatsu = Oyatsu.new(oyatsu_params)

    if @oyatsu.save
      redirect_to admin_oyatsu_path(@oyatsu), success: t('.success')
    else
      flash.now[:danger] = t('.failure')
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @oyatsu.update(oyatsu_params)
      redirect_to admin_oyatsus_path, success: t('.success')
    else
      flash.now[:danger] = t('.failure')
      render :edit
    end
  end

  def destroy
    @oyatsu.destroy!
    redirect_to admin_oyatsus_path, success: t('.success')
  end

  private

  def set_oyatsu
    @oyatsu = Oyatsu.find(params[:id])
  end

  def oyatsu_params
    params.require(:oyatsu).permit(:name, :email, :password, :password_confirmation, :role)
  end
end

class Admin::EnsokusController < Admin::BaseController
  before_action :set_ensoku, only: %i[show edit update destroy]

  def index
    @q = Ensoku.ransack(params[:q])
    @ensokus = @q.result(distinct: true).order(created_at: :desc).page(params[:page])
  end

  def show; end

  def edit; end

  def update
    if @ensoku.update(ensoku_params)
      redirect_to admin_ensokus_path, success: t('.success')
    else
      flash.now[:danger] = t('.failure')
      render :edit
    end
  end

  def destroy
    @ensoku.destroy!
    redirect_to admin_ensokus_path, success: t('.success')
  end

  private

  def set_ensoku
    @ensoku = Ensoku.find(params[:id])
  end
end

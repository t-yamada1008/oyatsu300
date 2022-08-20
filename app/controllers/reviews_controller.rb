class ReviewsController < ApplicationController
  before_action :set_oyatsu
  before_action :set_review, only: %i[show edit update destroy]

  # TODO: マイページから行ける、自分の書いたレビュー一覧を見たいけどoyatsuのデータが必要
  def index
    @reviews = Review.where(user_id: current_user.id)
  end

  def new
    @review = Review.new
  end

  def create
    @review = @oyatsu.reviews.new(review_params)
    @review.user_id = current_user.id
    if @review.save
      redirect_to oyatsu_review_path(@oyatsu, @review), success: t('.success')
    else
      flash.now[:danger] = t('.failure')
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @review.update(review_params)
      redirect_to oyatsu_review_path(@oyatsu, @review), success: t('.success')
    else
      flash.now[:danger] = t('.failure')
      render 'edit'
    end
  end

  def destroy
    @review.destroy!
    redirect_to oyatsu_reviews_path, success: t('.success')
  end

  private

  def review_params
    params.require(:review).permit(:comment)
  end

  def set_review
    @review = Review.find(params[:id])
  end

  def set_oyatsu
    @oyatsu = Oyatsu.find(params[:oyatsu_id])
  end
end

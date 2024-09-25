class Api::V1::CategoriesController < ApplicationController
  def index
    @categories = Category.all
    respond_to do |format|
      format.json { render json: @categories }
      format.html { render :index }  # If you have an HTML view
    end
  end
  def show
    @category = Category.find(params[:id])
  end
  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to api_v1_category_path(@category)
    else
      render :new, status: :unprocessable_entity
    end
  end
  private

  def category_params
    params.require(:category).permit(:name, :description)

  end

  def edit
    @category = Category.find(params[:id])
  end
  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      redirect_to api_v1_category_path(@category)
    else
      render :edit, status: :unprocessible_entity
    end

  end
  def destroy

  end
end

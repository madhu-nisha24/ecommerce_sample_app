class Api::V1::ProductsController < ApplicationController
  def index
    puts "Search query:", params[:query]
    Rails.logger.debug "Params: #{params.inspect}"
    if params[:query].present?
      @products = Product.search(params[:query]).records
      #@products = Product.where("name LIKE ?", "%#{params[:query]}%")
      @products.each do |product|
        increment_search_count(product.id)
      end
    else
      @products = Product.all
    end
    @frequent_searches = fetch_frequent_searches
    #redirect_to api_v1_products_path(query: params[:query])
    respond_to do |format|
          format.json { render_json_products}
          format.html { render :index }
        end
  end

  def render_json_products
    render json: @products.select(:id, :name), status: :ok
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to api_v1_product_path(@product)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to api_v1_product_path(@product)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    redirect_to root_path, status: :see_other
  end


  private
  def product_params
    params.require(:product).permit(:category_id, :name, :quantity)
  end

  def search
    if params[:query].present?
      @products = Product.where("name ILIKE ?", "%#{params[:query]}%")
    else
      @products = Product.all
    end
    redirect_to api_v1_products_path(query: params[:query])

  end
  def increment_search_count(product_id)
    # Increment the search count in Redis
    count_key = "search_count:#{product_id}"
    count = $redis.incr(count_key)
    if count > 3
      Rails.cache.write("frequent_searches", fetch_frequent_searches, expires_in: 1.day)
    end
  end

  def fetch_frequent_searches
    # Fetch products searched more than three times
    product_ids = $redis.keys("search_count:*").select do |key|
      $redis.get(key).to_i > 3
    end.map { |key| key.split(":").last }
    puts "product ids:",product_ids
    #Product.where(id: product_ids)
    return Product.where(id: product_ids) if product_ids.any?
    Product.none
  end
end

class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :update, :destroy]

  # GET /products
  def index
    #Se obtienen todos los parametros ignorando los strong params
    allParams = params.to_unsafe_h
    #obtiene los que no son aceptados por la deficion del microservicio
    unpermitted = allParams.slice!(:firstResult, :maxResult, :controller, :action)
    #si hay uno o mas de esos parametros no aceptados, se manda el error
    if unpermitted.length == 0
      if params.has_key?(:firstResult)
        if params.has_key?(:maxResult)
          @products = Product.all.limit(params[:maxResult]).offset(params[:firstResult].to_i - 1)
        else
          @products = Product.all.offset(params[:firstResult].to_i - 1)
        end
      elsif params.has_key?(:maxResult)
        @products = Product.all.limit(params[:maxResult])
      else
        @products = Product.all
      end      
      render json: @products
    else
      render json:
      {
        message: "Not Acceptable (Invalid Params)",
        code: 406,
        description: "Only 'firstResult' and 'maxResult' params are valid."
      }, status: 406
      return
    end
  end

  # GET /products/1
  def show
    unless is_number?(params[:id])
      render json: 
      {
        message: "Not Acceptable (Invalid Params)",
        code: 406,
        description: "Product id must be of type: integer"
      }, status: 406
      return
    end

    unless @product.nil?
      render json: @product
    else
      render json:
      {
        message: "Not Found",
        code: 404,
        description: "Product with id=#{params[:id]} was not found!"
      }, status: 404
      return
    end
  end

  # POST /products
  def create
    @product = Product.new(product_params)

    if @product.save
      render json: @product, status: :created, location: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1
  def update
    unless is_number?(params[:id])
      render json: 
      {
        message: "Not Acceptable (Invalid Params)",
        code: 406,
        description: "Product id must be of type: integer"
      }, status: 406
      return
    end

    #Obtiene una lista de todos los parametros enviados, ignorando los strong params
    allParams = params.to_unsafe_h
    #Si hay parametros adicionales a los necesarios para actualizar, se manda el error.
    unpermitted = allParams.slice!(:name, :description, :price, :stock, :controller, :action, :id, :product)
    #si hay uno o mas parametros no aceptados, se manda el error
    if unpermitted.length == 0
      if @product.nil?
        render json:
        {
          message: "Not Found",
          code: 404,
          description: "Product with id=#{params[:id]} was not found!"
        }, status: 404
        return
      else @product.update(product_params)
        render json:
        {
          message: "No Content"
        }, status: 204
        return
      end
    else
      render json:
        {
          message: "Not Acceptable (Invalid Params)",
          code: 406,
          description: "Parameters: #{unpermitted} not valid"
        }, status: 406
    end
  end

  # DELETE /products/1
  def destroy
    unless is_number?(params[:id])
      render json: 
      {
        message: "Not Acceptable (Invalid Params)",
        code: 406,
        description: "Product id must be of type: integer"
      }, status: 406
      return
    end

    unless @product.nil?
      if @product.destroy
        render json:
        {
          message: "Ok"
        }, status: 200
        return
      end
    else
      render json:
      {
        message: "Not Found",
        code: 404,
        description: "Product with id=#{params[:id]} was not found!"
      }, status: 404
      return
    end    
  end  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find_by( :id => params[:id] )
    end

    def is_number? string
      true if Integer(string) rescue false
    end

    # Only allow a trusted parameter "white list" through.
    def product_params
      params.require(:product).permit(:name, :description, :price, :stock)
    end
end

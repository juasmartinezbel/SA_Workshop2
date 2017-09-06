class SalesController < ApplicationController
  before_action :set_sale, only: [:show, :update, :destroy]

  # GET /sales
  def index
    #Se obtienen todos los parametros ignorando los strong params
    allParams = params.to_unsafe_h
    #obtiene los que no son aceptados por la deficion del microservicio
    unpermitted = allParams.slice!(:firstResult, :maxResult, :controller, :action)
    #si hay uno o mas de esos parametros no aceptados, se manda el error
    if unpermitted.length == 0
      if params.has_key?(:firstResult)
        if params.has_key?(:maxResult)
          @sales = Sale.all.limit(params[:maxResult]).offset(params[:firstResult].to_i - 1)
        else
          @sales = Sale.all.offset(params[:firstResult].to_i - 1)
        end
      elsif params.has_key?(:maxResult)
        @sales = Sale.all.limit(params[:maxResult])
      else
        @sales = Sale.all
      end      
      render json: @sales
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

  # GET /sales/1
  def show
    unless is_number?(params[:id])
      render json: 
      {
        message: "Not Acceptable (Invalid Params)",
        code: 406,
        description: "Sale id must be of type: integer"
      }, status: 406
      return
    end

    unless @sale.nil?
      render json: @sale
    else
      render json:
      {
        message: "Not Found",
        code: 404,
        description: "Sale with id=#{params[:id]} was not found!"
      }, status: 404
      return
    end
  end

  # POST /sales
  def create
    #Obtiene una lista de todos los parametros enviados, ignorando los strong params
    allParams = params.to_unsafe_h
    #Si hay parametros adicionales a los necesarios para actualizar, se manda el error.
    unpermitted = allParams.slice!(:product_id, :user_id, :controller, :action, :sale)
    #si hay uno o mas parametros no aceptados, se manda el error
    if unpermitted.length == 0
      @sale = Sale.new(sale_params)

      if @sale.save
        render json: @sale, status: :created, location: @sale
      else
        render json: @sale.errors, status: :unprocessable_entity
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

  # PATCH/PUT /sales/1
  def update
    unless is_number?(params[:id])
      render json: 
      {
        message: "Not Acceptable (Invalid Params)",
        code: 406,
        description: "Sale id must be of type: integer"
      }, status: 406
      return
    end

    #Obtiene una lista de todos los parametros enviados, ignorando los strong params
    allParams = params.to_unsafe_h
    #Si hay parametros adicionales a los necesarios para actualizar, se manda el error.
    unpermitted = allParams.slice!(:product_id, :user_id, :controller, :action, :id, :sale)
    #si hay uno o mas parametros no aceptados, se manda el error
    if unpermitted.length == 0
      if @sale.nil?
        render json:
        {
          message: "Not Found",
          code: 404,
          description: "Sale with id=#{params[:id]} was not found!"
        }, status: 404
        return
      else @sale.update(sale_params)
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

  # DELETE /sales/1
  def destroy
    unless is_number?(params[:id])
      render json: 
      {
        message: "Not Acceptable (Invalid Params)",
        code: 406,
        description: "Sale id must be of type: integer"
      }, status: 406
      return
    end

    unless @sale.nil?
      if @sale.destroy
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
        description: "Sale with id=#{params[:id]} was not found!"
      }, status: 404
      return
    end    
  end  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sale
      @sale = Sale.find_by( :id => params[:id] )
    end

    def is_number? string
      true if Integer(string) rescue false
    end

    # Only allow a trusted parameter "white list" through.
    def sale_params
      params.require(:sale).permit(:product_id, :user_id)
    end
end

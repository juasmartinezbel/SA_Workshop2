class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /users
  def index
    #Se obtienen todos los parametros ignorando los strong params
    allParams = params.to_unsafe_h
    #obtiene los que no son aceptados por la deficion del microservicio
    unpermitted = allParams.slice!(:firstResult, :maxResult, :controller, :action)
    #si hay uno o mas de esos parametros no aceptados, se manda el error
    if unpermitted.length == 0
      if params.has_key?(:firstResult)
        if params.has_key?(:maxResult)
          @users = User.all.limit(params[:maxResult]).offset(params[:firstResult].to_i - 1)
        else
          @users = User.all.offset(params[:firstResult].to_i - 1)
        end
      elsif params.has_key?(:maxResult)
        @users = User.all.limit(params[:maxResult])
      else
        @users = User.all
      end      
      render json: @users
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

  # GET /users/1
  def show
    unless is_number?(params[:id])
      render json: 
      {
        message: "Not Acceptable (Invalid Params)",
        code: 406,
        description: "User id must be of type: integer"
      }, status: 406
      return
    end

    unless @user.nil?
      render json: @user
    else
      render json:
      {
        message: "Not Found",
        code: 404,
        description: "User with id=#{params[:id]} was not found!"
      }, status: 404
      return
    end
  end

  # POST /users
  def create
    #Obtiene una lista de todos los parametros enviados, ignorando los strong params
    allParams = params.to_unsafe_h
    #Si hay parametros adicionales a los necesarios para actualizar, se manda el error.
    unpermitted = allParams.slice!(:firstName, :lastName, :email, :controller, :action, :user)
    #si hay uno o mas parametros no aceptados, se manda el error
    if unpermitted.length == 0
      @user = User.new(user_params)

      if @user.save
        render json: @user, status: :created, location: @user
      else
        render json: @user.errors, status: :unprocessable_entity
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

  # PATCH/PUT /users/1
  def update
    unless is_number?(params[:id])
      render json: 
      {
        message: "Not Acceptable (Invalid Params)",
        code: 406,
        description: "User id must be of type: integer"
      }, status: 406
      return
    end

    #Obtiene una lista de todos los parametros enviados, ignorando los strong params
    allParams = params.to_unsafe_h
    #Si hay parametros adicionales a los necesarios para actualizar, se manda el error.
    unpermitted = allParams.slice!(:firstName, :lastName, :email, :controller, :action, :id, :user)
    #si hay uno o mas parametros no aceptados, se manda el error
    if unpermitted.length == 0
      if @user.nil?
        render json:
        {
          message: "Not Found",
          code: 404,
          description: "User with id=#{params[:id]} was not found!"
        }, status: 404
        return
      else @user.update(user_params)
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

  # DELETE /users/1
  def destroy
    unless is_number?(params[:id])
      render json: 
      {
        message: "Not Acceptable (Invalid Params)",
        code: 406,
        description: "User id must be of type: integer"
      }, status: 406
      return
    end

    unless @user.nil?
      if @user.destroy
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
        description: "User with id=#{params[:id]} was not found!"
      }, status: 404
      return
    end    
  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find_by( :id => params[:id] )
    end

    def is_number? string
      true if Integer(string) rescue false
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:firstName, :lastName, :email)
    end
end

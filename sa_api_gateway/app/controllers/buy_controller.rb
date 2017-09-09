class BuyController < ApplicationController
	def sale
    @product = params[:product_id]
    @user = params[:user_id]
    result_product = checkProduct(@product)
    result_user = checkUser(@user)

    if result_product.include? "stock" and result_user.include? "firstName"
      prod = JSON.parse(result_product.body)
      if prod['stock'] >= 1
        options = {
          :body => {
            :product_id => @product,
            :user_id => @user
          }.to_json,
          :headers => {
            'Content-Type' => 'application/json'
          }
        }
        newStock = prod['stock'] - 1
        results = HTTParty.post("http://192.168.99.101:3002/sales", options)
        options2 = {
          :body => {
            :stock => newStock
          }.to_json,
          :headers => {
            'Content-Type' => 'application/json'
          }
        }

        results = HTTParty.put("http://192.168.99.101:3000/products/" + @product.to_s, options2)

        render json: 
        {
          message: "Ok",
          code: 201,
          description: "Product sold successfully."
        }, status: 201
        return
      else
        render json:
        {
          message: "No content",
          code: 204,
          description: "There is not enough stock."
        }, status: 204
        return
      end
    else
      render json:
        {
          message: "Bad Request",
          code: 400,
          description: "Invalid request params."
        }, status: 400
        return
    end

	end

  def checkProduct(id)
    results = HTTParty.get("http://192.168.99.101:3000/products/" + id.to_s)
    return results
  end

  def checkUser(id)
    results = HTTParty.get("http://192.168.99.101:3001/users/" + id.to_s)
    return results
  end

  def shopping_history
    @user = params[:id]
    result_user = checkUser(@user)

    if !result_user.include? "firstName"
      render json:
      {
        message: "No content",
        code: 404,
        description: "User not found"
      }, status: 404
      return
    else
      history = HTTParty.get("http://192.168.99.101:3002/sales/user/" + @user.to_s)
      puts history
      if !history.include? "product_id"
        render json:
        {
          message: "No content",
          code: 204,
          description: "Sales not found for user #{params[:id]}"
        }, status: 204
      else
        body = JSON.parse(history.body)
        render json: body
      end
    end
  end
end


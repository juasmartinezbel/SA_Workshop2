class BuyController < ApplicationController
	def sale
    @product = params[:product_id]
    @user = params[:user_id]
    result_product = checkProduct(@product)
    result_user = checkUser(@user)

    if result_product.include? "stock" and result_user.include? "firstName"
      options = {
        :body => {
          :product_id => @product,
          :user_id => @user
        }.to_json,
        :headers => {
          'Content-Type' => 'application/json'
        }
      }
      results = HTTParty.post("http://192.168.99.101:3002/sales", options)
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

end


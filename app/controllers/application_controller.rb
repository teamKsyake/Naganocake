class ApplicationController < ActionController::Base
  protect_form_forgery with: :exception
  
  helper_method :current_cart
  
  def current_cart
    if current_cart
      # ユーザーとカートの紐付け
      current_cart = current_user.cart || current_user.create_cart!
    else
      # セッションとカートの紐付け
      current_cart = Cart.find_by(id: session[:cart_id]) || Cart.create
      session[:cart_id] ||= current_cart.id
    end 
    current_cart
  end 
end

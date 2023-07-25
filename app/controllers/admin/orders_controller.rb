class Admin::OrdersController < ApplicationController
  def show
  end

  def index
    @oreders = Order.page(params[:page]).per(10)
  end
end

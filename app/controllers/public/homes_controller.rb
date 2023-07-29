class Public::HomesController < ApplicationController
  def top
    @items = Item.all.order(created_at: :desc)
    @genres = Genre.all
    @customer = current_customer
  end

  def about
  end
end

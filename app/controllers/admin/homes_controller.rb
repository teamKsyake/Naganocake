class Admin::HomesController < ApplicationController
  def top
    @items =Item.all.order(created_at: desc)
  end 
  end
  
  def about
  end
end

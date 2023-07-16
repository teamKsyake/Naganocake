class Item < ApplicationRecord
  def index
    @items = Item.all
    
  end
end

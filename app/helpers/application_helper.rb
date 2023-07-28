module ApplicationHelper

  module ApplicationHelper
   def order_status_jp(status)
    I18n.t("enums.order.status.#{status}")
   end
  end
end

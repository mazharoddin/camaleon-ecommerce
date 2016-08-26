class Plugins::Ecommerce::ProductItem < ActiveRecord::Base
  include CamaleonCms::Metas
  self.table_name = 'plugins_ecommerce_products'
  belongs_to :cart, class_name: 'Plugins::Ecommerce::Cart', foreign_key: :order_id
  belongs_to :order, class_name: 'Plugins::Ecommerce::Order'
  belongs_to :product, foreign_key: :product_id, class_name: 'CamaleonCms::Post'
  belongs_to :product_variation, class_name: 'Plugins::Ecommerce::ProductVariation'

  def sub_total
    p = self.product.decorate
    (p.price(self.variation_id) + p.tax(self.variation_id)) * self.qty
  end
end

class Plugins::Ecommerce::LegacyCart < CamaleonCms::TermTaxonomy
  default_scope { where(taxonomy: :ecommerce_cart) }
  has_many :products, foreign_key: :objectid, through: :term_relationships, :source => :objects
  belongs_to :site, :class_name => "CamaleonCms::Site", foreign_key: :parent_id

  def add_product(object)
    post_id = defined?(object.id) ? object.id : object.to_i
    term_relationships.where(objectid: post_id).first_or_create if post_id > 0
  end

  # update or set product quantity
  # return true if it is possible to add the quantity
  # return false if quantity is not enough
  def set_product_qty(product, qty)
    _options = self.get_option("product_#{product.id}")
    if qty.to_f <= product.the_qty_real.to_f
      _options['qty'] = qty
      self.set_option("product_#{product.id}", _options)
      true
    else
      false
    end
  end

  def remove_product(object)
    post_id = defined?(object.id) ? object.id : object.to_i
    term_relationships.where(objectid: post_id).destroy_all if post_id > 0
  end

  def the_items_count
    options.map{|k, p| p[:qty].to_i}.inject{|sum,x| sum + x } || 0 rescue 0
  end

  def the_amount_total
    options.map{|k, p| (p[:price].to_f + p[:tax])* p[:qty].to_f}.inject{|sum,x| sum + x } || 0 rescue 0
  end

  # return the price of current cart ($10)
  def the_price
    "#{self.site.decorate.current_unit}#{sprintf('%.2f', the_amount_total)}"
  end

  # set user in filter
  def self.set_user(user)
    user_id = defined?(user.id) ? user.id : user.to_i
    self.where(user_id: user_id)
  end


end

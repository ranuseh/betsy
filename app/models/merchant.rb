class Merchant < ApplicationRecord
  has_many :products
  validates :username, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true

  def self.build_from_github(auth_hash)
    merchant = Merchant.new
    merchant.uid = auth_hash[:uid]
    merchant.provider = 'github'
    merchant.name = auth_hash['info']['name']
    merchant.username = auth_hash['info']['nickname']
    merchant.email = auth_hash['info']['email']

    # Note that the user has not been saved.
    # We'll choose to do the saving outside of this method
    merchant
  end

  def total_revenue
    sum = 0
    self.products.each do |product|
      order_items = OrderItem.where(product_id: product.id)
        order_items.each do |item|
          if item.order.status == "complete" || item.order.status == "paid"
          sum = sum + item.total
          end
        end
    end
    return sum
  end

  def total(type)
    sum = 0
    self.products.each do |product|
      order_items = OrderItem.where(product_id: product.id)
        order_items.each do |item|
          if item.order.status == type
            sum = sum + item.total
          end
        end
    end
    return sum
  end

  def total_orders
    orders = []
    self.products.each do |product|
      order_items = OrderItem.where(product_id: product.id)
        order_items.each do |item|
          if item.order.status == "complete" || item.order.status == "paid"
          orders.push(item.order)
          end
        end
    end
    total = orders.uniq.length
    return total
  end

  def number_orders(type)
    orders = []
    self.products.each do |product|
      order_items = OrderItem.where(product_id: product.id)
        order_items.each do |item|
          if item.order.status == type
            orders.push(item.order)
          end
        end
    end
    total = orders.uniq.length
    return total
  end
end

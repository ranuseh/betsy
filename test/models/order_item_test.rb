require "test_helper"

describe OrderItem do
  describe 'relations' do
    it 'has an order' do
      order_item = order_items(:order_item_one)
      order_item.must_respond_to :order
    end
    it 'has a product' do
      order_item = order_items(:order_item_one)
      order_item.must_respond_to :product
    end
  end

  describe 'validations' do
    it 'requires a quantity' do
      order_item = OrderItem.new
      order_item.valid?.must_equal false
      order_item.errors.messages.must_include :quantity
    end
    it 'requires a quantity greter than 0' do
      order_item = OrderItem.new(product_id: products(:moon), quantity: 0)
      order_item.valid?.must_equal false
      order_item.errors.messages.must_include :quantity
    end
  end

  describe 'custom method' do
    it 'returns a total of an order item' do
      order_item = order_items(:order_item_one)
      order_item.total.must_equal 31998
    end
  end
end

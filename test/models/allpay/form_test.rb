require 'test_helper'
class Allpay::FormTest < ActiveSupport::TestCase
  def setup
    @cart = carts(:my_cart)
    @book = products(:book)
    @order_params = {
      first_name: :Weihang,
      last_name: :Jian,
      address: :Taiwan,
      email: :'tontonyjan@gmail.com'
    }
  end

  test 'item_name' do
    3.times{ CartService.add_product_to_cart @book, @cart }
    order = CartService.create_order_from_cart @cart, @order_params
    transaction = CartService.create_transaction_from_order order
    f = Allpay::Form.new(transaction)
    assert_equal f.item_name, '繼承概念衫 x 20#Ruby on Rails 自習手冊 - 成為鐵道工之路 x 3'
  end

  test 'Mac Value 是正確的' do
    transaction = CartService.create_transaction_from_order orders(:tony_order)
    f = Allpay::Form.new transaction,
      MerchantTradeDate: '2015/02/06 08:07:02',
      MerchantTradeNo: 'xxxyyy'
    assert_equal 'F5F15107D94C95EDDFE7301215C4E50F', f.params[:CheckMacValue]
  end
end

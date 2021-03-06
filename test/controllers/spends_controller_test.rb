require 'test_helper'

class SpendsControllerTest < ActionController::TestCase
  test "spends" do
    transaction_ref = SecureRandom.uuid
    w1 = Wallet.where(ref: "wallet1").first_or_create!
    r1 = Revenue.where(ref: 'food').first_or_create!

    post :create, {
      ref: "ABCD1234",
      wallet: w1.ref,
      revenue: r1.ref,
      amount: 4200,
      data: {
        "k1": "v1"
      },
      token: ENV['TOKEN']
    }

    assert_equal 42_00, r1.balance
    assert_equal -42_00, w1.balance
    assert_equal 0, [w1, r1].map(&:balance).sum

    3.times do
      post :create, {
        ref: "ABCD1234",
        wallet: w1.ref,
        revenue: r1.ref,
        amount: 4200,
        data: {
          "k1": "v1"
        },
        token: ENV['TOKEN']
      }
    end

    assert_equal 42_00, r1.balance
    assert_equal -42_00, w1.balance
    assert_equal 0, [w1, r1].map(&:balance).sum
  end
end

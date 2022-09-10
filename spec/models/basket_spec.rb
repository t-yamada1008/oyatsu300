require 'rails_helper'

RSpec.describe Basket, type: :model do
  it 'is valid with all atttributes' do
    ensoku = create(:ensoku)
    basket = build(:basket, ensoku_id: ensoku.id)
    expect(ensoku).to be_valid
    expect(ensoku.errors).to be_empty
  end

  it 'is invalid without oyatsu_id' do
    ensoku = create(:ensoku)
    basket_without_oyatsu_id = build(:basket, oyatsu_id: '', ensoku_id: ensoku.id)
    expect(basket_without_oyatsu_id).to be_invalid
    expect(basket_without_oyatsu_id.errors[:oyatsu_id]).to eq ["を入力してください"]
  end

  it 'is invalid without ensoku_id' do
    basket_without_ensoku_id = build(:basket, ensoku_id: '')
    expect(basket_without_ensoku_id).to be_invalid
    expect(basket_without_ensoku_id.errors[:ensoku_id]).to eq ["を入力してください"]
  end

  it 'is invalid without quantity' do
    basket_without_quantity = build(:basket, quantity: '')
    expect(basket_without_quantity).to be_invalid
    expect(basket_without_quantity.errors[:quantity]).to eq ["を入力してください", "は数値で入力してください"]
  end

  it 'is invalid negative quantity' do
    basket_negative_quantity = build(:basket, quantity: -1)
    expect(basket_negative_quantity).to be_invalid
    expect(basket_negative_quantity.errors[:quantity]).to eq ["は0より大きい値にしてください"]
  end
end

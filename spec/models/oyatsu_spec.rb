require 'rails_helper'
require 'securerandom'

RSpec.describe Oyatsu, type: :model do
  it 'is valid with all atttributes' do
    oyatsu = create(:oyatsu)
    expect(oyatsu).to be_valid
    expect(oyatsu.errors).to be_empty
  end

  it 'is invalid without name' do
    oyatsu_without_name = build(:oyatsu, name: '')
    expect(oyatsu_without_name).to be_invalid
    expect(oyatsu_without_name.errors[:name]).to eq ["を入力してください"]
  end

  it 'is invalid over name' do
    name = SecureRandom.alphanumeric(101)
    oyatsu_over_name = build(:oyatsu, name: )
    expect(oyatsu_over_name).to be_invalid
    expect(oyatsu_over_name.errors[:name]).to eq ["は100文字以内で入力してください"]
  end

  it 'is valid 100 name' do
    name = SecureRandom.alphanumeric(100)
    oyatsu_over_name = build(:oyatsu, name: )
    expect(oyatsu_over_name).to be_valid
    expect(oyatsu_over_name.errors[:name]).to be_empty
  end

  it 'is invalid without price' do
    oyatsu_without_price = build(:oyatsu, price: '')
    expect(oyatsu_without_price).to be_invalid
    expect(oyatsu_without_price.errors[:price]).to eq ["を入力してください", "は数値で入力してください"]
  end

  it 'is valid 300 price' do
    oyatsu_300_price = build(:oyatsu, price: 300)
    expect(oyatsu_300_price).to be_valid
    expect(oyatsu_300_price.errors[:price]).to be_empty
  end

  it 'is invalid over price' do
    oyatsu_over_price = build(:oyatsu, price: 301)
    expect(oyatsu_over_price).to be_invalid
    expect(oyatsu_over_price.errors[:price]).to eq ["は300以下の値にしてください"]
  end

  it 'is invalid under price' do
    oyatsu_under_price = build(:oyatsu, price: -1)
    expect(oyatsu_under_price).to be_invalid
    expect(oyatsu_under_price.errors[:price]).to eq ["は0以上の値にしてください"]
  end

  it 'is valid 0 price' do
    oyatsu_0_price = build(:oyatsu, price: 0)
    expect(oyatsu_0_price).to be_valid
    expect(oyatsu_0_price.errors[:price]).to be_empty
  end
end

require 'rails_helper'
require 'securerandom'

RSpec.describe Ensoku, type: :model do
  it 'is valid with all atttributes' do
    ensoku = build(:ensoku)
    expect(ensoku).to be_valid
    expect(ensoku.errors).to be_empty
  end

  it 'is invalid without purse' do
    ensoku_without_purse = build(:ensoku, purse: '')
    expect(ensoku_without_purse).to be_invalid
    expect(ensoku_without_purse.errors[:purse]).to eq ["を入力してください", "は数値で入力してください"]
  end

  it 'is valid 300 purse' do
    ensoku_300_purse = build(:ensoku, purse: 300)
    expect(ensoku_300_purse).to be_valid
    expect(ensoku_300_purse.errors[:purse]).to be_empty
  end

  it 'is invalid over purse' do
    ensoku_over_purse = build(:ensoku, purse: 301)
    expect(ensoku_over_purse).to be_invalid
    expect(ensoku_over_purse.errors[:purse]).to eq ["は300以下の値にしてください"]
  end

  it 'is invalid under purse' do
    ensoku_under_purse = build(:ensoku, purse: -1)
    expect(ensoku_under_purse).to be_invalid
    expect(ensoku_under_purse.errors[:purse]).to eq ["は0以上の値にしてください"]
  end

  it 'is valid 0 purse' do
    ensoku_0_purse = build(:ensoku, purse: 0)
    expect(ensoku_0_purse).to be_valid
    expect(ensoku_0_purse.errors[:purse]).to be_empty
  end

  it 'is invalid over_65_535 comment' do
    comment = SecureRandom.alphanumeric(65_536)
    ensoku_over_65535_comment = build(:ensoku, comment: comment)
    expect(ensoku_over_65535_comment).to be_invalid
    expect(ensoku_over_65535_comment.errors[:comment]).to eq ["は65535文字以内で入力してください"]
  end

  it 'is valid 65_535 comment' do
    comment = SecureRandom.alphanumeric(65_535)
    ensoku_over_65535_comment = build(:ensoku, comment: comment)
    expect(ensoku_over_65535_comment).to be_valid
    expect(ensoku_over_65535_comment.errors[:comment]).to be_empty
  end

  it 'is without_status' do
    ensoku_without_status = build(:ensoku, status: '')
    expect(ensoku_without_status).to be_invalid
    expect(ensoku_without_status.errors[:status]).to eq ["を入力してください"]
  end
end

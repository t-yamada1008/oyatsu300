require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with all atttributes' do
    user = build(:user)
    expect(user).to be_valid
    expect(user.errors).to be_empty
  end

  it 'is in valid without name' do
    user_without_name = build(:user, name: '')
    expect(user_without_name).to be_invalid
    expect(user_without_name.errors[:name]).to eq ['をにゅうりょくしてね']
  end

  it 'is invalid without email' do
    user_without_email = build(:user, email: '')
    expect(user_without_email).to be_invalid
    expect(user_without_email.errors[:email]).to eq ['をにゅうりょくしてね']
  end

  it 'is invalid with a duplicate email' do
    user = create(:user)
    user_with_duplcated_email = build(:user, email: user.email)
    expect(user_with_duplcated_email).to be_invalid
    expect(user_with_duplcated_email.errors[:email]).to eq ['はすでにつかわれているよ']
  end

  it 'is invalid without password' do
    user_without_password = build(:user, password: '')
    expect(user_without_password).to be_invalid
    expect(user_without_password.errors[:password]).to eq ["をにゅうりょくしてね", "は「4もじ」いじょうにしてね。"]
  end

  it 'is invalid short password' do
    user_short_password = build(:user, password: 's')
    expect(user_short_password).to be_invalid
    expect(user_short_password.errors[:password]).to eq ["は「4もじ」いじょうにしてね。"]
  end

  it 'is invalid long password' do
    user_long_password = build(:user, password: '123456789123456789')
    expect(user_long_password).to be_invalid
    expect(user_long_password.errors[:password]).to eq ["は「16もじ」いかにしてね。"]
  end

  it 'is invalid without password_confirmation' do
    user_without_password_confirmation = build(:user, password_confirmation: '')
    expect(user_without_password_confirmation).to be_invalid
    expect(user_without_password_confirmation.errors[:password_confirmation]).to eq ["とぱすわーどのにゅうりょくがあわないよ", "をにゅうりょくしてね"]
  end

  it 'is invalid confirmation password_confirmation' do
    user_confirmation_password_confirmation = build(:user, password: 'password', password_confirmation: '012345678')
    expect(user_confirmation_password_confirmation).to be_invalid
    expect(user_confirmation_password_confirmation.errors[:password_confirmation]).to eq ["とぱすわーどのにゅうりょくがあわないよ"]
  end
end

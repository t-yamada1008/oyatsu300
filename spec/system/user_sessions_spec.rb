require 'rails_helper'

RSpec.describe "UserSessions", type: :system do

  let(:user) { create(:user) }

  describe 'ログイン前' do
    xcontext 'Twitterでのログイン' do
      it 'ログイン処理が成功する' do
        # rootに遷移
        visit root_path
        # トグルを押すとリンクが表示
        find('.navbar-toggler-icon').click
        click_link 'ろぐいん'
        # twitter
        click_link 'Twitter'
        expect(page).to have_content 'ろぐいんしたよ'
        expect(current_path).to eq root_path
      end

      it 'ログイン処理が失敗する' do

      end
    end

    context 'フォームでのログイン' do
      it 'ログイン処理が成功する' do
        # rootに遷移
        visit root_path
        # トグルを押すとリンクが表示
        find('.navbar-toggler-icon').click
        click_link 'ろぐいん'
        fill_in 'めーるあどれす', with: user.email
        fill_in 'ぱすわーど', with: 'password'
        click_button 'ろぐいん'
        expect(page).to have_content 'ろぐいんしたよ'
        expect(current_path).to eq root_path
      end

      it 'ログイン処理が失敗する' do
        # rootに遷移
        visit root_path
        # トグルを押すとリンクが表示
        find('.navbar-toggler-icon').click
        click_link 'ろぐいん'
        fill_in 'めーるあどれす', with: ''
        fill_in 'ぱすわーど', with: ''
        click_button 'ろぐいん'
        expect(page).to have_content 'ろぐいんしっぱい！もういちどためしてみてね'
        expect(current_path).to eq login_path
      end
    end
  end

  describe 'ログイン後' do
    context 'ログアウト' do
      it 'ログアウトが成功する' do
        login_as(user)
        find('.navbar-toggler-icon').click
        click_link 'ろぐあうと'
        expect(page).to have_content 'ろぐあうとしたよ'
        expect(current_path).to eq root_path
      end
    end
  end
end

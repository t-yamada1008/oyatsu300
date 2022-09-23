require 'rails_helper'
require 'securerandom'

RSpec.describe "Users", type: :system do

  describe 'ユーザー登録' do
    context '正常系' do
      it 'ユーザー登録が成功する' do
        # rootに遷移
        visit root_path
        # トグルを押すとリンクが表示
        find('.navbar-toggler-icon').click
        click_link 'ろぐいん'
        click_link 'しんきとうろく'
        expect(current_path).to eq new_users_path
        fill_in 'おなまえ', with: 'test'
        fill_in 'めーるあどれす', with: 'test@example.com'
        fill_in 'ぱすわーど', with: 'pass'
        fill_in 'ぱすわーど(かくにん)', with: 'pass'
        click_button 'とうろく'
        expect(page).to have_content 'ろぐいんしたよ'
        expect(current_path).to eq root_path
      end

      it '名前の文字数が128文字の場合、ユーザー登録が成功する' do

        # 128文字の名前を生成
        name_128 = SecureRandom.alphanumeric(128)

        # rootに遷移
        visit root_path
        # トグルを押すとリンクが表示
        find('.navbar-toggler-icon').click
        click_link 'ろぐいん'
        click_link 'しんきとうろく'
        expect(current_path).to eq new_users_path
        fill_in 'おなまえ', with: name_128
        fill_in 'めーるあどれす', with: 'test@example.com'
        fill_in 'ぱすわーど', with: 'password'
        fill_in 'ぱすわーど(かくにん)', with: 'password'
        click_button 'とうろく'
        expect(page).to have_content 'ろぐいんしたよ'
        expect(current_path).to eq root_path
      end

      it 'パスワードの文字数が16文字の場合、ユーザー登録が成功する' do

        # 16文字のパスワードを生成
        pass_16 = SecureRandom.alphanumeric(16)

        # rootに遷移
        visit root_path
        # トグルを押すとリンクが表示
        find('.navbar-toggler-icon').click
        click_link 'ろぐいん'
        click_link 'しんきとうろく'
        expect(current_path).to eq new_users_path
        fill_in 'おなまえ', with: 'test'
        fill_in 'めーるあどれす', with: 'test@example.com'
        fill_in 'ぱすわーど', with: pass_16
        fill_in 'ぱすわーど(かくにん)', with: pass_16
        click_button 'とうろく'
        expect(page).to have_content 'ろぐいんしたよ'
        expect(current_path).to eq root_path
      end
    end

    context '異常系' do

        # email重複用にユーザーを作成
        let!(:user) { create(:user) }

      it 'ユーザー登録に失敗する' do
        # rootに遷移
        visit root_path
        # トグルを押すとリンクが表示
        find('.navbar-toggler-icon').click
        click_link 'ろぐいん'
        click_link 'しんきとうろく'
        expect(current_path).to eq new_users_path
        fill_in 'おなまえ', with: ''
        fill_in 'めーるあどれす', with: ''
        fill_in 'ぱすわーど', with: ''
        fill_in 'ぱすわーど(かくにん)', with: ''
        click_button 'とうろく'
        expect(page).to have_content 'とうろくしっぱい。もういちどためしてみてね。'
        expect(page).to have_content 'おなまえをにゅうりょくしてね'
        expect(page).to have_content 'めーるあどれすをにゅうりょくしてね'
        expect(page).to have_content 'ぱすわーどをにゅうりょくしてね'
        expect(page).to have_content 'ぱすわーどは「4もじ」いじょうにしてね'
        expect(page).to have_content 'ぱすわーど(かくにん)をにゅうりょくしてね'
        expect(current_path).to eq users_path
      end

      it '名前の文字数が128文字を超えた場合、ユーザー登録に失敗する' do
        # 128文字以上のパスワードを生成
        name_over = SecureRandom.alphanumeric(129)

        # rootに遷移
        visit root_path
        # トグルを押すとリンクが表示
        find('.navbar-toggler-icon').click
        click_link 'ろぐいん'
        click_link 'しんきとうろく'
        expect(current_path).to eq new_users_path
        fill_in 'おなまえ', with: name_over
        fill_in 'めーるあどれす', with: ''
        fill_in 'ぱすわーど', with: ''
        fill_in 'ぱすわーど(かくにん)', with: ''
        click_button 'とうろく'
        expect(page).to have_content 'おなまえは「128もじ」いかにしてね'
        expect(current_path).to eq users_path
      end

      it 'メールアドレスが重複している場合、ユーザー登録に失敗する' do

        # rootに遷移
        visit root_path
        # トグルを押すとリンクが表示
        find('.navbar-toggler-icon').click
        click_link 'ろぐいん'
        click_link 'しんきとうろく'
        expect(current_path).to eq new_users_path
        fill_in 'おなまえ', with: 'test'
        fill_in 'めーるあどれす', with: user.email
        fill_in 'ぱすわーど', with: 'pass'
        fill_in 'ぱすわーど(かくにん)', with: 'pass'
        click_button 'とうろく'
        expect(page).to have_content 'めーるあどれすはすでにつかわれているよ'
        expect(current_path).to eq users_path
      end

      it 'パスワードの文字数が16文字を超えた場合、ユーザー登録に失敗する' do

        # 16文字以上のパスワードを生成
        password_over = SecureRandom.alphanumeric(17)

        # rootに遷移
        visit root_path
        # トグルを押すとリンクが表示
        find('.navbar-toggler-icon').click
        click_link 'ろぐいん'
        click_link 'しんきとうろく'
        expect(current_path).to eq new_users_path
        fill_in 'おなまえ', with: ''
        fill_in 'めーるあどれす', with: ''
        fill_in 'ぱすわーど', with: password_over
        fill_in 'ぱすわーど(かくにん)', with: ''
        click_button 'とうろく'
        expect(page).to have_content 'ぱすわーどは「16もじ」いかにしてね'
        expect(current_path).to eq users_path
      end

      it 'パスワードとパスワード確認が異なる場合、ユーザー登録に失敗する' do
        # rootに遷移
        visit root_path
        # トグルを押すとリンクが表示
        find('.navbar-toggler-icon').click
        click_link 'ろぐいん'
        click_link 'しんきとうろく'
        expect(current_path).to eq new_users_path
        fill_in 'おなまえ', with: 'test'
        fill_in 'めーるあどれす', with: 'test@example.com'
        fill_in 'ぱすわーど', with: 'pass'
        fill_in 'ぱすわーど(かくにん)', with: 'word'
        click_button 'とうろく'
        expect(page).to have_content 'ぱすわーど(かくにん)とぱすわーどのにゅうりょくがあわないよ'
      end
    end
  end
end

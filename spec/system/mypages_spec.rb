require 'rails_helper'

RSpec.describe "Mypages", type: :system do

  let!(:user) { create(:user) }

  describe '画面遷移' do
    context 'マイページ画面' do
      it 'マイページが正しく表示される' do
        # ログイン
        login_as(user)
        # マイページに遷移
        # トグルを押すとリンクが表示
        find('.navbar-toggler-icon').click
        click_link "まいぺーじ: #{user.name}"
        expect(current_path).to eq my_page_path
        expect(page).to have_content 'まいぺーじ'
        # カラムが表示されている
        thead = find('thead')
        expect(thead).to have_content 'おなまえ'
        expect(thead).to have_content 'めーるあどれす'
        # 要素検証
        tbody = find('tbody')
        expect(tbody).to have_content user.name
        expect(tbody).to have_content user.email
        # リンクが表示されている
        expect(page).to have_link 'こうしんする'
        expect(page).to have_link 'えらんだおやつをみる'
      end

      it 'えらんだおやつ画面へ正しく遷移できる' do
        # ログイン
        login_as(user)
        # マイページに遷移
        # トグルを押すとリンクが表示
        find('.navbar-toggler-icon').click
        click_link "まいぺーじ: #{user.name}"
        click_link 'えらんだおやつをみる'
        expect(current_path).to eq ensokus_path
      end
    end
  end

  describe 'マイページ情報更新画面' do
    context '正常系' do
      it 'マイページ情報更新画面へ正しく遷移できる' do
        # ログイン
        login_as(user)
        # マイページに遷移
        # トグルを押すとリンクが表示
        find('.navbar-toggler-icon').click
        click_link "まいぺーじ: #{user.name}"
        click_link 'こうしんする'
        expect(current_path).to eq edit_my_page_path
        # 要素検証
        expect(page).to have_content 'ゆーざーじょうほうこうしん'
        expect(page).to have_field 'おなまえ', with: user.name
        expect(page).to have_field 'めーるあどれす', with: user.email
        expect(page).to have_field 'ぱすわーど', with: ''
        expect(page).to have_field 'ぱすわーど(かくにん)', with: ''
        expect(page).to have_button 'こうしん'
      end

      it '正常にマイページを更新し、マイページに遷移できる' do
        # ログイン
        login_as(user)
        # マイページに遷移
        # トグルを押すとリンクが表示
        find('.navbar-toggler-icon').click
        click_link "まいぺーじ: #{user.name}"
        click_link 'こうしんする'
        expect(current_path).to eq edit_my_page_path
        # 要素検証
        fill_in 'おなまえ', with: 'test'
        fill_in 'めーるあどれす', with: 'test@example.com'
        fill_in 'ぱすわーど', with: 'pass'
        fill_in 'ぱすわーど(かくにん)', with: 'pass'
        click_button 'こうしん'
        # mypageに遷移
        expect(page).to have_content 'こうしんしたよ'
        expect(current_path).to eq my_page_path
        # 遷移先の要素検証
        tbody = find('tbody')
        expect(tbody).to have_content 'test'
        expect(tbody).to have_content 'test@example.com'
      end

      it '名前の文字数が128文字の場合、ユーザー登録が成功する' do

        # 128文字の名前を生成
        name_128 = SecureRandom.alphanumeric(128)

        # ログイン
        login_as(user)
        # マイページに遷移
        # トグルを押すとリンクが表示
        find('.navbar-toggler-icon').click
        click_link "まいぺーじ: #{user.name}"
        click_link 'こうしんする'
        expect(current_path).to eq edit_my_page_path
        # 要素検証
        fill_in 'おなまえ', with: name_128
        fill_in 'めーるあどれす', with: 'test@example.com'
        fill_in 'ぱすわーど', with: 'pass'
        fill_in 'ぱすわーど(かくにん)', with: 'pass'
        click_button 'こうしん'
        # mypageに遷移
        expect(page).to have_content 'こうしんしたよ'
        expect(current_path).to eq my_page_path
        # 遷移先の要素検証
        tbody = find('tbody')
        expect(tbody).to have_content name_128
        expect(tbody).to have_content 'test@example.com'
      end

      it 'パスワードの文字数が16文字の場合、ユーザー登録が成功する' do

        # 16文字のパスワードを生成
        pass_16 = SecureRandom.alphanumeric(16)

        # ログイン
        login_as(user)
        # マイページに遷移
        # トグルを押すとリンクが表示
        find('.navbar-toggler-icon').click
        click_link "まいぺーじ: #{user.name}"
        click_link 'こうしんする'
        expect(current_path).to eq edit_my_page_path
        # 要素検証
        fill_in 'おなまえ', with: 'test'
        fill_in 'めーるあどれす', with: 'test@example.com'
        fill_in 'ぱすわーど', with: pass_16
        fill_in 'ぱすわーど(かくにん)', with: pass_16
        click_button 'こうしん'
        # mypageに遷移
        expect(page).to have_content 'こうしんしたよ'
        expect(current_path).to eq my_page_path
        # 遷移先の要素検証
        tbody = find('tbody')
        expect(tbody).to have_content 'test'
        expect(tbody).to have_content 'test@example.com'
      end
    end

    context '異常系' do

      # email重複用にユーザーを作成
      let!(:user_duplicate) { create(:user) }

      it 'フォームに何も情報がない状態で更新をしようとする' do
        # ログイン
        login_as(user)
        # マイページに遷移
        # トグルを押すとリンクが表示
        find('.navbar-toggler-icon').click
        click_link "まいぺーじ: #{user.name}"
        click_link 'こうしんする'
        expect(current_path).to eq edit_my_page_path
        # 要素検証
        fill_in 'おなまえ', with: ''
        fill_in 'めーるあどれす', with: ''
        fill_in 'ぱすわーど', with: ''
        fill_in 'ぱすわーど(かくにん)', with: ''
        click_button 'こうしん'
        # エラーメッセージの検証
        expect(current_path).to eq my_page_path
        expect(page).to have_content 'こうしんしっぱい！もういちどためしてみてね'
        expect(page).to have_content 'おなまえをにゅうりょくしてね'
        expect(page).to have_content 'めーるあどれすをにゅうりょくしてね'
        expect(page).to have_field 'おなまえ', with: ''
        expect(page).to have_field 'めーるあどれす', with: ''
        expect(page).to have_field 'ぱすわーど', with: ''
        expect(page).to have_field 'ぱすわーど(かくにん)', with: ''
      end

      it '名前の文字数が128文字を超えた場合、ユーザー登録に失敗する' do

        # 128文字以上のパスワードを生成
        name_over = SecureRandom.alphanumeric(129)

        # ログイン
        login_as(user)
        # マイページに遷移
        # トグルを押すとリンクが表示
        find('.navbar-toggler-icon').click
        click_link "まいぺーじ: #{user.name}"
        click_link 'こうしんする'
        expect(current_path).to eq edit_my_page_path
        # 要素検証
        fill_in 'おなまえ', with: name_over
        fill_in 'めーるあどれす', with: 'test@example.com'
        fill_in 'ぱすわーど', with: 'pass'
        fill_in 'ぱすわーど(かくにん)', with: 'pass'
        click_button 'こうしん'
        # mypageに遷移
        expect(current_path).to eq my_page_path
        # エラーメッセージを表示
        expect(page).to have_content 'こうしんしっぱい！もういちどためしてみてね'
        expect(page).to have_content 'おなまえは「128もじ」いかにしてね'
        expect(page).to have_field 'おなまえ', with: name_over
        expect(page).to have_field 'めーるあどれす', with: 'test@example.com'
      end

      it 'メールアドレスが重複している場合、ユーザー登録に失敗する' do

        # ログイン
        login_as(user)
        # マイページに遷移
        # トグルを押すとリンクが表示
        find('.navbar-toggler-icon').click
        click_link "まいぺーじ: #{user.name}"
        click_link 'こうしんする'
        expect(current_path).to eq edit_my_page_path
        # 要素検証
        fill_in 'おなまえ', with: 'test'
        fill_in 'めーるあどれす', with: user_duplicate.email
        fill_in 'ぱすわーど', with: 'pass'
        fill_in 'ぱすわーど(かくにん)', with: 'pass'
        click_button 'こうしん'
        # エラーメッセージを表示
        expect(page).to have_content 'こうしんしっぱい！もういちどためしてみてね'
        expect(page).to have_content 'つかわれているよ'
        expect(page).to have_field 'おなまえ', with: 'test'
        expect(page).to have_field 'めーるあどれす', with: user_duplicate.email
      end

      it 'パスワードの文字数が16文字を超えた場合、ユーザー登録に失敗する' do

        # 16文字以上のパスワードを生成
        password_over = SecureRandom.alphanumeric(17)

        # ログイン
        login_as(user)
        # マイページに遷移
        # トグルを押すとリンクが表示
        find('.navbar-toggler-icon').click
        click_link "まいぺーじ: #{user.name}"
        click_link 'こうしんする'
        expect(current_path).to eq edit_my_page_path
        # 要素検証
        fill_in 'おなまえ', with: 'test'
        fill_in 'めーるあどれす', with: 'test@example.com'
        fill_in 'ぱすわーど', with: password_over
        fill_in 'ぱすわーど(かくにん)', with: password_over
        click_button 'こうしん'
        # エラーメッセージを表示
        expect(page).to have_content 'こうしんしっぱい！もういちどためしてみてね'
        expect(page).to have_content 'ぱすわーどは「16もじ」いかにしてね'
        expect(current_path).to eq my_page_path
        expect(page).to have_field 'おなまえ', with: 'test'
        expect(page).to have_field 'めーるあどれす', with: 'test@example.com'
      end

      it 'パスワードとパスワード(確認)が違う状態で更新をしようとする' do
        # ログイン
        login_as(user)
        # マイページに遷移
        # トグルを押すとリンクが表示
        find('.navbar-toggler-icon').click
        click_link "まいぺーじ: #{user.name}"
        click_link 'こうしんする'
        expect(current_path).to eq edit_my_page_path
        # 要素検証
        fill_in 'おなまえ', with: 'test'
        fill_in 'めーるあどれす', with: 'test@example.com'
        fill_in 'ぱすわーど', with: 'pass'
        fill_in 'ぱすわーど(かくにん)', with: 'word'
        click_button 'こうしん'
        # エラーメッセージの検証
        expect(current_path).to eq my_page_path
        expect(page).to have_content 'こうしんしっぱい！もういちどためしてみてね'
        expect(page).to have_content 'ぱすわーど(かくにん)とぱすわーどのにゅうりょくがあわないよ'
        expect(page).to have_field 'ぱすわーど', with: ''
        expect(page).to have_field 'ぱすわーど(かくにん)', with: ''
        expect(page).to have_field 'おなまえ', with: 'test'
        expect(page).to have_field 'めーるあどれす', with: 'test@example.com'
      end
    end
  end
end

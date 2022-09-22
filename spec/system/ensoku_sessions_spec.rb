require 'rails_helper'

# ログインしない場合での挙動をテスト
# 一部領域はensoku_specだが、ログインしていない状態での挙動は全て本テストにて行う
RSpec.describe "EnsokuSessions", type: :system do

  let!(:oyatsu) { create(:oyatsu) }

  describe 'ログインしないでおやつを選択する' do
    describe 'トップ画面' do
      context 'トップからおやつ選択画面に移動' do
        it 'ボタンをクリックするとおやつ選択画面に遷移する' do
          # rootに遷移
          visit root_path
          # あたらしくえらぶボタンを押下
          # ボタンだがBootstrapでそう見えているだけで実質はリンク
          click_link 'あたらしくえらぶ'
          # おやつ選択画面に遷移
          expect(current_path).to eq oyatsus_path
        end
      end

      context 'ヘッダーに関する挙動' do
        it 'ロゴに関する挙動' do
          # rootに遷移
          visit root_path
          # ロゴを押した場合にroot画面に遷移
          link = find('.navbar-brand')
          link.click
          expect(current_path).to eq root_path
        end
      end

      context 'ヘッダーのトグルボタンに関する挙動' do
        it 'みんなのおやつが表示される' do
          # rootに遷移
          visit root_path
          # トグルを押すとリンクが表示
          find('.navbar-toggler-icon').click
          expect(page).to have_link 'みんなのおやつ'
          expect(page).to have_link 'ろぐいん'
        end
        # TODO: user_session_specにテスト項目を移動
        it 'ログイン画面に遷移できる' do
          # rootに遷移
          visit root_path
          # トグルを押すとリンクが表示
          find('.navbar-toggler-icon').click
          expect(page).to have_link 'みんなのおやつ'
          expect(page).to have_link 'ろぐいん'
          click_link 'ろぐいん'
          expect(current_path).to eq login_path
        end
      end

      context 'フッターに関する挙動' do
        it 'プライバシーポリシーに関する挙動' do
          # rootに遷移
          visit root_path
          # プライバシーポリシーに遷移
          link = find('#privacy-policy', text: 'ぷらいばしーぽりしー(おとなむけ)')
          link.click
          # high_voltageでページのパスを出力しているので、リンクをベタ打ちで確認
          expect(current_path).to eq "/privacy_policy"
        end
        it 'お問い合わせに関する挙動' do
          # rootに遷移
          visit root_path
          # お問い合わせに遷移
          link = find('#contact', text: 'おといあわせ(さくしゃのTwitter)')
          link.click
          # twitterに遷移するのでリンクをベタ打ちで確認
          expect(current_path).to eq '/moyazine'
        end
      end
    end

    describe 'おやつ選択画面' do
      context 'おやつ選択画面に移動' do
        it '画面に要素が全て正しく表示される' do
          # おやつ画面に遷移
          visit root_path
          click_link 'あたらしくえらぶ'
          # 残高が正しく表示される
          expect(page).to have_selector '.okozukai', text: 'のこり: 300 えん'
          # おかいけいボタンが表示はされるが、押せない
          expect(page).to have_link 'おかいけい'
          expect(page).to have_selector '#register .disabled', text: 'おかいけい'
          # 検索
          # 価格検索のセレクトボックスに初期項目が表示されている
          expect(page).to have_selector '#q_for_price_over', text: 'ねだん↑'
          expect(page).to have_selector '#q_for_price_under', text: 'ねだん↓'
          # 名前検索のフォームが表示されている
          expect(page).to have_selector '[placeholder=おやつのなまえをいれてね]'
          # 調べるボタンが表示される
          expect(page).to have_button 'しらべる'
          # おやつが表示される
          # バッジが表示されない
          expect(page).to have_selector "#oyatsu-id-#{oyatsu.id}-badge", text: ''
          # おやつ情報が表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu.id}-name", text: oyatsu.name
          expect(page).to have_selector "#oyatsu-id-#{oyatsu.id}-purchase", text: oyatsu.price
          # plusボタンが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu.id}-plus"
          # minusボタンが表示されない
          expect(page).to have_no_selector "#oyatsu-id-#{oyatsu.id}-minus"
        end
      end

      context '+ボタン押下時に関する挙動' do
        it '+ボタンを1回押下する' do
          # おやつ画面に遷移
          visit root_path
          click_link 'あたらしくえらぶ'
          # plusボタンを押下
          link = find("#oyatsu-id-#{oyatsu.id}-plus")
          link.click
          # バッジが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu.id}-badge", text: '1'
          # minusボタンが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu.id}-minus"
          # 残高が変わる
          expect(page).to have_selector '.okozukai', text: 'のこり: 290 えん'
          # おかいけいボタンが押せるようになる
          expect(page).to have_link 'おかいけい'
          expect(page).to have_selector '#register', text: 'おかいけい'
        end

        it '+ボタンを1回押下した後、rootに戻ってから「つづきからえらぶ」を押下し、選択が再開できることを確認する' do
          # おやつ画面に遷移
          visit root_path
          click_link 'あたらしくえらぶ'
          # plusボタンを押下
          link = find("#oyatsu-id-#{oyatsu.id}-plus")
          link.click
          # バッジが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu.id}-badge", text: '1'
          # minusボタンが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu.id}-minus"
          # 残高が変わる
          expect(page).to have_selector '.okozukai', text: 'のこり: 290 えん'
          # おかいけいボタンが押せるようになる
          expect(page).to have_link 'おかいけい'
          expect(page).to have_selector '#register', text: 'おかいけい'
          # おやつ画面にもう一度遷移
          visit root_path
          click_link 'つづきからえらぶ'
          # バッジが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu.id}-badge", text: '1'
          # minusボタンが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu.id}-minus"
          # 残高が変わる
          expect(page).to have_selector '.okozukai', text: 'のこり: 290 えん'
          # おかいけいボタンが押せるようになる
          expect(page).to have_link 'おかいけい'
          expect(page).to have_selector '#register', text: 'おかいけい'
        end

        it '+ボタンを30回押下した後にアラートが表示される' do
          # おやつ画面に遷移
          visit root_path
          click_link 'あたらしくえらぶ'
          # plusボタンを押下
          link = find("#oyatsu-id-#{oyatsu.id}-plus")
          30.times {link.click}
          # バッジが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu.id}-badge", text: '30'
          # minusボタンが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu.id}-minus"
          # 残高が変わる
          expect(page).to have_selector '.okozukai', text: 'のこり: 0 えん'
          # おかいけいボタンが押せるようになる
          expect(page).to have_link 'おかいけい'
          expect(page).to have_selector '#register', text: 'おかいけい'
          link.click
          expect(page.accept_confirm).to have_content 'あれれ、おこずかいがたりないみたい'
        end
      end

      context '-ボタン押下時に関する挙動' do
        it '+ボタンを1回押下した後、-ボタンを押下する' do
          # おやつ画面に遷移
          visit root_path
          click_link 'あたらしくえらぶ'
          # plusボタンを押下
          link = find("#oyatsu-id-#{oyatsu.id}-plus")
          link.click
          # バッジが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu.id}-badge", text: '1'
          # minusボタンが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu.id}-minus"
          # 残高が変わる
          expect(page).to have_selector '.okozukai', text: 'のこり: 290 えん'
          # おかいけいボタンが押せるようになる
          expect(page).to have_link 'おかいけい'
          expect(page).to have_selector '#register', text: 'おかいけい'
          # minusボタンを押下
          link = find("#oyatsu-id-#{oyatsu.id}-minus")
          link.click
          # バッジが消える
          expect(page).to have_selector "#oyatsu-id-#{oyatsu.id}-badge", text: ''
          # minusボタンが表示されなくなる
          expect(page).to have_no_selector "#oyatsu-id-#{oyatsu.id}-minus"
          # 残高が変わる
          expect(page).to have_selector '.okozukai', text: 'のこり: 300 えん'
          # おかいけいボタンが押せないようになる
          expect(page).to have_link 'おかいけい'
          expect(page).to have_selector '#register .disabled', text: 'おかいけい'
        end
      end
    end

    describe ' 検索フォームに関する挙動' do
      context '価格検索のセレクトボックスに関する挙動' do

        let!(:oyatsu_50) { create(:oyatsu, price: 50) }
        let!(:oyatsu_100) { create(:oyatsu, :y100) }
        let!(:oyatsu_150) { create(:oyatsu, :y150) }
        let!(:oyatsu_200) { create(:oyatsu, :y200) }
        let!(:oyatsu_250) { create(:oyatsu, :y250) }
        let!(:oyatsu_300) { create(:oyatsu, :y300) }

        it '無指定の場合、すべてのおやつが表示される' do
          # おやつ画面に遷移
          visit root_path
          click_link 'あたらしくえらぶ'
          # 価格検索のセレクトボックスから50円以上を選択
          select 'ねだん↑', from: 'q_for_price_over'
          select 'ねだん↓', from: 'q_for_price_under'
          click_button 'しらべる'
          # 10円のおやつが表示されない
          expect(page).to have_selector "#oyatsu-id-#{oyatsu.id}-purchase", text: '10 えん'
          # 50円のおやつが表示される
          expect(page).to  have_selector "#oyatsu-id-#{oyatsu_50.id}-purchase", text: '50 えん'
          # 100円のおやつが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu_100.id}-purchase", text: '100 えん'
          # 150円のおやつが表示される
          expect(page).to  have_selector "#oyatsu-id-#{oyatsu_150.id}-purchase", text: '150 えん'
          # 200円のおやつが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu_200.id}-purchase", text: '200 えん'
          # 250円のおやつが表示される
          expect(page).to  have_selector "#oyatsu-id-#{oyatsu_250.id}-purchase", text: '250 えん'
          # 300円のおやつが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu_300.id}-purchase", text: '300 えん'
        end

        it '50円以上のおやつが表示される' do
          # おやつ画面に遷移
          visit root_path
          click_link 'あたらしくえらぶ'
          # 価格検索のセレクトボックスから50円以上を選択
          select '50えん↑', from: 'q_for_price_over'
          click_button 'しらべる'
          # 10円のおやつが表示されない
          expect(page).to have_no_selector "#oyatsu-id-#{oyatsu.id}-purchase", text: '10 えん'
          # 50円のおやつが表示される
          expect(page).to  have_selector "#oyatsu-id-#{oyatsu_50.id}-purchase", text: '50 えん'
          # 100円のおやつが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu_100.id}-purchase", text: '100 えん'
          # 150円のおやつが表示される
          expect(page).to  have_selector "#oyatsu-id-#{oyatsu_150.id}-purchase", text: '150 えん'
          # 200円のおやつが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu_200.id}-purchase", text: '200 えん'
          # 250円のおやつが表示される
          expect(page).to  have_selector "#oyatsu-id-#{oyatsu_250.id}-purchase", text: '250 えん'
          # 300円のおやつが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu_300.id}-purchase", text: '300 えん'
        end

        it '100円以上のおやつが表示される' do
          # おやつ画面に遷移
          visit root_path
          click_link 'あたらしくえらぶ'
          # 価格検索のセレクトボックスから50円以上を選択
          select '100えん↑', from: 'q_for_price_over'
          click_button 'しらべる'
          # 10円のおやつが表示されない
          expect(page).to have_no_selector "#oyatsu-id-#{oyatsu.id}-purchase", text: '10 えん'
          # 50円のおやつが表示されない
          expect(page).to  have_no_selector "#oyatsu-id-#{oyatsu_50.id}-purchase", text: '50 えん'
          # 100円のおやつが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu_100.id}-purchase", text: '100 えん'
          # 150円のおやつが表示される
          expect(page).to  have_selector "#oyatsu-id-#{oyatsu_150.id}-purchase", text: '150 えん'
          # 200円のおやつが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu_200.id}-purchase", text: '200 えん'
          # 250円のおやつが表示される
          expect(page).to  have_selector "#oyatsu-id-#{oyatsu_250.id}-purchase", text: '250 えん'
          # 300円のおやつが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu_300.id}-purchase", text: '300 えん'
        end

        it '150円以上のおやつが表示される' do
          # おやつ画面に遷移
          visit root_path
          click_link 'あたらしくえらぶ'
          # 価格検索のセレクトボックスから50円以上を選択
          select '150えん↑', from: 'q_for_price_over'
          click_button 'しらべる'
          # 10円のおやつが表示されない
          expect(page).to have_no_selector "#oyatsu-id-#{oyatsu.id}-purchase", text: '10 えん'
          # 50円のおやつが表示されない
          expect(page).to  have_no_selector "#oyatsu-id-#{oyatsu_50.id}-purchase", text: '50 えん'
          # 100円のおやつが表示されない
          expect(page).to have_no_selector "#oyatsu-id-#{oyatsu_100.id}-purchase", text: '100 えん'
          # 150円のおやつが表示される
          expect(page).to  have_selector "#oyatsu-id-#{oyatsu_150.id}-purchase", text: '150 えん'
          # 200円のおやつが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu_200.id}-purchase", text: '200 えん'
          # 250円のおやつが表示される
          expect(page).to  have_selector "#oyatsu-id-#{oyatsu_250.id}-purchase", text: '250 えん'
          # 300円のおやつが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu_300.id}-purchase", text: '300 えん'
        end

        it '200円以上のおやつが表示される' do
          # おやつ画面に遷移
          visit root_path
          click_link 'あたらしくえらぶ'
          # 価格検索のセレクトボックスから200円以上を選択
          select '200えん↑', from: 'q_for_price_over'
          click_button 'しらべる'
          # 10円のおやつが表示されない
          expect(page).to have_no_selector "#oyatsu-id-#{oyatsu.id}-purchase", text: '10 えん'
          # 50円のおやつが表示されない
          expect(page).to  have_no_selector "#oyatsu-id-#{oyatsu_50.id}-purchase", text: '50 えん'
          # 100円のおやつが表示されない
          expect(page).to have_no_selector "#oyatsu-id-#{oyatsu_100.id}-purchase", text: '100 えん'
          # 150円のおやつが表示されない
          expect(page).to  have_no_selector "#oyatsu-id-#{oyatsu_150.id}-purchase", text: '150 えん'
          # 200円のおやつが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu_200.id}-purchase", text: '200 えん'
          # 250円のおやつが表示される
          expect(page).to  have_selector "#oyatsu-id-#{oyatsu_250.id}-purchase", text: '250 えん'
          # 300円のおやつが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu_300.id}-purchase", text: '300 えん'
        end

        it '250円以上のおやつが表示される' do
          # おやつ画面に遷移
          visit root_path
          click_link 'あたらしくえらぶ'
          # 価格検索のセレクトボックスから50円以上を選択
          select '250えん↑', from: 'q_for_price_over'
          click_button 'しらべる'
          # 10円のおやつが表示されない
          expect(page).to have_no_selector "#oyatsu-id-#{oyatsu.id}-purchase", text: '10 えん'
          # 50円のおやつが表示されない
          expect(page).to  have_no_selector "#oyatsu-id-#{oyatsu_50.id}-purchase", text: '50 えん'
          # 100円のおやつが表示されない
          expect(page).to have_no_selector "#oyatsu-id-#{oyatsu_100.id}-purchase", text: '100 えん'
          # 150円のおやつが表示される
          expect(page).to  have_no_selector "#oyatsu-id-#{oyatsu_150.id}-purchase", text: '150 えん'
          # 200円のおやつが表示される
          expect(page).to have_no_selector "#oyatsu-id-#{oyatsu_200.id}-purchase", text: '200 えん'
          # 250円のおやつが表示される
          expect(page).to  have_selector "#oyatsu-id-#{oyatsu_250.id}-purchase", text: '250 えん'
          # 300円のおやつが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu_300.id}-purchase", text: '300 えん'
        end

        it '50円以下のおやつが表示される' do
          # おやつ画面に遷移
          visit root_path
          click_link 'あたらしくえらぶ'
          # 価格検索のセレクトボックスから50円以下を選択
          select '50えん↓', from: 'q_for_price_under'
          click_button 'しらべる'
          # 10円のおやつが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu.id}-purchase", text: '10 えん'
          # 50円のおやつが表示される
          expect(page).to  have_selector "#oyatsu-id-#{oyatsu_50.id}-purchase", text: '50 えん'
          # 100円のおやつが表示されない
          expect(page).to have_no_selector "#oyatsu-id-#{oyatsu_100.id}-purchase", text: '100 えん'
          # 150円のおやつが表示されない
          expect(page).to  have_no_selector "#oyatsu-id-#{oyatsu_150.id}-purchase", text: '150 えん'
          # 200円のおやつが表示されない
          expect(page).to have_no_selector "#oyatsu-id-#{oyatsu_200.id}-purchase", text: '200 えん'
          # 250円のおやつが表示されない
          expect(page).to  have_no_selector "#oyatsu-id-#{oyatsu_250.id}-purchase", text: '250 えん'
          # 300円のおやつが表示されない
          expect(page).to have_no_selector "#oyatsu-id-#{oyatsu_300.id}-purchase", text: '300 えん'
        end

        it '100円以下のおやつが表示される' do
          # おやつ画面に遷移
          visit root_path
          click_link 'あたらしくえらぶ'
          # 価格検索のセレクトボックスから50円以下を選択
          select '100えん↓', from: 'q_for_price_under'
          click_button 'しらべる'
          # 10円のおやつが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu.id}-purchase", text: '10 えん'
          # 50円のおやつが表示される
          expect(page).to  have_selector "#oyatsu-id-#{oyatsu_50.id}-purchase", text: '50 えん'
          # 100円のおやつが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu_100.id}-purchase", text: '100 えん'
          # 150円のおやつが表示されない
          expect(page).to  have_no_selector "#oyatsu-id-#{oyatsu_150.id}-purchase", text: '150 えん'
          # 200円のおやつが表示されない
          expect(page).to have_no_selector "#oyatsu-id-#{oyatsu_200.id}-purchase", text: '200 えん'
          # 250円のおやつが表示されない
          expect(page).to  have_no_selector "#oyatsu-id-#{oyatsu_250.id}-purchase", text: '250 えん'
          # 300円のおやつが表示されない
          expect(page).to have_no_selector "#oyatsu-id-#{oyatsu_300.id}-purchase", text: '300 えん'
        end

        it '150円以下のおやつが表示される' do
          # おやつ画面に遷移
          visit root_path
          click_link 'あたらしくえらぶ'
          # 価格検索のセレクトボックスから50円以下を選択
          select '150えん↓', from: 'q_for_price_under'
          click_button 'しらべる'
          # 10円のおやつが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu.id}-purchase", text: '10 えん'
          # 50円のおやつが表示される
          expect(page).to  have_selector "#oyatsu-id-#{oyatsu_50.id}-purchase", text: '50 えん'
          # 100円のおやつが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu_100.id}-purchase", text: '100 えん'
          # 150円のおやつが表示される
          expect(page).to  have_selector "#oyatsu-id-#{oyatsu_150.id}-purchase", text: '150 えん'
          # 200円のおやつが表示されない
          expect(page).to have_no_selector "#oyatsu-id-#{oyatsu_200.id}-purchase", text: '200 えん'
          # 250円のおやつが表示されない
          expect(page).to  have_no_selector "#oyatsu-id-#{oyatsu_250.id}-purchase", text: '250 えん'
          # 300円のおやつが表示されない
          expect(page).to have_no_selector "#oyatsu-id-#{oyatsu_300.id}-purchase", text: '300 えん'
        end

        it '200円以下のおやつが表示される' do
          # おやつ画面に遷移
          visit root_path
          click_link 'あたらしくえらぶ'
          # 価格検索のセレクトボックスから200円以下を選択
          select '200えん↓', from: 'q_for_price_under'
          click_button 'しらべる'
          # 10円のおやつが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu.id}-purchase", text: '10 えん'
          # 50円のおやつが表示される
          expect(page).to  have_selector "#oyatsu-id-#{oyatsu_50.id}-purchase", text: '50 えん'
          # 100円のおやつが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu_100.id}-purchase", text: '100 えん'
          # 150円のおやつが表示される
          expect(page).to  have_selector "#oyatsu-id-#{oyatsu_150.id}-purchase", text: '150 えん'
          # 200円のおやつが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu_200.id}-purchase", text: '200 えん'
          # 250円のおやつが表示されない
          expect(page).to  have_no_selector "#oyatsu-id-#{oyatsu_250.id}-purchase", text: '250 えん'
          # 300円のおやつが表示されない
          expect(page).to have_no_selector "#oyatsu-id-#{oyatsu_300.id}-purchase", text: '300 えん'
        end

        it '250円以下のおやつが表示される' do
          # おやつ画面に遷移
          visit root_path
          click_link 'あたらしくえらぶ'
          # 価格検索のセレクトボックスから50円以下を選択
          select '250えん↓', from: 'q_for_price_under'
          click_button 'しらべる'
          # 10円のおやつが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu.id}-purchase", text: '10 えん'
          # 50円のおやつが表示される
          expect(page).to  have_selector "#oyatsu-id-#{oyatsu_50.id}-purchase", text: '50 えん'
          # 100円のおやつが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu_100.id}-purchase", text: '100 えん'
          # 150円のおやつが表示される
          expect(page).to  have_selector "#oyatsu-id-#{oyatsu_150.id}-purchase", text: '150 えん'
          # 200円のおやつが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu_200.id}-purchase", text: '200 えん'
          # 250円のおやつが表示される
          expect(page).to  have_selector "#oyatsu-id-#{oyatsu_250.id}-purchase", text: '250 えん'
          # 300円のおやつが表示されない
          expect(page).to have_no_selector "#oyatsu-id-#{oyatsu_300.id}-purchase", text: '300 えん'
        end
      end

      context '名前検索のフォームに関する挙動' do

        let!(:oyatsu_umai) { create(:oyatsu, name: 'うまい') }
        let!(:oyatsu_oyatsu) { create(:oyatsu, name: 'おやつ') }

        it 'フォームにうまいと入力' do
          # おやつ画面に遷移
          visit root_path
          click_link 'あたらしくえらぶ'
          # 価格検索のセレクトボックスから50円以下を選択
          fill_in 'q[name_cont]', with: 'うまい'
          click_button 'しらべる'
          expect(find('.oyatsus_field')).to have_content 'うまい'
          expect(find('.oyatsus_field')).to have_no_content 'おやつ'
        end
      end
    end

    describe 'おやつ選択結果確認画面(遠足新規作成画面)' do
      context 'おやつ選択結果確認画面に選択したおやつが全て表示されている' do

        let!(:oyatsu_50) { create(:oyatsu, :y50) }
        let!(:oyatsu_100) { create(:oyatsu, :y100) }
        let!(:oyatsu_150) { create(:oyatsu, :y150) }

        it '1つの品物を入れた状態でおかいけいボタンを押下した際におやつ選択結果画面に遷移する' do
          # おやつ画面に遷移
          visit root_path
          click_link 'あたらしくえらぶ'
          # plusボタンを押下
          link = find("#oyatsu-id-#{oyatsu.id}-plus")
          link.click
          # おかいけいボタンを押下
          click_link 'おかいけい'
          # おやつ選択結果確認画面に遷移
          expect(current_path).to eq new_ensoku_path
          # 残高が表示される
          expect(page).to have_selector '.okozukai', text: 'のこり: 290 えん'
          # えらびなおすボタンが表示される
          expect(page).to have_link 'えらびなおす'
          # コメント欄が非表示
          expect(find('#ensoku_comment', visible: false).value).to eq 'no_comment'
          # 公開非公開が非表示
          expect(find('#ensoku_status', visible: false).value).to eq 'close'
          # おっけー！ボタンが表示される
          expect(page).to have_button 'おっけー！'
          # バッジが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu.id}-badge", text: '1'
          # おかし名が表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu.id}-name", text: "#{oyatsu.name}"
          # フッターが表示されない
          expect(page).to have_no_selector ".card-footer"
        end

        it '複数の品物を入れた状態でおかいけいボタンを押下した際におやつ選択結果画面に遷移する' do
          # おやつ画面に遷移
          visit root_path
          click_link 'あたらしくえらぶ'
          # plusボタンを押下
          link = find("#oyatsu-id-#{oyatsu_50.id}-plus")
          link.click
          link = find("#oyatsu-id-#{oyatsu_100.id}-plus")
          link.click
          link = find("#oyatsu-id-#{oyatsu_150.id}-plus")
          link.click
          # おかいけいボタンを押下
          click_link 'おかいけい'
          # おやつ選択結果確認画面に遷移
          expect(current_path).to eq new_ensoku_path
          # 残高が表示される
          expect(page).to have_selector '.okozukai', text: 'のこり: 0 えん'
          # えらびなおすボタンが表示される
          expect(page).to have_link 'えらびなおす'
          # コメント欄が非表示
          expect(find('#ensoku_comment', visible: false).value).to eq 'no_comment'
          # 公開非公開が非表示
          expect(find('#ensoku_status', visible: false).value).to eq 'close'
          # おっけー！ボタンが表示される
          expect(page).to have_button 'おっけー！'
          # バッジが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu_50.id}-badge", text: '1'
          expect(page).to have_selector "#oyatsu-id-#{oyatsu_100.id}-badge", text: '1'
          expect(page).to have_selector "#oyatsu-id-#{oyatsu_150.id}-badge", text: '1'
          # おかし名が表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu_50.id}-name", text: "#{oyatsu_50.name}"
          expect(page).to have_selector "#oyatsu-id-#{oyatsu_100.id}-name", text: "#{oyatsu_100.name}"
          expect(page).to have_selector "#oyatsu-id-#{oyatsu_150.id}-name", text: "#{oyatsu_150.name}"
          # フッターが表示されない
          expect(page).to have_no_selector ".card-footer"
        end

        it '1つの品物を複数入れた状態でおかいけいボタンを押下した際におやつ選択結果画面に遷移する' do
          # おやつ画面に遷移
          visit root_path
          click_link 'あたらしくえらぶ'
          # plusボタンを押下
          link = find("#oyatsu-id-#{oyatsu.id}-plus")
          3.times { link.click }
          # おかいけいボタンを押下
          click_link 'おかいけい'
          # おやつ選択結果確認画面に遷移
          expect(current_path).to eq new_ensoku_path
          # 残高が表示される
          expect(page).to have_selector '.okozukai', text: 'のこり: 270 えん'
          # えらびなおすボタンが表示される
          expect(page).to have_link 'えらびなおす'
          # コメント欄が非表示
          expect(find('#ensoku_comment', visible: false).value).to eq 'no_comment'
          # 公開非公開が非表示
          expect(find('#ensoku_status', visible: false).value).to eq 'close'
          # おっけー！ボタンが表示される
          expect(page).to have_button 'おっけー！'
          # バッジが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu.id}-badge", text: '3'
          # おかし名が表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu.id}-name", text: "#{oyatsu.name}"
          # フッターが表示されない
          expect(page).to have_no_selector ".card-footer"
        end
      end

      context 'おやつ選択結果確認画面の画面遷移' do
        let!(:oyatsu_50) { create(:oyatsu, :y50) }
        let!(:oyatsu_100) { create(:oyatsu, :y100) }
        let!(:oyatsu_150) { create(:oyatsu, :y150) }

        it 'えらびなおすボタンを押下した際に、選択中の通りのデータがおやつ選択画面に表示されている' do
          # おやつ画面に遷移
          visit root_path
          click_link 'あたらしくえらぶ'
          # plusボタンを押下
          link = find("#oyatsu-id-#{oyatsu_50.id}-plus")
          link.click
          link = find("#oyatsu-id-#{oyatsu_100.id}-plus")
          link.click
          link = find("#oyatsu-id-#{oyatsu_150.id}-plus")
          link.click
          # おかいけいボタンを押下
          click_link 'おかいけい'
          # おやつ選択結果確認画面に遷移
          expect(current_path).to eq new_ensoku_path
          # 残高が表示される
          expect(page).to have_selector '.okozukai', text: 'のこり: 0 えん'
          # えらびなおすボタンを押下
          click_link 'えらびなおす'
          # おやつ選択結果画面に遷移
          expect(current_path).to eq oyatsus_path
          # バッジが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu_50.id}-badge", text: '1'
          expect(page).to have_selector "#oyatsu-id-#{oyatsu_100.id}-badge", text: '1'
          expect(page).to have_selector "#oyatsu-id-#{oyatsu_150.id}-badge", text: '1'
          # おかし名が表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu_50.id}-name", text: "#{oyatsu_50.name}"
          expect(page).to have_selector "#oyatsu-id-#{oyatsu_100.id}-name", text: "#{oyatsu_100.name}"
          expect(page).to have_selector "#oyatsu-id-#{oyatsu_150.id}-name", text: "#{oyatsu_150.name}"
          # minusボタンが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu_50.id}-minus"
          expect(page).to have_selector "#oyatsu-id-#{oyatsu_100.id}-minus"
          expect(page).to have_selector "#oyatsu-id-#{oyatsu_150.id}-minus"
          # 残高が正しく表示される
          expect(page).to have_selector '.okozukai', text: 'のこり: 0 えん'
          # おかいけいボタンが押せるようになる
          expect(page).to have_link 'おかいけい'
          expect(page).to have_selector '#register', text: 'おかいけい'
        end
      end
    end

    describe 'おやつ選択結果画面(遠足結果画面)' do
      context 'おやつ選択結果画面に選択したおやつが全て表示されている' do
        let!(:oyatsu_50) { create(:oyatsu, :y50) }
        let!(:oyatsu_100) { create(:oyatsu, :y100) }
        let!(:oyatsu_150) { create(:oyatsu, :y150) }

        it '1つの品物を入れた状態でおかいけいボタンを押下した際におやつ選択結果画面に遷移する' do
          # おやつ画面に遷移
          visit root_path
          click_link 'あたらしくえらぶ'
          # plusボタンを押下
          link = find("#oyatsu-id-#{oyatsu.id}-plus")
          link.click
          # おかいけいボタンを押下
          click_link 'おかいけい'
          # おやつ選択結果確認画面に遷移
          expect(current_path).to eq new_ensoku_path
          # おっけー！ボタンを押下
          click_button 'おっけー！'
          # 遠足結果画面に遷移
          expect(current_path).to eq ensoku_path(RSpec.configuration.session[:ensoku])
          # フラッシュメッセージが表示される
          expect(page).to have_content 'できたよー！'
          # ツイートボタンが表示される
          expect(page).to have_link 'ついーとする'
          # もういちどえらぶが表示される
          expect(page).to have_link 'もういちどえらぶ'
          # 選択したおやつが表示される
          # バッジが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu.id}-badge", text: '1'
          # おかし名が表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu.id}-name", text: "#{oyatsu.name}"
          # フッターが表示されない
          expect(page).to have_no_selector ".card-footer"
          # 会員登録ボタンが表示される
          expect(page).to have_link 'かいいんとうろく'
          # ログインボタンが表示される
          expect(page).to have_link 'ろぐいん'
        end

        it '複数の品物を入れた状態でおかいけいボタンを押下した際におやつ選択結果画面に遷移する' do
          # おやつ画面に遷移
          visit root_path
          click_link 'あたらしくえらぶ'
          # plusボタンを押下
          link = find("#oyatsu-id-#{oyatsu_50.id}-plus")
          link.click
          link = find("#oyatsu-id-#{oyatsu_100.id}-plus")
          link.click
          link = find("#oyatsu-id-#{oyatsu_150.id}-plus")
          link.click
          # おかいけいボタンを押下
          click_link 'おかいけい'
          # おやつ選択結果確認画面に遷移
          expect(current_path).to eq new_ensoku_path
          # おっけー！ボタンを押下
          click_button 'おっけー！'
          # 遠足結果画面に遷移
          expect(current_path).to eq ensoku_path(RSpec.configuration.session[:ensoku])
          # フラッシュメッセージが表示される
          expect(page).to have_content 'できたよー！'
          # ツイートボタンが表示される
          expect(page).to have_link 'ついーとする'
          # もういちどえらぶが表示される
          expect(page).to have_link 'もういちどえらぶ'
          # 選択したおやつが表示される
          # バッジが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu_50.id}-badge", text: '1'
          expect(page).to have_selector "#oyatsu-id-#{oyatsu_100.id}-badge", text: '1'
          expect(page).to have_selector "#oyatsu-id-#{oyatsu_150.id}-badge", text: '1'
          # おかし名が表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu_50.id}-name", text: "#{oyatsu_50.name}"
          expect(page).to have_selector "#oyatsu-id-#{oyatsu_100.id}-name", text: "#{oyatsu_100.name}"
          expect(page).to have_selector "#oyatsu-id-#{oyatsu_150.id}-name", text: "#{oyatsu_150.name}"
          # フッターが表示されない
          expect(page).to have_no_selector ".card-footer"
          # 会員登録ボタンが表示される
          expect(page).to have_link 'かいいんとうろく'
          # ログインボタンが表示される
          expect(page).to have_link 'ろぐいん'
        end

        it '1つの品物を複数入れた状態でおかいけいボタンを押下した際におやつ選択結果画面に遷移する' do
          # おやつ画面に遷移
          visit root_path
          click_link 'あたらしくえらぶ'
          # plusボタンを押下
          link = find("#oyatsu-id-#{oyatsu.id}-plus")
          3.times { link.click }
          # おかいけいボタンを押下
          click_link 'おかいけい'
          # おやつ選択結果確認画面に遷移
          # kuk/
          expect(current_path).to eq new_ensoku_path
          # おっけー！ボタンを押下
          click_button 'おっけー！'
          # 遠足結果画面に遷移
          expect(current_path).to eq ensoku_path(RSpec.configuration.session[:ensoku])
          # フラッシュメッセージが表示される
          expect(page).to have_content 'できたよー！'
          # ツイートボタンが表示される
          expect(page).to have_link 'ついーとする'
          # もういちどえらぶが表示される
          expect(page).to have_link 'もういちどえらぶ'
          # 選択したおやつが表示される
          # バッジが表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu.id}-badge", text: '3'
          # おかし名が表示される
          expect(page).to have_selector "#oyatsu-id-#{oyatsu.id}-name", text: "#{oyatsu.name}"
          # フッターが表示されない
          expect(page).to have_no_selector ".card-footer"
          # 会員登録ボタンが表示される
          expect(page).to have_link 'かいいんとうろく'
          # ログインボタンが表示される
          expect(page).to have_link 'ろぐいん'
        end
      end

      context 'おやつ選択結果画面からの遷移' do
        it 'twitterのシェアボタンのurlが正しい' do
          # おやつ画面に遷移
          visit root_path
          click_link 'あたらしくえらぶ'
          # plusボタンを押下
          link = find("#oyatsu-id-#{oyatsu.id}-plus")
          link.click
          # おかいけいボタンを押下
          click_link 'おかいけい'
          # おやつ選択結果確認画面に遷移
          expect(current_path).to eq new_ensoku_path
          # おっけー！ボタンを押下
          click_button 'おっけー！'
          # 遠足結果画面に遷移
          expect(current_path).to eq ensoku_path(RSpec.configuration.session[:ensoku])
          # twitterに遷移するのでリンクをベタ打ちで確認
          link = find('#btn-twitter-share')
          expect(link[:href]).to include 'https://twitter.com/share'
        end

        it '「もういちどえらぶ」ボタンを押下する' do
          # おやつ画面に遷移
          visit root_path
          click_link 'あたらしくえらぶ'
          # plusボタンを押下
          link = find("#oyatsu-id-#{oyatsu.id}-plus")
          link.click
          # おかいけいボタンを押下
          click_link 'おかいけい'
          # おやつ選択結果確認画面に遷移
          expect(current_path).to eq new_ensoku_path
          # おっけー！ボタンを押下
          click_button 'おっけー！'
          # 遠足結果画面に遷移
          expect(current_path).to eq ensoku_path(RSpec.configuration.session[:ensoku])
          # 「もういちどえらぶ」ボタンを押下
          click_link 'もういちどえらぶ'
          expect(current_path).to eq root_path
        end

        it '「かいいんとうろく」ボタンを押下する' do
          # おやつ画面に遷移
          visit root_path
          click_link 'あたらしくえらぶ'
          # plusボタンを押下
          link = find("#oyatsu-id-#{oyatsu.id}-plus")
          link.click
          # おかいけいボタンを押下
          click_link 'おかいけい'
          # おやつ選択結果確認画面に遷移
          expect(current_path).to eq new_ensoku_path
          # おっけー！ボタンを押下
          click_button 'おっけー！'
          # 遠足結果画面に遷移
          expect(current_path).to eq ensoku_path(RSpec.configuration.session[:ensoku])
          # 「もういちどえらぶ」ボタンを押下
          click_link 'かいいんとうろく'
          expect(current_path).to eq new_users_path
        end

        it '「ろぐいん」ボタンを押下する' do
          # おやつ画面に遷移
          visit root_path
          click_link 'あたらしくえらぶ'
          # plusボタンを押下
          link = find("#oyatsu-id-#{oyatsu.id}-plus")
          link.click
          # おかいけいボタンを押下
          click_link 'おかいけい'
          # おやつ選択結果確認画面に遷移
          expect(current_path).to eq new_ensoku_path
          # おっけー！ボタンを押下
          click_button 'おっけー！'
          # 遠足結果画面に遷移
          expect(current_path).to eq ensoku_path(RSpec.configuration.session[:ensoku])
          # 「ろぐいん」ボタンを押下
          click_link 'ろぐいん'
          expect(current_path).to eq login_path
        end
      end
    end
  end
end

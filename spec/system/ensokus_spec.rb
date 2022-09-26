require 'rails_helper'

RSpec.describe "Ensokus", type: :system do

  describe '一覧/index' do
    context '正常系' do

      let!(:ensoku) { create(:ensoku) }

      it 'えらんだおやつが表示される' do
        login_as(ensoku.user)
        find('.navbar-toggler-icon').click
        click_link 'えらんだおやつ'
        expect(current_path).to eq ensokus_path
        expect(page).to have_content 'えらんだおやつ'
        # カラムが表示されている
        thead = find('thead')
        expect(thead).to have_content 'ばんごう'
        expect(thead).to have_content 'こめんと'
        expect(thead).to have_content 'こうかいすてーたす'
        expect(thead).to have_content 'のこりのおこづかい'
        expect(thead).to have_content 'しょうさい'
        expect(thead).to have_content 'えらびなおす'
        # 要素検証
        tbody = find('tbody')
        expect(tbody).to have_selector "#ensoku-index-id-#{ensoku.id}-no", text: '1'
        expect(tbody).to have_selector "#ensoku-index-id-#{ensoku.id}-comment", text: ensoku.comment
        expect(tbody).to have_selector "#ensoku-index-id-#{ensoku.id}-status", text: ensoku.status_i18n
        expect(tbody).to have_selector "#ensoku-index-id-#{ensoku.id}-purse", text: ensoku.purse
        see_link = tbody.find("#ensoku-index-id-#{ensoku.id}-see")
        expect(see_link).to have_link 'みる'
        again_link = tbody.find("#ensoku-index-id-#{ensoku.id}-again")
        expect(again_link).to have_link 'そうする'
      end
    end

    context '異常系' do

      let!(:user) { create(:user) }

      it 'えらんだおやつがトグルに表示されない' do
        login_as(user)
        find('.navbar-toggler-icon').click
        expect(page).to have_no_link 'えらんだおやつ'
      end
    end
  end

  describe '詳細/show' do
    context '正常系' do

      let!(:ensoku) { create(:ensoku) }
      let!(:oyatsu) { create(:oyatsu) }
      let!(:basket) { create(:basket, ensoku: ensoku, oyatsu: oyatsu) }

      it 'えらんだおやつ一覧画面から詳細画面に遷移する' do
        login_as(ensoku.user)
        find('.navbar-toggler-icon').click
        click_link 'えらんだおやつ'
        tbody = find('tbody')
        see_link = tbody.find("#ensoku-index-id-#{ensoku.id}-see")
        see_link.click
        expect(current_path).to eq ensoku_path(ensoku)
        expect(page).to have_content 'えらんだおやつ！'
        # ツイートボタンが表示される
        expect(page).to have_link 'ついーとする'
        # もういちどえらぶが表示される
        expect(page).to have_link 'もういちどえらぶ'
        ## テーブルが表示される
        # カラムが表示されている
        thead = find('thead')
        expect(thead).to have_content 'こめんと'
        expect(thead).to have_content 'こうかいすてーたす'
        expect(thead).to have_content 'のこりのおこづかい'
        # 要素が表示されている
        tbody = find('tbody')
        # コメントが表示される
        expect(tbody).to have_content ensoku.comment
        # こうかいすてーたすが表示される
        expect(tbody).to have_content ensoku.status_i18n
        # のこりのおこづかいが表示される
        expect(tbody).to have_content ensoku.purse
        # せっていへんこうボタンが表示される
        expect(page).to have_link 'せっていへんこう'
        # 選択したおやつが表示される
        # バッジが表示される
        expect(page).to have_selector "#oyatsu-id-#{oyatsu.id}-badge", text: '1'
        # おかし名が表示される
        expect(page).to have_selector "#oyatsu-id-#{oyatsu.id}-name", text: "#{oyatsu.name}"
        # フッターが表示されない
        expect(page).to have_no_selector ".card-footer"
        # いちらんにもどるボタンが表示される
        expect(page).to have_link 'いちらんにもどる'
      end

      # TODO
      xit 'ツイートボタンを押下することでツイートができる' do
      end

      it 'もういちどえらぶボタンから、rootに遷移する' do
        login_as(ensoku.user)
        find('.navbar-toggler-icon').click
        click_link 'えらんだおやつ'
        # 詳細画面に遷移
        tbody = find('tbody')
        see_link = tbody.find("#ensoku-index-id-#{ensoku.id}-see")
        see_link.click
        # 「もういちどえらぶ」ボタンを押下
        click_link 'もういちどえらぶ'
        expect(current_path).to eq root_path
      end

      it 'いちらんにもどるボタンからえらんだおやつ一覧に遷移する' do
        login_as(ensoku.user)
        find('.navbar-toggler-icon').click
        click_link 'えらんだおやつ'
        tbody = find('tbody')
        see_link = tbody.find("#ensoku-index-id-#{ensoku.id}-see")
        see_link.click
        # いちらんにもどるボタンを押下
        click_link 'いちらんにもどる'
        expect(current_path).to eq ensokus_path
        expect(page).to have_content 'えらんだおやつ'
      end

      it 'せっていへんこうボタンからおやつ編集画面に遷移する' do
        login_as(ensoku.user)
        find('.navbar-toggler-icon').click
        click_link 'えらんだおやつ'
        tbody = find('tbody')
        see_link = tbody.find("#ensoku-index-id-#{ensoku.id}-see")
        see_link.click
        # せっていへんこうボタンを押下
        click_link 'せっていへんこう'
        expect(current_path).to eq edit_ensoku_path(ensoku)
        expect(page).to have_content 'しゅうせいするよ'
      end

    end
  end

  describe '編集/edit' do
    context '正常系' do

      let!(:ensoku) { create(:ensoku) }
      let!(:oyatsu) { create(:oyatsu) }
      let!(:oyatsu_rechoosed) { create(:oyatsu) }
      let!(:basket) { create(:basket, ensoku: ensoku, oyatsu: oyatsu) }

      it 'えらんだおやつ一覧画面から編集画面に遷移する' do
        login_as(ensoku.user)
        find('.navbar-toggler-icon').click
        click_link 'えらんだおやつ'
        expect(current_path).to eq ensokus_path
        expect(page).to have_content 'えらんだおやつ'
        tbody = find('tbody')
        again_link = tbody.find("#ensoku-index-id-#{ensoku.id}-again")
        again_link.click
        expect(current_path).to eq edit_ensoku_path(ensoku)
        expect(page).to have_content 'しゅうせいするよ'
        # 残高
        expect(page).to have_selector '.okozukai', text: 'のこり: 290 えん'
        # 「えらびなおす」リンクが表示されている
        expect(page).to have_link 'えらびなおす'
        # コメントフォームが表示されている
        # コメントフォームに既存のコメントが表示されている
        expect(page).to have_field 'こめんと', with: ensoku.comment
        # ステータスフォームが表示されている
        # 公開ステータスが選択されている
        expect(page).to have_field 'こうかいすてーたす', with: ensoku.status
        expect(page).to have_field 'こうかいすてーたす', with: 'selecting'
        # 「おっけー！」ボタンが表示されている
        expect(page).to have_button 'おっけー！'
        # 「けしちゃう」リンクが表示されていない
        expect(page).to have_link 'けしちゃう'
        # おやつが表示される
        # バッジが表示される
        expect(page).to have_selector "#oyatsu-id-#{oyatsu.id}-badge", text: '1'
        # おやつ情報が表示される
        expect(page).to have_selector "#oyatsu-id-#{oyatsu.id}-name", text: oyatsu.name
        # footerが表示されない
        expect(page).to have_no_selector ".card-footer"
      end
    end
  end

  describe '更新/update' do
    context '正常系' do

      let!(:ensoku) { create(:ensoku) }
      let!(:oyatsu) { create(:oyatsu) }
      let!(:oyatsu_100) { create(:oyatsu, :y100) }
      let!(:basket) { create(:basket, ensoku: ensoku, oyatsu: oyatsu) }

      it ' コメントとステータスを更新する' do
        login_as(ensoku.user)
        find('.navbar-toggler-icon').click
        click_link 'えらんだおやつ'
        expect(current_path).to eq ensokus_path
        expect(page).to have_content 'えらんだおやつ'
        tbody = find('tbody')
        again_link = tbody.find("#ensoku-index-id-#{ensoku.id}-again")
        again_link.click
        fill_in 'こめんと', with: '更新完了'
        select 'ひとにみせない', from: 'ensoku_status'
        click_button 'おっけー！'
        # 詳細画面に遷移
        expect(current_path).to eq ensoku_path(ensoku)
        expect(page).to have_content 'こうしんしたよー！'
        tbody = find('tbody')
        expect(tbody).to have_content '更新完了'
        expect(tbody).to have_content 'ひとにみせない'
      end

      it 'えらびなおすから再度おやつを選び、選んだおやつが正しく更新されることを確認する' do
        login_as(ensoku.user)
        find('.navbar-toggler-icon').click
        click_link 'えらんだおやつ'
        expect(current_path).to eq ensokus_path
        expect(page).to have_content 'えらんだおやつ'
        tbody = find('tbody')
        again_link = tbody.find("#ensoku-index-id-#{ensoku.id}-again")
        again_link.click
        # 「えらびなおす」リンクを押下する
        click_link 'えらびなおす'
        expect(current_path).to eq oyatsus_path
        # 更新前のminusボタンを押下
        link_minus = find("#oyatsu-id-#{oyatsu.id}-minus")
        link_minus.click
        # 更新後のplusボタンを押下
        link_plus = find("#oyatsu-id-#{oyatsu_100.id}-plus")
        link_plus.click
        # バッジが表示される
        expect(page).to have_selector "#oyatsu-id-#{oyatsu_100.id}-badge", text: '1'
        # 残高が変わる
        expect(page).to have_selector '.okozukai', text: 'のこり: 200 えん'
        # おかいけいボタンを押下
        click_link 'おかいけい'
        # おやつ選択編集確認画面に遷移
        expect(current_path).to eq edit_ensoku_path(ensoku)
        expect(page).to have_content 'しゅうせいするよ'
        # 残高
        expect(page).to have_selector '.okozukai', text: 'のこり: 200 えん'
        # 「えらびなおす」リンクが表示されている
        expect(page).to have_link 'えらびなおす'
        # コメントフォームが表示されている
        # コメントフォームに既存のコメントが表示されている
        expect(page).to have_field 'こめんと', with: ensoku.comment
        # ステータスフォームが表示されている
        # 公開ステータスが選択されている
        expect(page).to have_field 'こうかいすてーたす', with: ensoku.status
        expect(page).to have_field 'こうかいすてーたす', with: 'selecting'
        # 「おっけー！」ボタンが表示されている
        expect(page).to have_button 'おっけー！'
        # 「けしちゃう」リンクが表示されていない
        expect(page).to have_link 'けしちゃう'
        # おやつが表示される
        # バッジが表示される
        expect(page).to have_selector "#oyatsu-id-#{oyatsu_100.id}-badge", text: '1'
        # おやつ情報が表示される
        expect(page).to have_selector "#oyatsu-id-#{oyatsu_100.id}-name", text: oyatsu_100.name
        # footerが表示されない
        expect(page).to have_no_selector ".card-footer"
        # ensokuのコメントとステータスを修正
        fill_in 'こめんと', with: '更新完了'
        select 'ひとにみせない', from: 'ensoku_status'
        click_button 'おっけー！'
        # 詳細画面に遷移
        expect(current_path).to eq ensoku_path(ensoku)
        expect(page).to have_content 'こうしんしたよー！'
        tbody = find('tbody')
        expect(tbody).to have_content '更新完了'
        expect(tbody).to have_content 'ひとにみせない'
        # おやつが表示される
        # バッジが表示される
        expect(page).to have_selector "#oyatsu-id-#{oyatsu_100.id}-badge", text: '1'
        # おやつ情報が表示される
        expect(page).to have_selector "#oyatsu-id-#{oyatsu_100.id}-name", text: oyatsu_100.name
        # footerが表示されない
        expect(page).to have_no_selector ".card-footer"
      end
    end
  end

  describe '削除/削除' do
    context '正常系' do

      let!(:ensoku) { create(:ensoku) }
      let!(:oyatsu) { create(:oyatsu) }
      let!(:basket) { create(:basket, ensoku: ensoku, oyatsu: oyatsu) }

      fit '選んだおやつが削除できることを確認する' do
        login_as(ensoku.user)
        find('.navbar-toggler-icon').click
        click_link 'えらんだおやつ'
        expect(current_path).to eq ensokus_path
        expect(page).to have_content 'えらんだおやつ'
        tbody = find('tbody')
        again_link = tbody.find("#ensoku-index-id-#{ensoku.id}-again")
        again_link.click
        click_link 'せっていへんこう'
        # 削除ボタンを押下
        click_link 'けしちゃう'
        expect(page).to have_content 'ほんとうにだいじょうぶ？'
      end

      it '確認ダイアログでいいえを押下する' do

      end
    end
  end
end

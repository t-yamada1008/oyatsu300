equire 'rails_helper'

# みんなのおやつでの挙動をテスト
RSpec.describe "EveryoneOyatsus", type: :system do

  describe '一覧画面' do
    context 'みんなのおやつにデータが存在する' do

      let!(:ensoku_unpublished) { create(:ensoku, :unpublished) }
      let!(:ensoku_published) { create(:ensoku, :published) }

      it '正常にみんなのおやつの一覧画面が表示されている' do
        # rootに遷移
        visit root_path
        # トグルを押すとリンクが表示
        find('.navbar-toggler-icon').click
        expect(page).to have_link 'みんなのおやつ'
        expect(page).to have_link 'ろぐいん'
        click_link 'みんなのおやつ'
        expect(current_path).to eq everyone_oyatsus_path
        expect(page).to have_content 'みんなのおやつ'
        # カラムが表示されている
        thead = find('thead')
        expect(thead).to have_content 'おなまえ'
        expect(thead).to have_content 'こめんと'
        expect(thead).to have_content 'のこりのおこづかい'
        expect(thead).to have_content 'みる？'
        # 要素検証
        tbody = find('tbody')
        # publishedが表示されている
        expect(tbody).to have_selector "#everyone-oyatsu-ensoku-id-#{ensoku_published.id}-name", text: ensoku_published.user.name
        expect(tbody).to have_selector "#everyone-oyatsu-ensoku-id-#{ensoku_published.id}-comment", text: ensoku_published.comment
        expect(tbody).to have_selector "#everyone-oyatsu-ensoku-id-#{ensoku_published.id}-purse", text: ensoku_published.purse
        see_link = tbody.find("#everyone-oyatsu-ensoku-id-#{ensoku_published.id}-see")
        expect(see_link).to have_link 'みてあげる'
        # unpublishedが表示されていない
        expect(tbody).to have_no_selector "#everyone-oyatsu-ensoku-id-#{ensoku_unpublished.id}-name", text: ensoku_unpublished.user.name
        expect(tbody).to have_no_selector "#everyone-oyatsu-ensoku-id-#{ensoku_unpublished.id}-comment", text: ensoku_unpublished.comment
        expect(tbody).to have_no_selector "#everyone-oyatsu-ensoku-id-#{ensoku_unpublished.id}-purse", text: ensoku_unpublished.purse
        expect(tbody).to have_no_selector "#everyone-oyatsu-ensoku-id-#{ensoku_unpublished.id}-see"
      end
    end

    context 'みんなのおやつにデータが存在しない' do

      let!(:ensoku_unpublished) { create(:ensoku, :unpublished) }

      it 'みんなのおやつに公開される情報がなにもない' do
        # rootに遷移
        visit root_path
        # トグルを押すとリンクが表示
        find('.navbar-toggler-icon').click
        expect(page).to have_link 'みんなのおやつ'
        expect(page).to have_link 'ろぐいん'
        click_link 'みんなのおやつ'
        expect(current_path).to eq everyone_oyatsus_path
        expect(page).to have_content 'みんなのおやつ'
        # カラムが表示されない
        expect(page).to have_no_content 'おなまえ'
        expect(page).to have_no_content 'こめんと'
        expect(page).to have_no_content 'のこりのおこづかい'
        expect(page).to have_no_content 'みる？'
        # unpublishedが表示されていない
        expect(page).to have_no_selector "#everyone-oyatsu-ensoku-id-#{ensoku_unpublished.id}-name", text: ensoku_unpublished.user.name
        expect(page).to have_no_selector "#everyone-oyatsu-ensoku-id-#{ensoku_unpublished.id}-comment", text: ensoku_unpublished.comment
        expect(page).to have_no_selector "#everyone-oyatsu-ensoku-id-#{ensoku_unpublished.id}-purse", text: ensoku_unpublished.purse
        expect(page).to have_no_selector "#everyone-oyatsu-ensoku-id-#{ensoku_unpublished.id}-see"
        # コメントが表示されている
        expect(page).to have_content 'きみがいちばんのりだ！'
      end
    end
  end

  describe '詳細画面' do

    let!(:ensoku_published) { create(:ensoku, :published) }
    let!(:oyatsu) { create(:oyatsu) }
    let!(:basket) { create(:basket, ensoku: ensoku_published, oyatsu: oyatsu) }

    context 'ログインしていない場合' do

      # 設定変更ボタンが存在しない
      it 'えらんだおやつが表示される' do
        # みんなのおやつに遷移
        visit everyone_oyatsus_path
        tbody = find('tbody')
        # みてあげるボタンを押下
        see_link = tbody.find("#everyone-oyatsu-ensoku-id-#{ensoku_published.id}-see")
        see_link.click
        expect(page).to have_content "#{ensoku_published.user.name}のおやつ"
        # 残高
        expect(page).to have_selector '.okozukai', text: 'のこり: 290 えん'
        # カラムが表示されている
        thead = find('thead')
        expect(thead).to have_content 'こめんと'
        # 要素が表示されている
        tbody = find('tbody')
        # publishedが表示されている
        expect(tbody).to have_selector "#everyone-oyatsu-ensoku-id-#{ensoku_published.id}-comment", text: ensoku_published.comment
        # 「みんなのおやつにもどる」リンクが表示されている
        expect(page).to have_link 'みんなのおやつにもどる'
        # 「せっていへんこう」リンクが表示されていない
        expect(page).to have_no_link 'せっていへんこう'
        # おやつが表示される
        # バッジが表示される
        expect(page).to have_selector "#oyatsu-id-#{oyatsu.id}-badge", text: '1'
        # おやつ情報が表示される
        expect(page).to have_selector "#oyatsu-id-#{oyatsu.id}-name", text: oyatsu.name
        # footerが表示されない
        expect(page).to have_no_selector ".card-footer"
      end
    end

    context 'ログインしている場合' do

      before { login_as(ensoku_published.user) }

      # 設定変更ボタンが存在する
      it 'えらんだおやつが表示される' do
        # みんなのおやつに遷移
        visit everyone_oyatsus_path
        tbody = find('tbody')
        # みてあげるボタンを押下
        see_link = tbody.find("#everyone-oyatsu-ensoku-id-#{ensoku_published.id}-see")
        see_link.click
        expect(page).to have_content "#{ensoku_published.user.name}のおやつ"
        expect(page).to have_selector '.okozukai', text: 'のこり: 290 えん'
        # カラムが表示されている
        thead = find('thead')
        expect(thead).to have_content 'こめんと'
        # 要素が表示されている
        tbody = find('tbody')
        # publishedが表示されている
        expect(tbody).to have_selector "#everyone-oyatsu-ensoku-id-#{ensoku_published.id}-comment", text: ensoku_published.comment
        # 「みんなのおやつにもどる」リンクが表示されている
        expect(page).to have_link 'みんなのおやつにもどる'
        # 「せっていへんこう」リンクが表示されていない
        expect(page).to have_link 'せっていへんこう'
        # おやつが表示される
        # バッジが表示される
        expect(page).to have_selector "#oyatsu-id-#{oyatsu.id}-badge", text: '1'
        # おやつ情報が表示される
        expect(page).to have_selector "#oyatsu-id-#{oyatsu.id}-name", text: oyatsu.name
        # footerが表示されない
        expect(page).to have_no_selector ".card-footer"
      end

      it '設定変更ボタンを押下すると編集画面に遷移する' do
        # みんなのおやつに遷移
        visit everyone_oyatsus_path
        tbody = find('tbody')
        # みてあげるボタンを押下
        see_link = tbody.find("#everyone-oyatsu-ensoku-id-#{ensoku_published.id}-see")
        see_link.click
        # 「せっていへんこう」リンクをクリック
        click_link 'せっていへんこう'
        # 遠足編集画面に遷移
        expect(page).to have_content 'しゅうせいするよ'
        # 残高
        expect(page).to have_selector '.okozukai', text: 'のこり: 290 えん'
        # 「えらびなおす」リンクが表示されている
        expect(page).to have_link 'えらびなおす'
        # コメントフォームが表示されている
        # コメントフォームに既存のコメントが表示されている
        expect(page).to have_field 'こめんと', with: ensoku_published.comment
        # ステータスフォームが表示されている
        # 公開ステータスが選択されている
        expect(page).to have_field 'こうかいすてーたす', with: ensoku_published.status
        expect(page).to have_field 'こうかいすてーたす', with: 'published'
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
end

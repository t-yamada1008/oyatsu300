module LoginMacros
  def login_as(user)
    # rootに遷移
    visit root_path
    # トグルを押すとリンクが表示
    find('.navbar-toggler-icon').click
    click_link 'ろぐいん'
    fill_in 'めーるあどれす', with: user.email
    fill_in 'ぱすわーど', with: 'password'
    click_button 'ろぐいん'
  end
end

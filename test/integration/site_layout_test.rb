require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:testing)
  end

  test 'layout links' do
    # all users
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", 'http://tutorial.org'
    get contact_path 'title', full_title('Contact')
    get signup_path 'title', full_title('Sign up')
    # logged-in users
    log_in_as(@user)
    get root_path
    # for example get(signup_path) also works, without any get it rises failures
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path, { text: 'Log out' }
    assert_select "a[href=?]", users_path, { text: 'Users' }
    assert_select "a[href=?]", user_path(@user), { text: 'Profile' }
    assert_select "a[href=?]", edit_user_path(@user), { text: 'Settings' }
    # non-logged-in users
    delete logout_path
    # it rises failures without get('any_path or any_url')
    get root_path
    assert_select "a[href=?]", login_path, { text: 'Log in' }
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", users_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
    assert_select "a[href=?]", edit_user_path(@user), count: 0


  end

end

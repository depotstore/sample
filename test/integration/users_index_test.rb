require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:testing)
    @non_admin = users(:archer)
  end

  test 'index including pagination' do
    log_in_as(@user)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', count: 2
    first_page_of_users = User.where(activated: true).paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      if user == @admin #originally unless
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test 'index ad non-admin' do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

  test 'get users list' do
    log_in_as(@user)
    assert_equal User.count, 36
    assert_equal User.where(activated: false).count, 2
    get users_path
    activated_users = User.where(activated: true)
    first_page_of_activated_users = activated_users.paginate(page: 1)
    assert_select 'ul.users li', count: first_page_of_activated_users.size
    get users_path, params: {page: '2'}
    second_page_of_activated_users_size = activated_users.count -
                                      first_page_of_activated_users.size
    assert_select 'ul.users li', count: second_page_of_activated_users_size
  end

  test 'get activated user page and not-activated user page' do
    log_in_as(@user)
    activated_user = User.where(activated: true).sample
    get user_path activated_user
    assert_template 'users/show'
    not_activated = User.where(activated: false).sample
    get user_path not_activated
    assert_redirected_to root_url
  end

end

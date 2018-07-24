require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:valid_user)
  end

  test "non-existent user cannot login" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "not_created_user@example.com",
                                      password: "Tester.01"}}
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "registered user can login" do
    get login_path
    post login_path, params: { session: { email: @user.email,
                                          password: 'Tester.01'} }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password.02",
                                         password_confirmation: "password.02" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end

  test "Logged in user can sign out" do
    get login_path
    post login_path, params: { session: { email: @user.email,
                                          password: 'Tester.01'} }
    assert_redirected_to @user
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
end

require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "invalid user submission does not register" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "",
                                        email: "user@invalid",
                                        password: "foo",
                                        password_confirmation: "bar"}}
    end
    assert_template 'users/new'
    assert_select '#error_explanation', true
  end

  test "valid user submission creates a user" do
    user_email = 'user@example.com'
    assert_not User.find_by email: user_email
    get signup_path
    post users_path, params: { user: { name: "Test User 101",
                                      email: user_email,
                                      password: "Tester.01",
                                      password_confirmation: "Tester.01"}}
    assert User.find_by email: user_email
    follow_redirect!
    assert_template 'users/show'
  end
end

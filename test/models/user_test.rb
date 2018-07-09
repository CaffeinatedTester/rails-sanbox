require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Test User", email: "example@example.com")
  end

  test "should be valid" do
    assert @user.valid?
  end
  
  test "name should be present" do
    @user.name = ""
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = ""
    assert_not @user.valid?
  end

  test "name should not be > 50 chars" do
    @user.name = 'a' * 51
    assert_not @user.valid?
    @user.name = 'a' * 50
    assert @user.valid?
  end

  test "email should not be > 255 chars" do
    @user.email = 'a' * 244 + '@example.com'
    assert_not @user.valid?
    @user.email = 'a' * 243 + '@example.com'
    assert @user.valid?
  end

  test "valid email addresses are accepted" do
    valid_emails = %w[user@example.com user@example.co.uk something.something@example.co]
    valid_emails.each do |email|
      @user.email = email
      assert @user.valid?, "#{email.inspect} should be valid"
    end
  end

  test "invalid emails are rejected" do
    invalid_emails = %w[something@example something @example.com user@example,com user_at_foo.org user.name@example.
      foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_emails.each do |email|
      @user.email = email
      assert_not @user.valid?, "#{email.inspect} should be invalid"
    end
  end

  test "email addresses should be case in-sensitive unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?, "User email must be unique"
  end

  test "emails should be db downcased" do
    mixed_email = "MiXeD@ExAmPlE.CoM"
    @user.email = mixed_email
    @user.save
    @user.reload
    assert @user.email == mixed_email.downcase, "#{@user.email} should be downcase and match #{mixed_email.downcase}"
  end
end

require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Test User", email: "example@example.com", password: "SecurePass.123", password_confirmation: "SecurePass.123")
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

  test "password should be present" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "password must have be a secure format" do
    secure_pass = %w[.1a1asdaSd SecurePass1 qwefqwefw1. hello.123]
    secure_pass.each do |pass|
      @user.password = @user.password_confirmation = pass
      assert @user.valid?, "#{pass.inspect} should be valid"
    end
  end

  test "password must reject a non secure format" do
    insecure_pass = %w[hello123 123123123123 password. PASSWORD111]
    insecure_pass.each do |pass|
      @user.password = @user.password_confirmation = pass
      assert_not @user.valid?, "#{pass.inspect} should not be valid"
    end
  end
end

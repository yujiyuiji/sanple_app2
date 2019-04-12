require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  #有効なユーザーかどうかをテストする。
  test "should be valid" do
    assert @user.valid?
  end

  #name属性が空でないことのテスト。
  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end

  #email属性が空でないことのテスト。
  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end

  #name属性が５０文字以内でないテスト。
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  #email属性が243文字以内でないテスト。
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  #有効なメールフォーマットをテストする。
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  #有効でないメールフォーマットをテストする。
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  #重複するメールアドレス拒否のテスト。
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  #メールアドレスの小文字化に対するテスト。
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
  #パスワードが空でないテスト。
  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end
  #パスワードが６文字以上であることのテスト。
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
end
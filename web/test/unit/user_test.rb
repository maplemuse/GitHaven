require 'test_helper'

class UserTest < ActiveSupport::TestCase

  fixtures :users

  test "the truth" do
    assert true
  end

  test "invalid with empty attributes" do
    user = User.new
    assert !user.valid?
    assert user.errors.invalid?(:username)
    assert user.errors.invalid?(:email)
    assert !user.errors.invalid?(:name)
    assert !user.errors.invalid?(:hashed_password)
    assert !user.errors.invalid?(:salt)
    assert !user.errors.invalid?(:url)
    assert !user.errors.invalid?(:avatar)
  end

  test "username" do
    good = %w{a b ben icefox jen 10littlemen}
    good.each do |username|
        user = User.new(:username => username,
                        :password => "x",
                        :email => "a@example.com")
        assert user.valid?, user.errors.full_messages
    end

    bad = ["", "\ttab", "\nnewline", "\\", " space", "\"", "<", ">", "|",
           ";", "[", "]", "(", ")", "?", "$", "^", "&", "*", ".", "/" ]
    bad.each do |username|
        user = User.new(:username => username,
                        :password => "x",
                        :email => "a@example.com")
        assert !user.valid?, user.errors.full_messages
    end
  end

  test "email" do
    good = %w{a@b.com}
    good.each do |email|
        user = User.new(:username => "bob",
                        :password => "x",
                        :email => email)
        assert user.valid?, user.errors.full_messages
    end

    bad = %w{a fooatb.com}
    bad.each do |email|
        user = User.new(:username => "bob",
                        :password => "x",
                        :email => email)
        assert !user.valid?, user.errors.full_messages
    end
  end

  test "unique username" do
    user = User.new(:username => "UserName",
                    :password => "x",
                    :email => "bob@example.com")
    puts user.hashed_password
    assert !user.save
    assert !user.errors.on(:username).empty?
  end

  test "authentication" do
    assert !User.authenticate("Bob", "x");
    assert !User.authenticate("UserName", "x");

    user = User.find_by_username("UserName")
    user.password = "x"
    assert !User.authenticate("UserName", "x");
    assert user.save
    assert User.authenticate("UserName", "x");
    assert user.password == "x"
  end

end

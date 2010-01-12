require 'test_helper'

class SshkeyTest < ActiveSupport::TestCase
  fixtures :sshkeys

  test "invalid with empty attributes" do
    key = Sshkey.new
    assert !key.valid?
    assert key.errors.invalid?(:name)
    assert key.errors.invalid?(:key)
  end

  test "unique username" do
    # Check names that user 2 already has
    check = %w{One Two}
    check.each do |name|
        key = Sshkey.new(:name => name,
                         :key => "ssh-rsa x",
                         :user_id => 2)
        assert !key.save
        assert key.errors.invalid?(:name)
    end
    # Check names that user 2 does not have, but another user does
    check = %w{Three}
    check.each do |name|
        key = Sshkey.new(:name => name,
                         :key => "ssh-rsa x",
                         :user_id => 2)
        assert key.save
        assert !key.errors.invalid?(:name)
    end
  end

  test "unique key" do
    check = %w{ssh-rsa\ one ssh-rsa\ two}
    check.each do |keystring|
        key = Sshkey.new(:name => "unique",
                         :key => keystring,
                         :user_id => 2)
        assert !key.save
        assert !key.errors.on(:key).empty?
    end
    check = %w{ssh-rsa\ three}
    check.each do |keystring|
        key = Sshkey.new(:name => "unique",
                         :key => keystring,
                         :user_id => 2)
        assert key.save
        assert !key.errors.invalid?(:key)
    end
  end
end

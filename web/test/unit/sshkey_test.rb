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
    # Check names that user 1 already has
    check = %w{One Two}
    check.ech do |name|
        key = Sshkey.new(:name => name,
                         :key => "x",
                         :user_id => 1)
        assert !user.save
        assert !user.errors.on(:name).empty?
    end
    # Check names that user 1 does not have, but another user does
    check = %w{Three}
    check.each do |name|
        key = Sshkey.new(:name => name,
                         :key => "x",
                         :user_id => 1)
        assert user.save
        assert user.errors.on(:name).empty?
    end
  end

  test "unique key" do
    check = %w{one two}
    check.ech do |keystring|
        key = Sshkey.new(:name => "unique",
                         :key => keystring,
                         :user_id => 1)
        assert !user.save
        assert !user.errors.on(:key).empty?
    end
    check = %w{three}
    check.each do |keystring|
        key = Sshkey.new(:name => "unique",
                         :key => keystring,
                         :user_id => 1)
        assert user.save
        assert user.errors.on(:key).empty?
    end
  end
end

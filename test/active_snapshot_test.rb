require 'test_helper'

module Teardown
  def teardown
    ActiveSnapshot.clear_repository
  end
end

class ActiveSnapshotTest < Minitest::Test
  include Teardown

  def setup
    User.create(id: 1, name: 'Tom', email: 'tom@test.com')
    User.create(id: 2, name: 'John', email: 'john@test.com')
  end

  def teardown
    User.delete_all
    super
  end

  def test_ar_relation
    ActiveSnapshot.take(User.all)
    User.delete_all
    assert_equal 0, User.count

    ActiveSnapshot.go_to_last_revision
    assert_equal 2, User.count

    tom = User.find_by(email: 'tom@test.com')
    john = User.find_by(email: 'john@test.com')

    assert_equal 1, tom.id
    assert_equal 'Tom', tom.name
    assert_equal 'tom@test.com', tom.email

    assert_equal 2, john.id
    assert_equal 'John', john.name
    assert_equal 'john@test.com', john.email
  end

  def test_ar_relation_with_condtion
    ActiveSnapshot.take(User.where(email: 'tom@test.com'))
    User.delete_all
    assert_equal 0, User.count

    ActiveSnapshot.go_to_last_revision
    assert_equal 1, User.count

    tom = User.find_by(email: 'tom@test.com')

    assert_equal 1, tom.id
    assert_equal 'Tom', tom.name
    assert_equal 'tom@test.com', tom.email
  end

  # def test_go_to_specific_revision
  # end
end

class HasOneAssociationTest < Minitest::Test
  include Teardown

  def setup
    user = User.create(id: 3, name: 'Tom', email: 'tom@test.com')
    user.create_account(id: 5, name: 'Tom Account')
  end

  def teardown
    User.delete_all
    Account.delete_all
    super
  end

  def test_has_one_association
    ActiveSnapshot.take(User.all, Account.all)
    User.delete_all
    Account.delete_all
    assert_equal 0, User.count
    assert_equal 0, Account.count

    ActiveSnapshot.go_to_last_revision
    assert_equal 1, User.count
    assert_equal 1, Account.count

    tom = User.find_by(email: 'tom@test.com')
    account = tom.account

    assert_equal 3, tom.id
    assert_equal 'Tom', tom.name
    assert_equal 'tom@test.com', tom.email

    assert_equal 5, account.id
    assert_equal 'Tom Account', account.name
  end
end

class HasManyAssociationTest < Minitest::Test
  include Teardown

  def setup
    blog = Blog.create(id: 10, title: 'Ruby World')
    blog.posts = [Post.create(id: 9, title: 'About Rails'), Post.create(id: 3, title: 'How Ruby Works')]
  end

  def teardown
    Blog.delete_all
    Post.delete_all
    super
  end

  def test_has_many_association
    ActiveSnapshot.take(Blog.all, Post.all)
    Blog.delete_all
    Post.delete_all

    assert_equal 0, Blog.count
    assert_equal 0, Post.count

    ActiveSnapshot.go_to_last_revision
    assert_equal 1, Blog.count
    assert_equal 2, Post.count

    blog = Blog.first
    post_1 = blog.posts.find(9)
    post_2 = blog.posts.find(3)

    assert_equal 10, blog.id
    assert_equal 'Ruby World', blog.title

    assert_equal 9, post_1.id
    assert_equal 'About Rails', post_1.title

    assert_equal 3, post_2.id
    assert_equal 'How Ruby Works', post_2.title
  end

  # def test_has_many_through_association
  # end

  # def test_has_many_polymorphic_association
  # end
end


# class STITest < Minitest::Test
#   include DeleteAll

#   def test_sti
#     assert false
#   end
# end

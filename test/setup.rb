require 'active_record'
require 'base64'

ActiveRecord::Base.configurations = { 'test' => { adapter: 'sqlite3', database: ':memory:' } }
ActiveRecord::Base.establish_connection :test

# models
class User < ActiveRecord::Base
  has_one :account

  def name=(name)
    super Base64.encode64(name)
  end

  def name
    Base64.decode64(super)
  end
end

class Account < ActiveRecord::Base
  belongs_to :user
end

class Blog < ActiveRecord::Base
  has_many :posts
end

class Post < ActiveRecord::Base
  belongs_to :blog
end

class Comment < ActiveRecord::Base
end

class Author < ActiveRecord::Base
end


# migration
class CreateAllTables < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.string :name
      t.string :email
    end

    create_table(:accounts) do |t|
      t.string :name
      t.belongs_to :user
    end

    create_table(:blogs) do |t|
      t.string :title
    end

    create_table(:posts) do |t|
      t.string :title
      t.belongs_to :blog
    end

    create_table(:comments) do |t|
      t.string :body
      t.string :category
      t.string :tag
    end

    create_table(:authors) do |t|
      t.string :name
      t.string :email
    end
  end
end
ActiveRecord::Migration.verbose = false
CreateAllTables.up

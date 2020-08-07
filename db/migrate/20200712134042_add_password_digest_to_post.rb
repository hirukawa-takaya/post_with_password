class AddPasswordDigestToPost < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :password_digest, :string
  end
end

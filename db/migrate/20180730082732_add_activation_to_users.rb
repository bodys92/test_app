class AddActivationToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :activation_digest, :string
    add_column :users, :activated, :booleanm, default: false
    add_column :users, :activated_at, :datetime
  end
end
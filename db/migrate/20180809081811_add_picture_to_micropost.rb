class AddPictureToMicropost < ActiveRecord::Migration[5.2]
  def change
    add_column :microposts, :picture, :string
  end
end

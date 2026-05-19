class AddUniqueIndexesToSubscribersAndRoles < ActiveRecord::Migration[8.1]
  def change
    add_index :subscribers, :email, unique: true
    add_index :roles, :name, unique: true
  end
end

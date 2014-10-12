class AddIsSuperToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :is_super, :boolean
  end
end

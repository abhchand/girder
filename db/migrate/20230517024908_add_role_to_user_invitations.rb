class AddRoleToUserInvitations < ActiveRecord::Migration[6.1]
  def change
    add_column :user_invitations, :role, :string
  end
end

class RemoveInviteeFromUserInvitations < ActiveRecord::Migration[6.1]
  def change
    remove_column :user_invitations, :invitee_id
  end
end

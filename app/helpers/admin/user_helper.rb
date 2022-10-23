module Admin
  module UserHelper
    # Generates the button actions the current user can perform on a given
    # target. The `target` must be a `User` or `UserInvitation`.
    #
    # If the target is a `User`, generate buttons to promote/demote admins and
    # delete the `User`.
    #
    # If the target is a `UserInvitation`, generate a button to resend the
    # invitation.
    #
    # @param [User|UserInvitation] target The target to generate actions for
    # @return [String] The HTML for the generated `<button>` actions
    def actions_for(target)
      case
      when target.is_a?(User) && current_user.has_role?('admin') && current_user != target
        actions_for_user(target)
      when target.is_a?(UserInvitation) && target.pending?
        actions_for_invitation(target)
      end
    end

    # Generate the `id` for a specific target
    #
    # @param [User|UserInvitation] target The target to generate actions for
    def id_for(target)
      target.try(:synthetic_id) || target.id
    end

    # Generate the name for a specific target.
    #
    # @param [User|UserInvitation] target The target to generate actions for
    def name_for(target)
      target.name if target.is_a?(User)
    end

    # Generate the role for a specific target.
    #
    # @param [User|UserInvitation] target The target to generate actions for
    def role_for(target)
      return if target.is_a?(UserInvitation)

      target.has_role?('admin') ? t('roles.admin.label') : ''
    end

    # Generate the status label for a specific target.
    #
    # @param [User|UserInvitation] target The target to generate actions for
    # @return [String]
    def status_for(target)
      key = target.is_a?(UserInvitation) ? :invited : :active
      t("#{i18n_prefix}.table.status.#{key}")
    end

    private

    def actions_for_user(user)
      # Button to add or remove another User as an Admin
      key = user.has_role?('admin') ? :remove_admin : :make_admin
      js_fn = user.has_role?('admin') ? 'removeAdmin' : 'addAdmin'
      admin_btn = <<-HTML.strip_heredoc
        <button
          type="button"
          class="link-btn"
          onClick="Girder.admin.#{js_fn}('#{id_for(user)}')">
          #{t("#{i18n_prefix}.table.actions.#{key}")}
        </button>
      HTML

      # Button to delete another User
      delete_btn = <<-HTML.strip_heredoc
        <button
          type='button'
          class='link-btn'
          onClick="Girder.admin.deleteUser('#{id_for(user)}')">
          #{t("#{i18n_prefix}.table.actions.delete_user")}
        </button>
      HTML

      [admin_btn, delete_btn].join(' | ')
    end

    def actions_for_invitation(user_invitation)
      <<-HTML.strip_heredoc
        <button
          type='button'
          class='link-btn'
          onClick="Girder.admin.resendUserInvitation('#{id_for(user_invitation)}')">
          #{t("#{i18n_prefix}.table.actions.resend_invitation")}
        </button>
      HTML
    end

    def i18n_prefix
      'admin.users.index'
    end
  end
end

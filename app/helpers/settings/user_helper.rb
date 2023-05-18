module Settings
  module UserHelper
    # Generates the button actions the current user can perform on a given
    # target. The `target` must be a `User` or `UserInvitation`.
    #
    # If the target is a `User`, generate buttons to promote/demote leaders and
    # delete the `User`.
    #
    # If the target is a `UserInvitation`, generate a button to resend the
    # invitation.
    #
    # @param [User|UserInvitation] target The target to generate actions for
    # @return [String] The HTML for the generated `<button>` actions
    def actions_for(target)
      case
      when target.is_a?(User) && current_user.has_role?(:leader) &&
             current_user != target
        actions_for_user(target)
      when target.is_a?(UserInvitation)
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
      if target.is_a?(UserInvitation)
        return(t("roles.#{target.role}.label") if target.role.present?)
      end

      target.has_role?(:leader) ? t('roles.leader.label') : ''
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
      # Button to add or remove another User as a Leader
      key = user.has_role?(:leader) ? :remove_leader : :make_leader
      js_fn = user.has_role?(:leader) ? 'removeRole' : 'addRole'
      role_btn = <<-HTML.strip_heredoc
        <button
          type="button"
          class="link-btn"
          onClick="Girder.settings.#{js_fn}('#{id_for(user)}', 'leader')">
          #{t("#{i18n_prefix}.table.actions.#{key}")}
        </button>
      HTML

      # Button to delete another User
      delete_btn = <<-HTML.strip_heredoc
        <button
          type='button'
          class='link-btn'
          onClick="Girder.settings.deleteUser('#{id_for(user)}')">
          #{t("#{i18n_prefix}.table.actions.delete_user")}
        </button>
      HTML

      [role_btn, delete_btn].join(' | ')
    end

    def actions_for_invitation(user_invitation)
      <<-HTML.strip_heredoc
        <button
          type='button'
          class='link-btn'
          onClick="Girder.settings.resendUserInvitation('#{id_for(user_invitation)}')">
          #{t("#{i18n_prefix}.table.actions.resend_invitation")}
        </button>
      HTML
    end

    def i18n_prefix
      'settings.users.index'
    end
  end
end

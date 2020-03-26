module Admin
  module Audit
    class BaseDescriptionService
      class IncorrectAuditableType < StandardError; end

      def self.call(audit)
        new(audit).description
      end

      def initialize(audit)
        @audit = audit
        validate_auditable_type!
      end

      private

      attr_reader :audit

      def i18n_key
        @i18n_key ||=
          "admin.audit.#{self.class::AUDITABLE_TYPE.underscore}_description"
      end

      def t(path, opts = {})
        path = ".#{path}" unless path.start_with?(".")
        I18n.t([i18n_key, path].join, opts)
      end

      def create_action?
        audit.action == "create"
      end

      def update_action?
        audit.action == "update"
      end

      def destroy_action?
        audit.action == "destroy"
      end

      def subject
        audit.auditable
      end

      def modified?(attribute)
        audit.audited_changes.keys.include?(attribute.to_s)
      end

      def old_value_for(attribute)
        case audit.action
        when "create"   then nil
        when "update"   then audit.audited_changes[attribute.to_s][0]
        when "destroy"  then audit.audited_changes[attribute.to_s]
        end
      end

      def new_value_for(attribute)
        case audit.action
        when "create"   then audit.audited_changes[attribute.to_s]
        when "update"   then audit.audited_changes[attribute.to_s][1]
        when "destroy"  then nil
        end
      end

      def validate_auditable_type!
        return if audit.auditable_type == self.class::AUDITABLE_TYPE

        raise(
          IncorrectAuditableType,
          "Expected `#{self.class::AUDITABLE_TYPE}` auditable type, "\
            "got #{audit.auditable_type}"
        )
      end

      def unknown_audit_type
        I18n.t("admin.audit.shared.unknown")
      end

      def fetch_or_reconstruct_associated_record(id, klass)
        # Try to fetch the existing record if it exists
        record = klass.find_by_id(id)
        return record if record

        # If it does not exist, it was deleted at some point. Find the
        # audit record from its deletion.
        last_audit =
          Audited::Audit.
          auditable_finder(id, klass.name).
          where(action: "destroy").
          last

        return unless last_audit

        # Reconstruct a fake / temp record based on its most recently
        # known attributes
        record = klass.new
        record.id = id
        record.attributes = last_audit.audited_changes
        record.errors.add(:base, :fake_error_to_block_accidental_save)

        record
      end
    end
  end
end
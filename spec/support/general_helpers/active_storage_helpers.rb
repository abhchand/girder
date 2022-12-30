module GeneralHelpers
  def clear_storage!
    # rubocop:disable Style/IfUnlessModifier
    unless Rails.env.test?
      raise '`clear_storage!` can only be called on test environment'
    end
    # rubocop:enable Style/IfUnlessModifier

    storage_dir = ActiveStorage::Blob.service.root
    `rm -rf #{storage_dir}/*`
  end

  module_function :clear_storage!
end

module GeneralHelpers
  def fixture_path_for(fixture)
    Pathname.new(fixture_path).join(fixture)
  end

  def create_blob_fixture(fixture_name:)
    file = File.open(fixture_path_for("images/#{fixture_name}"))
    ActiveStorage::Blob.create_and_upload!(io: file, filename: fixture_name)
  end
end

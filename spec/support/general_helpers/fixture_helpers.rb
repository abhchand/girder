module GeneralHelpers
  def fixture_path_for(fixture)
    Pathname.new(fixture_path).join(fixture)
  end

  def create_blob_fixture(fixture_name:)
    file = File.open(fixture_path_for("images/#{fixture_name}"))
    ActiveStorage::Blob.create_and_upload!(io: file, filename: fixture_name)
  end

  def fixture_file_upload(fixture, type: 'image/jpeg')
    # Overrides ActionDispatch's default helper of the same name
    # https://api.rubyonrails.org/classes/ActionDispatch/TestProcess/FixtureFile.html
    path = fixture_path_for(fixture)
    Rack::Test::UploadedFile.new(path, type)
  end
end

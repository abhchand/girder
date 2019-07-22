module GeneralHelpers
  def fixture_path_for(fixture)
    Pathname.new(fixture_path).join(fixture)
  end

  def attach_photo_fixture(photo:, fixture:)
    file = File.open(fixture_path_for("images/#{fixture}"))
    photo.source_file.attach(io: file, filename: fixture)
  end
end

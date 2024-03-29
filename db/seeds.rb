require 'securerandom'
require 'open-uri'
require 'fileutils'

SEEDS_DIR = Rails.root.join('tmp', 'seeds')
FileUtils.mkdir_p(SEEDS_DIR)

SEED_DATA =
  YAML.safe_load(File.read(Rails.root.join('db', 'seeds', 'data.yml')))

#
# Human Users
#

SEED_DATA['users'].each do |user_attrs|
  puts "Creating human user: #{user_attrs}"
  user = FactoryBot.create(:user, user_attrs)
  user.add_role(:leader)
  user.add_role(:superuser)
end

#
# Robot Users
#

(1..10).each do |i|
  puts ''
  log_tag = "[User##{i}]"

  mname = i.even? ? :female_first_name : :male_first_name
  fname = Faker::Name.send(mname)
  lname = Faker::Name.last_name

  attrs = {
    first_name: fname,
    last_name: lname,
    email: Faker::Internet.email(name: [fname, lname].join(' ')),
    # Faker's password generator doesn't always meet our password rules :/
    password: 'EoC9ShWd1hW!q4vBgFw'
  }

  puts "#{log_tag} Creating robot user: #{attrs}"
  user = FactoryBot.create(:user, attrs)

  #
  # Download and attach avatar
  #

  slug = SecureRandom.hex
  url = Faker::Avatar.image(slug: slug, size: '75x75', format: 'png')
  filename = [slug, 'png'].join('.')
  local_filename = SEEDS_DIR.join(filename)

  begin
    retries ||= 0

    puts "#{log_tag} Downloading avatar #{url} -> #{local_filename}"
    # rubocop:disable Security/Open
    URI.open(url) do |image|
      File.open(local_filename, 'wb') { |file| file.write(image.read) }
    end
    # rubocop:enable Security/Open
  rescue OpenURI::HTTPError
    # Faker's Avatar url's generate a `robohash.org` URL. Their site gets
    # overloaded on too many requests and we want to be respectful of their
    # great free service, so add some delay-and-retry logic

    retries += 1
    (sleep(3 * retries) && retry) if retries < 3
  end

  puts "#{log_tag} Using avatar #{url}"
  user.avatar.attach(io: File.open(local_filename), filename: filename)
end

# Photos
# rubocop:disable Style/CombinableLoops
(1..10).each do |i|
  puts "Creating photo ##{i + 1}"
  FactoryBot.create(:photo, owner: User.first, taken_at: (10 * i).days.from_now)
end
# rubocop:enable Style/CombinableLoops

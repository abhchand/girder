class Users::SearchService
  PAGE_SIZE = 20

  def self.perform(users, search)
    new(users, search).perform
  end

  def initialize(users, search)
    @users = users
    @search = search
  end

  def perform
    users = @users.dup

    return users if @search.blank?

    search_tokens.each { |token| users = users.where(<<-SQL) }
        lower(first_name) LIKE '%#{token}%'
        OR lower(last_name) LIKE '%#{token}%'
        OR lower(email) LIKE '%#{token}%'
        SQL

    users
  end

  private

  def search_tokens
    @search_tokens ||=
      @search
        .split(' ')
        .compact
        .map(&:downcase)
        .map { |t| User.sanitize_sql_like(t) }
  end
end

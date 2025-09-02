class SearchService
  # Initializes the service with a collection of search terms.
  #
  # terms - Array or comma separated String of search words.
  # limit - Integer limit for each result set (optional).
  def initialize(terms, limit: nil)
    @terms = Array(terms).map(&:strip).reject(&:blank?)
    @limit = limit
  end

  # Executes the search across users, offerings and reviews.
  #
  # Returns a Hash with keys :users, :offerings and :reviews.
  def call
    return { users: User.none, offerings: Offering.none, reviews: [] } if @terms.empty?

    {
      users: search_users,
      offerings: search_offerings,
      reviews: reviews_table? ? search_reviews : []
    }
  end

  private

  # Builds an OR based ILIKE query for the given SQL fragment and columns.
  def build_ilike_query(columns)
    return nil if @terms.empty?

    sql_fragments = []
    values = []

    @terms.each do |term|
      like = "%#{ActiveRecord::Base.sanitize_sql_like(term)}%"
      sql_fragments << columns.map { |col| "#{col} ILIKE ?" }.join(" OR ")
      values.concat([like] * columns.length)
    end

    [sql_fragments.map { |f| "(#{f})" }.join(' OR '), *values]
  end

  # Search for users by username, name, country and associated tags/locations.
  def search_users
    columns = [
      'users.username',
      'users.full_name',
      'users.country',
      'location_tags.location',
      'profession_tags.profession',
      'tags.name'
    ]

    # Include optional columns only if they exist
    columns << 'users.bio' if column_exists?(:users, :bio)
    columns.select! do |col|
      table, column = col.split('.')
      data_source_exists?(table) && column_exists?(table, column)
    end

    query = build_ilike_query(columns)

    scope = User.all
    scope = scope.left_outer_joins(:tags) if data_source_exists?('tags')
    scope = scope.left_outer_joins(:location_tags) if data_source_exists?('location_tags')
    scope = scope.left_outer_joins(:profession_tags) if data_source_exists?('profession_tags')
    scope = scope.where(query) if query
    scope = scope.distinct
    @limit ? scope.limit(@limit) : scope
  rescue ActiveRecord::StatementInvalid
    User.none
  end

  # Search for offerings by title, description and location.
  def search_offerings
    columns = [
      'offerings.title',
      'offerings.description',
      'offerings.location'
    ]

    query = build_ilike_query(columns)
    scope = Offering.all
    scope = scope.where(query) if query
    @limit ? scope.limit(@limit) : scope
  end

  # Search for reviews by comment.
  def search_reviews
    query = build_ilike_query(['comment'])
    scope = Review.all
    scope = scope.where(query) if query
    @limit ? scope.limit(@limit) : scope
  end

  def reviews_table?
    ActiveRecord::Base.connection.data_source_exists?('reviews')
  rescue ActiveRecord::NoDatabaseError
    false
  end

  def data_source_exists?(name)
    ActiveRecord::Base.connection.data_source_exists?(name.to_s)
  rescue ActiveRecord::StatementInvalid, ActiveRecord::NoDatabaseError
    false
  end

  def column_exists?(table, column)
    ActiveRecord::Base.connection.column_exists?(table, column)
  rescue ActiveRecord::StatementInvalid, ActiveRecord::NoDatabaseError
    false
  end
end

class SearchService
  def initialize(tags, limit: nil)
    @tags = Array(tags).map(&:strip).reject(&:blank?)
    @limit = limit
  end

  # Returns a hash with results for each searchable model
  # { users: <ActiveRecord::Relation>, offerings: <Relation>, reviews: <Relation> }
  def call
    return { users: User.none, offerings: Offering.none, reviews: Review.none } if @tags.empty?

    { users: search_users, offerings: search_offerings, reviews: search_reviews }
  end

  private

  def search_users
    raw_query = @tags.join(' ')
    quoted_query = @tags.map { |t| ActiveRecord::Base.connection.quote(t) }.join(" || ' ' || ")
    tsquery_sql = "websearch_to_tsquery('english', #{quoted_query})"

    User.select("users.*, ts_rank(search_vector, #{tsquery_sql}) AS rank")
        .where("search_vector @@ websearch_to_tsquery('english', ?)", raw_query)
        .order(Arel.sql('rank DESC'))
        .limit(@limit)
  end

  def search_offerings
    scope = Offering.all
    @tags.each do |t|
      like = "%#{t}%"
      scope = scope.where(
        "(title ILIKE :like OR description ILIKE :like OR location ILIKE :like OR title % :raw OR description % :raw OR location % :raw)",
        like: like, raw: t
      )
    end
    scope.limit(@limit)
  end

  def search_reviews
    scope = Review.all
    @tags.each do |t|
      like = "%#{t}%"
      scope = scope.where(
        "(comment ILIKE :like OR comment % :raw)",
        like: like, raw: t
      )
    end
    scope.limit(@limit)
  end
end

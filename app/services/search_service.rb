class SearchService
  def initialize(tags)
    @tags = Array(tags).map(&:strip).reject(&:blank?)
  end

  # Returns a hash with results for each searchable model
  # { users: <ActiveRecord::Relation>, offerings: <Relation>, reviews: <Relation> }
  def call
    return { users: User.none, offerings: Offering.none, reviews: Review.none } if @tags.empty?

    { users: search_users, offerings: search_offerings, reviews: search_reviews }
  end

  private

  def search_users
    query = @tags.map { |t| ActiveRecord::Base.connection.quote_string(t) }.join(' & ')
    User.where("search_vector @@ plainto_tsquery('english', ?)", query)
        .order(Arel.sql("ts_rank_cd(search_vector, plainto_tsquery('english', '#{query}')) DESC"))
  end

  def search_offerings
    sql = @tags.map { |t| "(title ILIKE ? OR description ILIKE ? OR location ILIKE ?)" }.join(' AND ')
    args = @tags.flat_map { |t| ["%#{t}%", "%#{t}%", "%#{t}%"] }
    Offering.where(sql, *args)
  end

  def search_reviews
    sql = @tags.map { |t| "comment ILIKE ?" }.join(' AND ')
    args = @tags.map { |t| "%#{t}%" }
    Review.where(sql, *args)
  end
end

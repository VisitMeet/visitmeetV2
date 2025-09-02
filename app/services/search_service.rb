class SearchService
  def initialize(tags)
    @tags = Array(tags).map(&:strip).reject(&:blank?)
  end

  def call
    return User.none if @tags.empty?

    query = @tags.map { |t| ActiveRecord::Base.connection.quote_string(t) }.join(' & ')
    User.where("search_vector @@ plainto_tsquery('english', ?)", query)
        .order(Arel.sql("ts_rank_cd(search_vector, plainto_tsquery('english', '#{query}')) DESC"))
  end
end

module ApplicationHelper
  def fetch_nepal_image
    require 'unsplash'

    client = Unsplash::Client.new(access_key: ENV['UNSPLASH_ACCESS_KEY'])

    begin
      images = client.photos.search(query: "nepal", per_page: 1)
      image = images.first
    rescue Unsplash::Errors::Unauthorized
      # Handle unauthorized access (e.g., invalid access key)
      logger.error("Unsplash API access denied: #{ENV['UNSPLASH_ACCESS_KEY']}")
      return nil
    rescue Unsplash::Errors::NotFound
      # Handle not found errors (e.g., invalid search query)
      logger.error("No images found for query: nepal")
      return nil
    rescue StandardError => e
      # Handle other errors
      logger.error("Unsplash API error: #{e.message}")
      return nil
    end

    image
  end
end
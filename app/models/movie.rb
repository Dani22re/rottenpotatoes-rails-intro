class Movie < ApplicationRecord
  def self.all_ratings
    %w[G PG PG-13 R]
  end

  def self.with_ratings(ratings_list)
    ratings = ratings_list.presence || all_ratings
    where(rating: ratings)
  end
end

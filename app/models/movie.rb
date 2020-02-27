class Movie < ActiveRecord::Base
  def self.ratings
    self.uniq.pluck :rating
  end

  def self.with_ratings(ratings)
    self.where :rating => ratings
  end
end

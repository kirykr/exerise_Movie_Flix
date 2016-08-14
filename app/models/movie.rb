class Movie < ApplicationRecord
  # relationship / cascading when delete(dependent: :destroy)
  has_many :reviews, dependent: :destroy

  validates :title,:director, presence: true;
  validates :description, length: {minimum: 25}
  # validates :cost, numericality: {greater_than_or_equal_to: 0}
  validates :total_gross, numericality: {only_integer: true, greater_than: 0}
  validates :image_file_name, allow_blank: true, format: {
    with: /\w+\.(gif|jpg|png)\z/i,
    message: "must reference a GIFm JPG, or PNG imagee"
  }

  def self.released
    where("released_on <= ?", Time.now).order("released_on desc")
  end

  def self.hits
    where('total_gross >= 300000000').order(total_gross: :desc)
  end

  def self.flops
    where('total_gross < 50000000').order(total_gross: :asc)
  end

  def self.recently_added
    order('created_at desc').limit(3)
  end

  def flop?
    total_gross.blank? || total_gross < 50000000
  end

  def average_stars
    reviews.average(:stars).to_s
  end
end

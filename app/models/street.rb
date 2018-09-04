class Street < ApplicationRecord
  has_many :communes_streets
  has_many :communes, through: :communes_streets

  validates :title, presence: true
  validates :to, numericality: { greater_than: :from  }, if: Proc.new { |a| a.to.present? }
  validates :from, numericality: true, if: Proc.new { |a| a.from.present? }
end

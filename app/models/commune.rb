class Commune < ApplicationRecord
  has_many :communes_streets
  has_many :streets, through: :communes_streets

  belongs_to :intercommunality, optional: true

  validates :name, presence: true
  validates :code_insee, numericality: false, presence: true, length: { minimum: 4 }

  class << self
    def to_hash
      all.inject({}) do |hash, commune|
        hash[commune.code_insee] = commune.name
        hash
      end
    end

    def search(param_search)
      self.where("lower(name) like ?", "%#{escape_like(param_search)}%")
    end

    def escape_like(field)
      field.gsub(/[_%]/) { |x| "\\#{x}" }
    end
  end
end

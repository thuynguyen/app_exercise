class Intercommunality < ApplicationRecord
  has_many :communes
  
  validates :name, presence: true
  validates :siren, numericality: { only_integer: true }, uniqueness: { case_sensitive: false }, presence: :siren, length: { maximum: 10 }
  validates :form, inclusion: { in: %w(ca cu cc met) }

  before_save :generate_slug

  def communes_hash
    communes.inject({}) do |hash, commune|
      hash[commune.code_insee] = commune.name
      hash
    end
  end

  def generate_slug
    convert_name = name.to_s.gsub("é", "e").to_s.downcase.split(" ").join("-")
    self.slug = convert_name if self.new_record? || slug.nil?
  end

  def population
    self.communes.map{|com| com.population.to_i}.sum
  end
end

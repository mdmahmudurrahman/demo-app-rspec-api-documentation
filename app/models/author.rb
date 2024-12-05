class Author < ApplicationRecord
  validates :name, presence: true
  validates :biography, presence: true
end

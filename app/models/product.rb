class Product < ApplicationRecord
	validates :name, presence: true
	validates :quantity, numericality: { only_integer: true }
	belongs_to :category
	has_many :orders

	include Elasticsearch::Model
	include Elasticsearch::Model::Callbacks

	# Define the mapping and settings (optional)
	settings do
		mappings dynamic: false do
			indexes :name, type: :text
		end
	end


	def self.search(query)
		#wildcard_query = "#{query}*"
		puts "query: #{query}"
		__elasticsearch__.search(
			{
				"query": {
					"match": {
						"name": {
							"query": query
					}
				}
			}
			}
		)
		end
end

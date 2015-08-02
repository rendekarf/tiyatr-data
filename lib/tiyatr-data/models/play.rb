module TiyatrData
	class Play < TiyatrData::Model
		has_many :images
		has_many :people
		has_many :positions
		has_many :scheduled_plays

		belongs_to :play_type
	end
end
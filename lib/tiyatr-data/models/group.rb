module TiyatrData
	class Group < TiyatrData::Model
		has_many :people
		has_many :scheduled_plays		
		has_one :play
	end
end
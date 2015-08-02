module TiyatrData
	class Job < TiyatrData::Model
		has_many :people
		has_many :plays
	end
end
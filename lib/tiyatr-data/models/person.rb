module TiyatrData
	class Person < TiyatrData::Model
		has_many :plays
		has_many :positions
		belongs_to :group		
	end
end
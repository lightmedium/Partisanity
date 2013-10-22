class SessionVote
	include MongoMapper::EmbeddedDocument

	many :Nay, 			:class_name  => "VoteActivity"
	many :Yea, 			:class_name  => "VoteActivity"
	many :Present, 		:class_name  => "VoteActivity"
	
end
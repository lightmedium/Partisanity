class VoteActivity
	include MongoMapper::EmbeddedDocument

	key :display_name, 	String
	key :first_name, 	String
	key :id, 			String
	key :last_name, 	String
	key :party, 		String
	key :state, 		String
	
end
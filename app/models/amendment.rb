class Amendment
	include MongoMapper::EmbeddedDocument
	
	key :author, 	String
	key :number, 	Integer
	key :type, 		String
	key :purpose, String
end
class Bill
	include MongoMapper::EmbeddedDocument

	key :congress, 	Integer
	key :number, 		Integer
	key :title, 		String
	key :type, 			String

end
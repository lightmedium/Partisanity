class MapReductionsController < ApplicationController

	def party_positions_mr
		@result = Vote.party_positions_map_reduce()
	end

	def party_entity_list_mr
    @result = Vote.party_entity_list_map_reduce()
	end

	def vote_cateogory_entity_list_mr
    @result = Vote.vote_cateogory_entity_list_map_reduce()
	end

  def nullify_empty_arrays_mr
    @result = Vote.nullify_empty_arrays_map_reduce()
  end

end
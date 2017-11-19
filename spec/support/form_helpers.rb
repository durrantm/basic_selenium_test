module FormHelpers

	def this_year
    Date.today.strftime('%Y').to_i
	end

  def find_by_id_medium(element)
    find_by_id element, wait:Sleep_lengths[:medium]
  end

end

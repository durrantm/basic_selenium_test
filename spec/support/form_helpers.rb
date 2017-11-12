module FormHelpers

	def this_year
    Date.today.strftime('%Y').to_i
	end

end

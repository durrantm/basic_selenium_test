module FormHelpers

	def this_year
    Date.today.strftime('%Y').to_i
	end

  def send_keys_select_school(p)
    find('#' + p.school).send_keys :arrow_down
    find('#' + p.school).send_keys :tab
  end
end

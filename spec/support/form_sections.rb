module FormSections

  def fill_out_basic_information_form_with_first_name_blank(page, data)
    p,d = page, data
    fill_in p.first_name, with: ''
    fill_in p.middle_initial, with: 't'
    fill_in p.last_name, with: 'testLast'
    fill_in p.email_address, with: d.email
    fill_in p.phone, with: '6175551212'
    select 'JAN', from: p.dob_month
    fill_in p.dob_day, with: '01'
    fill_in p.dob_year, with: '1992'
    select 'US Citizen', from: p.us_citizen
    fill_in p.ssn_first_three, with: '666'
    fill_in p.ssn_middle_two, with: '00'
    fill_in p.ssn_last_four, with: '0000'
    fill_in p.ssn_first_three_confirm, with: '666'
    fill_in p.ssn_middle_two_confirm, with: '00'
    fill_in p.ssn_last_four_confirm, with: '0000'
	end

  def fill_out_demographics(p)
    fill_in p.street_address, with: '1 main st'
    fill_in p.street_address_2, with: 'Apt#1'
    fill_in p.city, with: 'New York'
    select 'New York', from: p.state
    fill_in p.zip, with: '10024'
    select '10', from: p.years_there
  end
end

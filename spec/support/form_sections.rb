module FormSections

  def fill_out_basic_information_form(page, data)
    p,d = page, data
    fill_in p.first_name, with: 'testFirst'
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

  def fill_out_education_degree_information(p, this_year)
    select 'Bachelors', from: p.degree
    select 'Law and Law Studies', from: p.major
    select 'Full Time', from: p.enrollment_status
    select 'First Year Masters/Doctorate', from: p.grade_level
    select 'Jan', from: p.loan_start_month
    select this_year, from: p.loan_start_year
    select 'Jan', from: p.loan_end_month
    select (this_year + 1), from: p.loan_end_year
    select 'Jan', from: p.graduation_date_month
    select (this_year + 2), from: p.graduation_date_year
  end

  def fill_out_education_certificate_information(p, this_year)
    select 'Certificate', from: p.degree
    select 'Law and Law Studies', from: p.major
    select 'Full Time', from: p.enrollment_status
    select 'Certificate/Continuing Ed', from: p.grade_level
    select 'Jan', from: p.loan_start_month
    select this_year, from: p.loan_start_year
    select 'Jan', from: p.loan_end_month
    select (this_year + 1), from: p.loan_end_year
    select 'Jan', from: p.graduation_date_month
    select (this_year + 2), from: p.graduation_date_year
  end

  def fill_out_loan_information(p)
    fill_in p.copay, with: '10000'
    fill_in p.financial_assistance, with: '4000'
    fill_in p.loan, with: '4000'
    fill_in p.requested_loan, with: '2000'
  end

  def fill_out_employment_information(p)
    select 'Employed PT', from: p.employment_status
    find(p.continue).click
    fill_in p.employer, with: 'test inc'
    select 'Engineer', from: p.occupation
    fill_in p.work_phone, with: '6175551212'
    fill_in p.work_phone_extension, with: '100'
    select '10', from: p.employment_length
    fill_in p.income, with: '50000'
  end

  def fill_out_financial_information(p)
    fill_in p.checking_amount, with: '1000'
    select 'Own', from: p.residence_type
    fill_in p.mortgage_rent, with: 1000
  end

  def fill_out_contact_information(p)
    fill_in p.primary_contact_first_name, with: 'testMomFirst'
    fill_in p.primary_contact_last_name, with: 'testMomLast'
    fill_in p.primary_contact_phone, with: '6175551212'
    select 'Mother', from: p.primary_relationship
    fill_in p.secondary_contact_first_name, with: 'testDadFirst'
    fill_in p.secondary_contact_last_name, with: 'testDadLast'
    fill_in p.secondary_contact_phone, with: '6175551213'
    select 'Father', from: p.secondary_relationship
  end

  def accept_dialogs(p)
    within_frame(find(p.dialog_frame)) do
      expect(find(p.title, text: /^Information.*Rates.*Fees$/)).to be
    end

    within_frame(find(p.dialog_frame)) do
      find(p.dialog_continue).click
    end

    within_frame(find(p.dialog_frame)) do
      expect(find(p.title, text: /^Privacy Policy$/)).to be
    end

    within_frame(find(p.dialog_frame)) do
      find(p.button_continue).click
    end
  end

  def submit_application(p)
    within_frame(find(p.dialog_frame)) do
      find(p.electronic_consent).click
    end
    sleep_short
    accept_dialogs(p)
    within_frame(find(p.dialog_frame)) do
      find(p.submit_application).click
    end
  end

  def continue
    find(p.continue).click
  end
end


module FormSections

  def fill_out_basic_information_form(form_page, data)
    p,d = form_page, data
    wait_to_see_medium { find_by_id p.first_name }
    fill_in p.first_name, with: 'testFirst'
    fill_in p.middle_initial, with: 't'
    fill_in p.last_name, with: 'testLast'
    fill_in p.email_address, with: d.email
    fill_in p.phone, with: '6175551212'
    select 'JAN', from: p.dob_month
    fill_in p.dob_day, with: '01'
    fill_in p.dob_year, with: '1978'
    select 'US Citizen', from: p.us_citizen
    fill_out_ssn_and_confirm_ssn(p)
	end

  def fill_out_ssn_and_confirm_ssn(p)
    fill_in p.ssn_first_three, with: '666'
    fill_in p.ssn_middle_two, with: '00'
    fill_in p.ssn_last_four, with: '0000'
    fill_in p.ssn_first_three_confirm, with: '666'
    fill_in p.ssn_middle_two_confirm, with: '00'
    fill_in p.ssn_last_four_confirm, with: '0000'
  end

  def fill_out_student_info(p)
    fill_out_student_basic_info(p)
    fill_out_student_ssn_and_confirm_ssn(p)
  end

  def fill_out_student_basic_info(p)
    fill_in p.student_first_name, with: 'testFirst'
    fill_in p.student_last_name, with: 'testLast'
    select 'JAN', from: p.student_dob_month
    fill_in p.student_dob_day, with: '01'
    fill_in p.student_dob_year, with: '1996'
    select 'US Citizen', from: 'BO_ST_Citizenship'
  end

  def fill_out_student_ssn_and_confirm_ssn(p)
    fill_in p.student_SSN_first_3, with: '666'
    fill_in p.student_SSN_middle_2, with: '01'
    fill_in p.student_SSN_last_4, with: '0000'
    fill_in p.student_SSN_first_3_confirm, with: '666'
    fill_in p.student_SSN_middle_2_confirm, with: '01'
    fill_in p.student_SSN_last_4_confirm, with: '0000'
  end

  def fill_out_address(p)
    wait_to_see_medium { find_by_id p.street_address }
    fill_in p.street_address, with: '1 main st'
    fill_in p.street_address_2, with: 'Apt#1'
    fill_in p.city, with: 'New York'
    select 'New York', from: p.state
    fill_in p.zip, with: '10024'
    select '10', from: p.years_there
  end

  def fill_out_education_degree_information(p, this_year, major='Law and Law Studies')
    select 'Bachelors', from: p.degree
    select major, from: p.major
    select 'Full Time', from: p.enrollment_status
    select 'First Year Masters/Doctorate', from: p.grade_level
    fill_out_years(p, this_year)
  end

  def fill_out_loan_years(p, this_year)
    select 'Jan', from: p.loan_start_month
    select this_year, from: p.loan_start_year
    select 'Jan', from: p.loan_end_month
    select (this_year + 1), from: p.loan_end_year
  end

  def fill_out_years(p, this_year)
    fill_out_loan_years(p, this_year)
    fill_out_graduation(p, this_year)
  end

  def fill_out_graduation(p, this_year)
    select 'Jan', from: p.graduation_date_month
    select (this_year + 2), from: p.graduation_date_year
  end

  def fill_out_education_certificate_information(p, this_year)
    find_by_id p.degree
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
    wait_to_see_short { find_by_id p.employment_status, visible: true }
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
    wait_to_see_short { find_by_id p.checking_account, visible: true }
    check p.checking_account
    find_by_id p.checking_amount, visible: true
    fill_in p.checking_amount, with: '1000'
    select 'Own', from: p.residence_type
    fill_in p.mortgage_rent, with: 1000
  end

  def fill_out_contact_information(p)
    wait_to_see_short { find_by_id p.primary_contact_first_name, visible: true }
    fill_in p.primary_contact_first_name, with: 'testMomFirst'
    fill_in p.primary_contact_last_name, with: 'testMomLast'
    fill_in p.primary_contact_phone, with: '6175551212'
    select 'Mother', from: p.primary_relationship
    fill_in p.secondary_contact_first_name, with: 'testDadFirst'
    fill_in p.secondary_contact_last_name, with: 'testDadLast'
    fill_in p.secondary_contact_phone, with: '6175551213'
    select 'Father', from: p.secondary_relationship
  end

  def fill_out_disbursement_information(p, this_year)
    select 'Jan', from: p.disbursement_date_1_month
    select '01', from:  p.disbursement_date_1_day
    select (this_year+1), from: p.disbursement_date_1_year
    select 'Jun', from: p.disbursement_date_2_month
    select '01', from:  p.disbursement_date_2_day
    select (this_year+1), from: p.disbursement_date_2_year
    fill_in p.disbursement_amount_1, with: 5000
    fill_in p.disbursement_amount_2, with: 5000
  end

  def fill_out_school(p, school)
    wait_for_ajax
    wait_to_see_short { find_by_id p.school, visible: true }
    fill_in p.school, with: school
    sleep_short
    find_by_id(p.school).send_keys :arrow_down
    find_by_id(p.school).send_keys :tab
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

  def electronic_consent(p)
    within_frame(find(p.dialog_frame)) do
      find(p.electronic_consent).click
    end
  end

  def submit_application(p)
    electronic_consent(p)
    sleep_short
    accept_dialogs(p)
    click_submit_application(p)
  end

  def click_submit_application(p)
    within_frame(find(p.dialog_frame)) do
      find(p.submit_application).click
    end
  end

  def continue(p)
    find(p.continue).click
  end

  def continue_in_dialog_frame(p)
    within_frame(find(p.dialog_frame)) do
      find(p.button_continue).click
    end
  end
end


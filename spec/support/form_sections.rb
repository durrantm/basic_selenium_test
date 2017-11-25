module FormSections

  def fill_out_basic_information_form(form_page, data)
    p,d = form_page, data
    ensure_input_is_visible(p.first_name, Sleep_lengths[:medium_long])
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
    wait_for_ajax
    ensure_input_is_visible(p.street_address, Sleep_lengths[:medium_long])
    fill_in p.street_address, with: '1 main st'
    fill_in p.street_address_2, with: 'Apt#1'
    fill_in p.city, with: 'New York'
    select 'New York', from: p.state
    fill_in p.zip, with: '10024'
    select '10', from: p.years_there
  end

  def fill_out_education_degree_information(p, this_year)
    fill_out_first_degree(p)
    fill_out_major_enrollment_status(p)
    select_first_dropdown_option(p.grade_level)
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
    fill_out_first_degree(p)
    fill_out_major_enrollment_status(p)
    select_first_dropdown_option(p.grade_level)
    fill_out_loan_years(p, this_year)
    fill_out_graduation(p, this_year)
  end

  def fill_out_first_grade_level(p)
    ensure_dropdown_option_is_visible(p.grade_level)
    select_first_dropdown_option(p.grade_level)
  end

  def fill_out_loan_information(p)
    fill_in p.copay, with: '10000'
    fill_in p.financial_assistance, with: '4000'
    find_by_id(p.financial_assistance).send_keys :tab
    fill_in p.requested_loan, with: '2000'
  end

  def fill_out_employment_information(p)
    ensure_dropdown_option_is_visible(p.employment_status)
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
    ensure_input_is_visible(p.checking_account)
    check p.checking_account
    find_by_id p.checking_amount, visible: true
    fill_in p.checking_amount, with: '1000'
    select 'Own', from: p.residence_type
    fill_in p.mortgage_rent, with: 1000
  end

  def fill_out_contact_information(p)
    ensure_input_is_visible(p.primary_contact_first_name)
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
    ensure_input_is_visible(p.school)
    fill_in p.school, with: school
    sleep_short
    wait_for_ajax
    select_first_school(p.school)
  end

  def fill_out_first_degree_major_enrollment_status_dropdowns(p)
    fill_out_first_degree(p)
    fill_out_major_enrollment_status(p)
  end

  def fill_out_first_degree(p)
    ensure_dropdown_option_is_visible(p.degree, Sleep_lengths[:medium_long])
    select_first_dropdown_option(p.degree)
  end

  def fill_out_major_enrollment_status(p)
    ensure_dropdown_option_is_visible(p.major)
    select_first_dropdown_option(p.major)
    select_first_dropdown_option(p.enrollment_status)
  end

  def indicate_cosigner(p)
    ensure_input_is_visible(p.how_to_apply_individual)
    choose p.how_to_apply, option: 'J'
		continue(p)
		within_frame(find(p.dialog_frame)) do
			first('input#ConsumerICCCosignerwithMe').click
			click_on 'Continue'
		end
	end

  def cosigner_details(p)
    fill_in p.cosigner_first_name, with: 'cosignerFirstName'
    fill_in p.cosigner_last_name, with: 'cosignerLastName'
    fill_in p.cosigner_middle_initial, with: 'a'
    select 'Parent', from: p.cosigner_relationship_to_student
    fill_in p.cosigner_email, with: 'do-not-reply@google.com'
    fill_in p.cosigner_primary_phone, with: '6175551212'
    select 'JAN', from: p.cosigner_dob_month
    fill_in p.cosigner_dob_day, with: '01'
    fill_in p.cosigner_dob_year, with: '1985'
    select 'US Citizen', from: p.cosigner_citizenship
    fill_in p.cosigner_ssn_first_three, with: '666'
    fill_in p.cosigner_ssn_middle_two, with: '02'
    fill_in p.cosigner_ssn_last_four, with: '0000'
    fill_in p.cosigner_confirm_ssn_first_three, with: '666'
    fill_in p.cosigner_confirm_ssn_middle_two, with: '02'
    fill_in p.cosigner_confirm_ssn_last_four, with: '0000'
    continue(p)
    fill_in p.cosigner_street, with: '1 main st'
    fill_in p.cosigner_street2, with: ''
    fill_in p.cosigner_city, with: 'New York'
    select 'New York', from: p.cosigner_state
    fill_in p.cosigner_zip, with: '10024'
    fill_in p.cosigner_primary_phone, with: '6175551213'
    select '10', from: p.cosigner_permanent_address_years
    continue(p)
    select 'Employed FT', from: p.cosigner_employment_status
    find_by_id p.cosigner_current_employer_name
    fill_in p.cosigner_current_employer_name, with: 'Test Inc'
    select 'Pilot', from: p.cosigner_occupation
    fill_in p.cosigner_work_phone, with: '6175551214'
    fill_in p.cosigner_work_phone_ext, with: '123'
    select '10', from: p.cosigner_employment_length
    fill_in p.cosigner_gross_annual_income, with: '1000000'
    continue(p)
    select_first_dropdown_option(p.cosigner_residence_type)
    continue(p)
    certify_status(p)
    electronic_consent(p)
    rates_and_fees(p)
    privacy_policy(p)
    click_submit_application(p)
  end

  def choose_individual_application(p)
    ensure_input_is_visible(p.how_to_apply_individual)
    choose p.how_to_apply, option: 'I'
    continue(p)
  end

  def accept_dialogs(p)
    within_frame(find(p.dialog_frame)) do
      find(p.dialog_continue).click
    end
    privacy_policy(p)
  end

  def privacy_policy(p)
    within_frame(find(p.dialog_frame)) do
      find(p.title, text: /^Privacy Policy$/)
      find(p.button_continue).click
    end
  end

  def electronic_consent(p)
    within_frame(find(p.dialog_frame)) do
      find(p.electronic_consent).click
    end
  end

  def rates_and_fees(p)
    within_frame(find(p.dialog_frame)) do
      find(p.dialog_continue).click
    end
  end

  def certify_status(p)
    within_frame(find p.dialog_frame) do
      check 'CertifyStatus'
      find_by_id('Continue').click
    end
  end

  def ensure_input_is_visible(input_id, max_wait_time = Sleep_lengths[:medium])
    find('input#' + input_id, visible: true, wait: max_wait_time)
  end

  def ensure_dropdown_option_is_visible(select_id, max_wait_time = Sleep_lengths[:medium])
    find 'select#' + select_id + ' option:nth-child(2)', visible: true, wait: max_wait_time
  end

  def select_first_dropdown_option(select_id)
    find('select#' + select_id + ' option:nth-child(2)').select_option
  end

  def select_first_school(select_id)
    find_by_id(select_id).send_keys :arrow_down
    find_by_id(select_id).send_keys :tab
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

  def expect_to_see_application_status_page(p)
    find(p.title, text: /^Application Status$/, wait: Sleep_lengths[:long])
    expect(find(p.title, text: /^Application Status$/)).to be
    sleep_short
  end

end

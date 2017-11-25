describe 'student loan products', loan_type: 'dental_and_medical', page_type: 'form', order: :defined do

  include Sleepers
  include FormHelpers
  include FormSections
  include WaitForAjax

  p = PageObject.new
  d = FormDataObject.new

  describe "Dental and Medical Form", :smoke do
    it "exists for following tests to use, otherwise they are skipped" do
      visit_url(TEST_ENVIRONMENT, p.dental_and_medical_loan_form_url, p.dental_and_medical_loan_form_id, p)
      find p.main_form, visible: true, wait: Sleep_lengths[:medium]
      expect(find(p.main_form)).to be
    end
  end

  describe "Dental and Medical Sad Page 1", :sad do
    it "has a form for Dental and Medical student loans that is filled out Incorrectly" do
      visit_url(TEST_ENVIRONMENT, p.dental_and_medical_loan_form_url, p.dental_and_medical_loan_form_id, p)
      fill_out_basic_information_form(p,d)
      fill_in p.first_name, with: ''
      continue(p)
      expect(find_by_id(p.first_name).value).to eq ''
      expect(find_by_id(p.last_name).value).to eq 'testLast'
      expect(find_by_id(p.email_address).value).to eq d.email
    end
  end

  describe "Dental and Medical Happy All Pages", :happy do
    it "has a form for Dental and Medical student loans that is filled out correctly" do
      visit_url(TEST_ENVIRONMENT, p.dental_and_medical_loan_form_url, p.dental_and_medical_loan_form_id, p)
      fill_out_basic_information_form(p,d)
      continue(p)
      fill_out_address(p)
      continue(p)
      find(p.main_form)
      fill_out_school(p, 'SUNY')
      wait_for_ajax
      fill_out_first_degree_major_enrollment_status_dropdowns(p)
      fill_out_first_grade_level(p)
      select all('#' + p.periods + ' option').last.text, from: p.periods if PRODUCTION
      select_last_academic_period(p) if PRODUCTION
      fill_out_loan_years(p, this_year)
      select 'Jan', from: p.graduation_date_month
      select (this_year+2), from: p.graduation_date_year
      continue(p)
      find_by_id_medium p.copay
      fill_out_loan_information(p)
      continue(p)
      fill_out_employment_information(p)
      continue(p)
      find_by_id p.checking_account
      check(p.checking_account)
      fill_out_financial_information(p)
      continue(p)
      fill_out_contact_information(p)
      continue(p)
      choose_individual_application(p)
      find p.dialog_frame
      submit_application(p)
      expect_to_see_application_status_page(p)
    end
  end
end

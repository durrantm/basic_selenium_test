describe 'student loan products', loan_type: 'undergraduate', page_type: 'form', order: :defined do
  include Sleepers
  include FormHelpers
  include FormSections
  include WaitForAjax

  p = PageObject.new
  d = FormDataObject.new

  describe "Undergraduate Form", smoke: true do
    it "exists for following tests to use, otherwise they are skipped" do
      visit_url(TEST_ENVIRONMENT, p.undergraduate_loan_form_url, p.undergraduate_loan_form_id, p)
      find p.main_form, visible: true, wait: Sleep_lengths[:medium]
      expect(find(p.main_form)).to be
    end
  end

  describe "Undergraduate Happy All Pages **with Cosigner**" do
    it "has a form for undergraduate student loans that is filled out correctly", happy: true do
      visit_url(TEST_ENVIRONMENT, p.undergraduate_loan_form_url, p.undergraduate_loan_form_id, p)
      fill_out_basic_information_form(p,d)
      continue(p)
      fill_out_address(p)
      continue(p)
      fill_out_school(p, 'TRINITY')
      ensure_dropdown_option_is_visible(p.degree)
      fill_out_education_degree_information(p, this_year)
      continue(p)
      find_by_id_medium p.copay
      fill_out_loan_information(p)
      continue(p)
      fill_out_employment_information(p)
      continue(p)
      find_by_id p.checking_account
      check p.checking_account
      fill_out_financial_information(p)
      continue(p)
      fill_out_contact_information(p)
      continue(p)
      indicate_cosigner(p)
      electronic_consent(p)
      rates_and_fees(p)
      privacy_policy(p)
      click_submit_application(p)
      cosigner_details(p)
      expect_to_see_application_status_page(p)
    end
  end
end

describe 'student loan products', loan_type: 'mba', page_type: 'form', order: :defined do
  include Sleepers
  include FormHelpers
  include FormSections
  include WaitForAjax

  p = PageObject.new
  d = FormDataObject.new


  describe "MBA Form", smoke: true do
    it "exists for following tests to use, otherwise they are skipped" do
      visit_url(TEST_ENVIRONMENT, p.mba_loan_form_url, p.mba_loan_form_id, p)
      find p.main_form, visible: true, wait: Sleep_lengths[:medium]
      expect(find(p.main_form)).to be
    end
  end

  describe "MBA Sad Page 1", sad: true do
    it "has a form for MBA student loans that is filled out Incorrectly" do
      visit_url(TEST_ENVIRONMENT, p.mba_loan_form_url, p.mba_loan_form_id, p)
      fill_out_basic_information_form(p,d)
      fill_in p.first_name, with: ''
      continue(p)
      expect(find_by_id(p.first_name).value).to eq ''
      expect(find_by_id(p.last_name).value).to eq 'testLast'
      expect(find_by_id(p.email_address).value).to eq d.email
    end
  end

  describe "MBA Happy All Pages" do
    it "has a form for MBA student loans that is filled out correctly", happy: true do
      visit_url(TEST_ENVIRONMENT, p.mba_loan_form_url, p.mba_loan_form_id, p)
      fill_out_basic_information_form(p,d)
      continue(p)
      fill_out_address(p)
      continue(p)
      wait_to_see_short { find_by_id p.school }
      fill_out_school(p, 'COLUMBIA UNIVERSITY')
      wait_for_ajax
      fill_out_first_degree_major_enrollment_status_dropdowns(p)
      fill_out_first_grade_level(p)
      fill_out_years(p, this_year)
      continue(p)
      find_by_id p.copay, wait:Sleep_lengths[:medium]
      fill_out_loan_information(p)
      continue(p)
      wait_to_see_short { find_by_id p.employment_status }
      fill_out_employment_information(p)
      continue(p)
      wait_to_see_short { find_by_id p.checking_account }
      check(p.checking_account)
      wait_to_see_short { find_by_id p.checking_amount }
      fill_out_financial_information(p)
      continue(p)
      wait_to_see_short { find_by_id p.primary_contact_first_name }
      fill_out_contact_information(p)
      continue(p)
      choose_individual_application(p)
      wait_to_see_short { find p.dialog_frame }
      submit_application(p)
      find(p.title, text: /^Application Status$/, wait: Sleep_lengths[:long])
      expect(find(p.title, text: /^Application Status$/)).to be
      sleep_short
    end
  end
end

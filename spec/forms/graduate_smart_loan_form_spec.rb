describe 'student loan products', loan_type: 'graduate', page_type: 'form', order: :defined do
  include Sleepers
  include FormHelpers
  include FormSections
  include WaitForAjax
  p = PageObject.new
  d = FormDataObject.new

  describe "Gradudate Form", smoke: true do
    it "exists for following tests to use, otherwise they are skipped" do
      visit_url(TEST_ENVIRONMENT, p.graduate_loan_form_url, p.graduate_loan_form_id, p)
      find p.main_form, visible: true, wait: Sleep_lengths[:medium]
      expect(find(p.main_form)).to be
    end
  end

  describe "Graduate Sad Page 1", sad: true do
    it "has a form for Graduate student loans that is filled out Incorrectly" do
      visit_url(TEST_ENVIRONMENT, p.graduate_loan_form_url, p.graduate_loan_form_id, p)
      fill_out_basic_information_form(p,d)
      fill_in p.first_name, with: ''
      continue(p)
      expect(find_by_id(p.first_name).value).to eq ''
      expect(find_by_id(p.last_name).value).to eq 'testLast'
      expect(find_by_id(p.email_address).value).to eq d.email
    end
  end

  describe "Graduate Happy All Pages" do
    it "has a form for Graduate student loans that is filled out correctly", happy: true do
      visit_url(TEST_ENVIRONMENT, p.graduate_loan_form_url, p.graduate_loan_form_id, p)
      fill_out_basic_information_form(p,d)
      continue(p)
      fill_out_address(p)
      continue(p)
      find_by_id p.school
      fill_out_school(p, 'Trinity')
      wait_for_ajax
      fill_out_education_degree_information(p, this_year)
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
      first p.dialog_frame
      submit_application(p)
      find(p.title, text: /^Application Status$/, wait: Sleep_lengths[:long])
      expect(find(p.title, text: /^Application Status$/)).to be
      sleep_short
    end
  end
end

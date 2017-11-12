describe 'student loan products' do
  include Sleepers
  include FormHelpers
  include FormSections
  include WaitForAjax

  p = PageObject.new
  d = FormDataObject.new

  describe "MBA Sad Page 1", sad: true, loan_type: 'mba', page_type: 'form' do
    it "has a form for MBA student loans that is filled out Incorrectly", happy: true, loan_type: 'mba' do
      visit_url(TEST_ENVIRONMENT, p.mba_loan_form_url, p.mba_loan_form_id, p)
      fill_out_basic_information_form(p,d)
      fill_in p.first_name, with: ''
      continue(p)
      expect(find_by_id(p.first_name).value).to eq ''
      expect(find_by_id(p.last_name).value).to eq 'testLast'
      expect(find_by_id(p.email_address).value).to eq d.email
    end
  end

  describe "MBA Happy All Pages", happy: true, smoke: true, loan_type: 'mba', page_type: 'form' do
    it "has a form for MBA student loans", smoke: true do
      visit_url(TEST_ENVIRONMENT, p.mba_loan_form_url, p.mba_loan_form_id, p)
      find p.main_form, visible: true
      expect(find(p.main_form)).to be
    end
    it "has a form for MBA student loans that is filled out correctly", happy: true, loan_type: 'mba' do
      visit_url(TEST_ENVIRONMENT, p.mba_loan_form_url, p.mba_loan_form_id, p)
      fill_out_basic_information_form(p,d)
      continue(p)
      fill_out_address(p)
      continue(p)
      wait_to_see_short { find_by_id p.school }
      fill_out_school(p, 'COLUMBIA UNIVERSITY')
      wait_for_ajax
      find_by_id p.degree
      select 'MBA', from: p.degree
      select 'Business', from: p.major
      select 'Full Time', from: p.enrollment_status
      select 'First Year Masters/Doctorate', from: p.grade_level
      fill_out_years(p, this_year)
      continue(p)
      wait_to_see_medium { find_by_id p.copay }
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
      wait_to_see_medium { first '#' + p.how_to_apply }
      choose p.how_to_apply, option: 'I'
      continue(p)
      wait_to_see_short { find p.dialog_frame }
      submit_application(p)
      sleepy Sleep_lengths[:long]
      expect(find(p.title, text: /^Application Status$/)).to be
      sleep_short
    end
  end
end

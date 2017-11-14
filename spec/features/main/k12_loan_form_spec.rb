describe 'K12 loan products', order: :defined do
  include Sleepers
  include FormHelpers
  include FormSections
  include WaitForAjax

  p = PageObject.new
  d = FormDataObject.new


  describe "K12 Form", smoke: true, loan_type: 'k12', page_type: 'form' do
    it "exists for following tests to use, otherwise they are skipped", loan_type: 'k12' do
      visit_url(TEST_ENVIRONMENT, p.k12_loan_form_url, p.k12_loan_form_id, p)
      find p.main_form, visible: true, wait: Sleep_lengths[:medium]
      expect(find(p.main_form)).to be
    end
  end

  describe "K12 Sad Page 1", sad: true, loan_type: 'k12', page_type: 'form' do
    it "has a form for K12 student loans that is filled out Incorrectly", happy: true, loan_type: 'k12' do
      visit_url(TEST_ENVIRONMENT, p.k12_loan_form_url, p.k12_loan_form_id, p)
      fill_out_basic_information_form(p,d)
      fill_in p.first_name, with: ''
      continue(p)
      expect(find_by_id(p.first_name).value).to eq ''
      expect(find_by_id(p.last_name).value).to eq 'testLast'
      expect(find_by_id(p.email_address).value).to eq d.email
      # TODO add expects for other values that were entered
    end
  end

  describe "K12 Training Happy All Pages", happy: true, smoke: true, loan_type: 'k12', page_type: 'form' do
    it "has a form for k12 training student loans", smoke: true, loan_type: 'k12' do
      visit_url(TEST_ENVIRONMENT, p.k12_loan_form_url, p.k12_loan_form_id, p)
      find p.main_form, visible: true
      expect(find(p.main_form)).to be
    end
    it "has a form for K12 student loans that is filled out correctly", happy: true, loan_type: 'k12' do
      visit_url(TEST_ENVIRONMENT, p.k12_loan_form_url, p.k12_loan_form_id, p)
      fill_out_basic_information_form(p,d)
      wait_to_see_short { p.relationship_to_student }
      select 'Parent', from: p.relationship_to_student
      continue(p)
      fill_out_address(p)
      continue(p)
      wait_to_see_short { find_by_id p.student_first_name }
      fill_in p.student_first_name, with: 'testfirst'
      fill_in p.student_first_name, with: 'testfirst'
      fill_in p.student_last_name, with: 'testLast'
      select 'JAN', from: p.student_dob_month
      fill_in p.student_dob_day, with: '01'
      fill_in p.student_dob_year, with: '1996'
      fill_out_student_ssn_and_confirm_ssn(p)
      fill_out_school(p, "NEW YORK MILITARY")
      wait_for_ajax
      find_by_id p.grade_level, wait:Sleep_lengths[:medium]
      select 'Kindergarten', from: p.grade_level
      continue(p)
      find_by_id p.requested_loan, wait:Sleep_lengths[:medium]
      fill_in p.requested_loan, with: '4000'
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
      within_frame(find(p.dialog_frame)) do
        find(p.electronic_consent).click
      end
      wait_to_see_short { find p.dialog_frame }
      within_frame(find(p.dialog_frame)) do
        find(p.button_continue).click
      end
      wait_to_see_short { find p.dialog_frame }
      within_frame(find(p.dialog_frame)) do
        find(p.submit_application).click
      end
      find(p.title, text: /^Application Status$/, wait: Sleep_lengths[:long])
      expect(find(p.title, text: /^Application Status$/)).to be
      sleep_short
    end
  end
end

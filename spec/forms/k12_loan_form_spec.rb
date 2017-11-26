describe 'K12 loan products', loan_type: 'k12', page_type: 'form', order: :defined do

  include Sleepers
  include FormHelpers
  include FormSections
  include WaitForAjax

  p = PageObject.new
  d = FormDataObject.new

  describe "K12 Form", :smoke do
    it "exists for following tests to use, otherwise they are skipped" do
      goto_page(p.k12_loan_form_url, p.k12_loan_form_id, p)
      find p.main_form, visible: true, wait: Sleep_lengths[:medium]
      expect(find(p.main_form)).to be
    end
  end

  describe "K12 Sad Page 1", :sad do
    it "has a form for K12 student loans that is filled out Incorrectly" do
      goto_page(p.k12_loan_form_url, p.k12_loan_form_id, p)
      fill_out_basic_information_form(p,d)
      fill_in p.first_name, with: ''
      continue(p)
      expect(find_by_id(p.first_name).value).to eq ''
      expect(find_by_id(p.last_name).value).to eq 'testLast'
      expect(find_by_id(p.email_address).value).to eq d.email
      # TODO add expects for other values that were entered
    end
  end

  describe "K12 Training Happy All Pages", :happy do
    it "has a form for K12 student loans that is filled out correctly" do
      goto_page(p.k12_loan_form_url, p.k12_loan_form_id, p)
      fill_out_basic_information_form(p,d)
      find_by_id p.relationship_to_student
      select 'Parent', from: p.relationship_to_student
      continue(p)
      fill_out_address(p)
      continue(p)
      find_by_id p.student_first_name
      fill_in p.student_first_name, with: 'testfirst'
      fill_in p.student_last_name, with: 'testLast'
      select 'JAN', from: p.student_dob_month
      fill_in p.student_dob_day, with: '01'
      fill_in p.student_dob_year, with: '1996'
      fill_out_student_ssn_and_confirm_ssn(p)
      fill_out_school(p, "NEW YORK MILITARY")
      fill_out_first_grade_level(p)
      continue(p)
      find_by_id_medium p.requested_loan
      fill_in p.requested_loan, with: '4000'
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
      electronic_consent(p)
      privacy_policy(p)
      click_submit_application(p)
      expect_to_see_application_status_page(p)
    end
  end
end

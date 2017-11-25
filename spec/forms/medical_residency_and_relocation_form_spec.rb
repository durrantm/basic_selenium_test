describe 'student loan products', loan_type: 'medical_residency', page_type: 'form', order: :defined do

  include Sleepers
  include FormHelpers
  include FormSections
  include WaitForAjax

  p = PageObject.new
  d = FormDataObject.new

  describe "Medical Residency and Relocation Form", :smoke do
    it "exists for following tests to use, otherwise they are skipped" do
      goto_page(p.medical_residency_and_relocation_loan_form_url, p.medical_residency_and_relocation_loan_form_id, p)
      find p.main_form, visible: true, wait: Sleep_lengths[:medium]
      expect(find(p.main_form)).to be
    end
  end

  describe "Medical Residency and relocation Sad Page 1", :sad do
    it "has a form for Medical Residency and Relocation loans that is filled out Incorrectly" do
      goto_page(p.medical_residency_and_relocation_loan_form_url, p.medical_residency_and_relocation_loan_form_id, p)
      fill_out_basic_information_form(p,d)
      fill_in p.first_name, with: ''
      continue(p)
      expect(find_by_id(p.first_name).value).to eq ''
      expect(find_by_id(p.last_name).value).to eq 'testLast'
      expect(find_by_id(p.email_address).value).to eq d.email
    end
  end

  describe "Medical Residency and relocation Happy All Pages", :happy do
    it "has a form for Medical Residency and relocation student loans that is filled out correctly" do
      goto_page(p.medical_residency_and_relocation_loan_form_url, p.medical_residency_and_relocation_loan_form_id, p)
      fill_out_basic_information_form(p,d)
      continue(p)
      fill_out_address(p)
      continue(p)
      fill_out_school(p, PRODUCTION ? 'NEW YORK' : 'TRINITY')
      wait_for_ajax
      fill_out_first_degree_major_enrollment_status_dropdowns(p)
      fill_out_graduation(p, this_year-1)
      continue(p)
      find_by_id_medium p.requested_loan
      fill_in p.requested_loan, with: 10000
      fill_out_disbursement_information(p, this_year)
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

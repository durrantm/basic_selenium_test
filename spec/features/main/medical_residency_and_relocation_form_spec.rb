describe 'student loan products' do
  include Sleepers
  include FormHelpers
  include FormSections
  include WaitForAjax

  p = PageObject.new
  d = FormDataObject.new

  describe "Medical Residency and relocation Sad Page 1", sad: true, loan_type: 'medical_residency', page_type: 'form' do
    it "has a form for Medical Residency and Relocation loans that is filled out Incorrectly", happy: true, loan_type: 'medical_residency' do
      visit_url(TEST_ENVIRONMENT, p.medical_residency_and_relocation_loan_form_url, p.medical_residency_and_relocation_loan_form_id, p)
      fill_out_basic_information_form(p,d)
      fill_in p.first_name, with: ''
      continue(p)
      expect(find('#' + p.first_name).value).to eq ''
      expect(find('#' + p.last_name).value).to eq 'testLast'
      expect(find('#' + p.email_address).value).to eq d.email
    end
  end

  describe "Medical Residency and relocation Happy All Pages", happy: true, smoke: true, loan_type: 'medical_residency', page_type: 'form' do
    it "has a form for Medical Residency and relocation student loans", smoke: true do
      visit_url(TEST_ENVIRONMENT, p.medical_residency_and_relocation_loan_form_url, p.medical_residency_and_relocation_loan_form_id, p)
      expect(find(p.main_form)).to be
    end
    it "has a form for Medical Residency and relocation student loans that is filled out correctly", happy: true, loan_type: 'medical_residency' do
      visit_url(TEST_ENVIRONMENT, p.medical_residency_and_relocation_loan_form_url, p.medical_residency_and_relocation_loan_form_id, p)
      fill_out_basic_information_form(p,d)
      continue(p)
      fill_out_address(p)
      continue(p)
      wait_to_see_short { find '#' + p.school }
      fill_out_school(p, 'TRINITY')
      wait_for_ajax
      find '#' + p.degree
      select 'Doctor of Medicine', from: p.degree
      select 'MD - Dermatology', from: p.major
      select 'Full Time', from: p.enrollment_status
      select 'Jan', from: p.graduation_date_month
      select (this_year+1), from: p.graduation_date_year
      continue(p)
      wait_to_see_medium { find '#' + p.requested_loan }
      fill_in p.requested_loan, with: 10000
      fill_out_disbursement_information(p, this_year)
      continue(p)
      wait_to_see_short { find '#' + p.employment_status }
      fill_out_employment_information(p)
      continue(p)
      wait_to_see_short { find '#' + p.checking_account }
      check(p.checking_account)
      wait_to_see_short { find '#' + p.checking_amount }
      fill_out_financial_information(p)
      continue(p)
      wait_to_see_short { find '#' + p.primary_contact_first_name }
      fill_out_contact_information(p)
      continue(p)
      wait_to_see_medium { first '#' + p.how_to_apply }
      choose p.how_to_apply, option: 'I'
      continue(p)
      wait_to_see_short { find p.dialog_frame }
      within_frame(find(p.dialog_frame)) do
        find(p.electronic_consent).click
      end
      wait_to_see_short { find p.dialog_frame }
      within_frame(find(p.dialog_frame)) do
        find(p.button_continue).click
      end
      within_frame(find(p.dialog_frame)) do
        find(p.submit_application).click
      end
      sleepy Sleep_lengths[:long]
      expect(find(p.title, text: /^Application Status$/)).to be
      sleep_short
    end
  end
end

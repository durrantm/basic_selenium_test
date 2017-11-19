describe 'student loan products', loan_type: 'dental_residency', page_type: 'form', order: :defined do
  include Sleepers
  include FormHelpers
  include FormSections
  include WaitForAjax

  p = PageObject.new
  d = FormDataObject.new


  describe "Dental Residency and Relation Form", smoke: true do
    it "exists for following tests to use, otherwise they are skipped" do
      visit_url(TEST_ENVIRONMENT, p.dental_residency_and_relocation_loan_form_url, p.dental_residency_and_relocation_loan_form_id, p)
      find p.main_form, visible: true, wait: Sleep_lengths[:medium]
      expect(find(p.main_form)).to be
    end
  end

  describe "Dental Residency and Relocation Sad Page 1", sad: true do
    it "has a form for Dental Residency and Relocation loans that is filled out Incorrectly" do
      visit_url(TEST_ENVIRONMENT, p.dental_residency_and_relocation_loan_form_url, p.dental_residency_and_relocation_loan_form_id, p)
      fill_out_basic_information_form(p,d)
      fill_in p.first_name, with: ''
      continue(p)
      expect(find_by_id(p.first_name).value).to eq ''
      expect(find_by_id(p.last_name).value).to eq 'testLast'
      expect(find_by_id(p.email_address).value).to eq d.email
    end
  end

  describe "Dental Residency and Relocation Happy All Pages" do
    it "has a form for Dental Residency and Relocation student loans that is filled out correctly", happy: true do
      visit_url(TEST_ENVIRONMENT, p.dental_residency_and_relocation_loan_form_url, p.dental_residency_and_relocation_loan_form_id, p)
      fill_out_basic_information_form(p,d)
      continue(p)
      fill_out_address(p)
      continue(p)
      find_by_id p.school
      fill_out_school(p, 'TRINITY')
      wait_for_ajax
      fill_out_first_degree_major_enrollment_status_dropdowns(p)
      if PRODUCTION
        fill_out_first_grade_level(p)
        find_by_id(p.periods).send_keys :arrow_down
        find_by_id(p.periods).send_keys :tab
        select_last_academic_period(p)
        fill_out_years(p, this_year)
      else
        fill_out_graduation(p, this_year - 1)
      end
      continue(p)
      find_by_id_medium p.requested_loan
      if PRODUCTION
        fill_out_loan_information(p)
      else
        fill_in p.requested_loan, with: '10000'
        fill_out_disbursement_information(p, this_year)
      end
      continue(p)
      find_by_id p.employment_status
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
      if PRODUCTION
        submit_application(p)
      else
        electronic_consent(p)
        continue_in_dialog_frame(p)
        click_submit_application(p)
      end
      find(p.title, text: /^Application Status$/, wait: Sleep_lengths[:long])
      expect(find(p.title, text: /^Application Status$/)).to be
      sleep_short
    end
  end
end

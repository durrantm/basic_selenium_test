describe 'student loan products' do
  include Sleepers
  include FormHelpers
  include FormSections
  include WaitForAjax

  p = PageObject.new
  d = FormDataObject.new

  describe "Dental Residency and relocation Sad Page 1", sad: true, loan_type: 'dental_residency', page_type: 'form' do
    it "has a form for Dental Residency and Relocation loans that is filled out Incorrectly", happy: true, loan_type: 'dental_residency' do
      visit_url(TEST_ENVIRONMENT, p.dental_residency_and_relocation_loan_form_url, p.dental_residency_and_relocation_loan_form_id, p)
      fill_out_basic_information_form(p,d)
      fill_in p.first_name, with: ''
      continue(p)
      expect(find_by_id(p.first_name).value).to eq ''
      expect(find_by_id(p.last_name).value).to eq 'testLast'
      expect(find_by_id(p.email_address).value).to eq d.email
    end
  end

  describe "Dental Residency and relocation Happy All Pages", happy: true, smoke: true, loan_type: 'dental_residency', page_type: 'form' do
    it "has a form for Dental Residency and relocation student loans", smoke: true do
      visit_url(TEST_ENVIRONMENT, p.dental_residency_and_relocation_loan_form_url, p.dental_residency_and_relocation_loan_form_id, p)
      find p.main_form, visible: true
      expect(find(p.main_form)).to be
    end
    it "has a form for Dental Residency and relocation student loans that is filled out correctly", happy: true, loan_type: 'dental_residency' do
      visit_url(TEST_ENVIRONMENT, p.dental_residency_and_relocation_loan_form_url, p.dental_residency_and_relocation_loan_form_id, p)
      fill_out_basic_information_form(p,d)
      continue(p)
      fill_out_address(p)
      continue(p)
      wait_to_see_short { find_by_id p.school }
      fill_out_school(p, 'TRINITY')
      wait_for_ajax
      find_by_id p.degree
      if PRODUCTION
        select 'Doctor of Medicine', from: p.degree
        select 'Medical', from: p.major
      else
        select 'Doctor of Dental Surgery/Doctor of Dental Medicine', from: p.degree
        select 'DDS - Advanced Education In General Dentistry', from: p.major
      end
      select 'Full Time', from: p.enrollment_status
      if PRODUCTION
        select 'First Year Masters/Doctorate', from: p.grade_level
        find_by_id(p.periods).send_keys :arrow_down
        find_by_id(p.periods).send_keys :tab
        select_last_academic_period(p)
        fill_out_years(p, this_year)
      else
        fill_out_graduation(p, this_year - 1)
      end
      continue(p)
      sleep_medium # Increased from short to medium to pass.  md
      if PRODUCTION
        fill_out_loan_information(p)
      else
        fill_in p.requested_loan, with: '10000'
        fill_out_disbursement_information(p, this_year)
      end
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
      if PRODUCTION
        submit_application(p)
      else
        within_frame(find(p.dialog_frame)) do
          find(p.electronic_consent).click
        end
        within_frame(find(p.dialog_frame)) do
          wait_to_see_short { find p.button_continue }
          find(p.button_continue).click
        end
        within_frame(find(p.dialog_frame)) do
          find(p.submit_application).click
        end
      end
      sleepy Sleep_lengths[:long]
      expect(find(p.title, text: /^Application Status$/)).to be
      sleep_short
    end
  end
end

describe 'student loan products', loan_type: 'health_graduate', page_type: 'form'  do
  include Sleepers
  include FormHelpers
  include FormSections
  include WaitForAjax

  p = PageObject.new
  d = FormDataObject.new


  describe "Health Graduate Form", smoke: true do
    it "exists for following tests to use, otherwise they are skipped" do
      visit_url(TEST_ENVIRONMENT, p.health_graduate_loan_form_url, p.health_graduate_loan_form_id, p)
      find p.main_form, visible: true, wait: Sleep_lengths[:medium]
      expect(find(p.main_form)).to be
    end
  end

  describe "Health Graduate Sad Page 1", sad: true do
    it "has a form for Health Graduate student loans that is filled out Incorrectly" do
      visit_url(TEST_ENVIRONMENT, p.health_graduate_loan_form_url, p.health_graduate_loan_form_id, p)
      fill_out_basic_information_form(p,d)
      fill_in p.first_name, with: ''
      continue(p)
      expect(find_by_id(p.first_name).value).to eq ''
      expect(find_by_id(p.last_name).value).to eq 'testLast'
      expect(find_by_id(p.email_address).value).to eq d.email
    end
  end

  describe "Health Graduate Happy All Pages" do
    it "has a form for Health Graduate student loans that is filled out correctly", happy: true do
      visit_url(TEST_ENVIRONMENT, p.health_graduate_loan_form_url, p.health_graduate_loan_form_id, p)
      fill_out_basic_information_form(p,d)
      continue(p)
      fill_out_address(p)
      continue(p)
      fill_out_school(p, 'TRINITY')
      wait_for_ajax
      fill_out_first_degree_major_enrollment_status_dropdowns(p)
      if PRODUCTION
        fill_out_first_grade_level(p)
        select 'Provide your own', from: p.periods
        fill_out_loan_years(p, this_year)
        fill_out_years(p, this_year)
        continue(p)
        find_by_id_medium p.copay
        fill_out_loan_information(p)
      else
        fill_out_graduation(p, this_year-1)
        continue(p)
        find_by_id_medium p.requested_loan
        fill_in p.requested_loan, with: '10000'
        fill_out_disbursement_information(p, this_year)
      end
      continue(p)
      fill_out_employment_information(p)
      continue(p)
      wait_to_see_short { find_by_id p.checking_account }
      check(p.checking_account)
      fill_out_financial_information(p)
      continue(p)
      fill_out_contact_information(p)
      continue(p)
      choose_individual_application(p)
      wait_to_see_short { find p.dialog_frame }
      if PRODUCTION
        submit_application(p)
      else
        electronic_consent(p)
        wait_to_see_short { find p.dialog_frame }
        continue_in_dialog_frame(p)
        click_submit_application(p)
      end
      find(p.title, text: /^Application Status$/, wait: Sleep_lengths[:long])
      expect(find(p.title, text: /^Application Status$/)).to be
      sleep_short
    end
  end
end

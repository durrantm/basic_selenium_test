describe 'student loan products' do
  include Sleepers
  include FormHelpers
  include FormSections
  include WaitForAjax

  p = PageObject.new
  d = FormDataObject.new

  describe "Health Graduate Sad Page 1", sad: true, loan_type: 'health_graduate', page_type: 'form' do
    it "has a form for Health Graduate student loans that is filled out Incorrectly", happy: true, loan_type: 'health_graduate' do
      visit_url(TEST_ENVIRONMENT, p.health_graduate_loan_form_url, p.health_graduate_loan_form_id, p)
      fill_out_basic_information_form(p,d)
      fill_in p.first_name, with: ''
      continue(p)
      expect(find('#' + p.first_name).value).to eq ''
      expect(find('#' + p.last_name).value).to eq 'testLast'
      expect(find('#' + p.email_address).value).to eq d.email
    end
  end

  describe "Health Graduate Happy All Pages", happy: true, smoke: true, loan_type: 'health_graduate', page_type: 'form' do
    it "has a form for Health Graduate student loans", smoke: true do
      visit_url(TEST_ENVIRONMENT, p.health_graduate_loan_form_url, p.health_graduate_loan_form_id, p)
      expect(find(p.main_form)).to be
    end
    it "has a form for Health Graduate student loans that is filled out correctly", happy: true, loan_type: 'health_graduate' do
      visit_url(TEST_ENVIRONMENT, p.health_graduate_loan_form_url, p.health_graduate_loan_form_id, p)
      fill_out_basic_information_form(p,d)
      continue(p)
      fill_out_address(p)
      continue(p)
      fill_out_school(p, 'TRINITY')
      wait_for_ajax
      find '#' + p.degree
      if PRODUCTION
        select 'Masters', from: p.degree
        select 'Nursing', from: p.major
        select 'First Year Masters/Doctorate', from: p.grade_level
        select 'Provide your own', from: p.periods
        fill_out_loan_years(p, this_year)
      else
        select 'Doctor of Medicine', from: p.degree
        select 'MD - Dermatology', from: p.major
      end
      select 'Full Time', from: p.enrollment_status
      if PRODUCTION
        fill_out_years(p, this_year)
      else
        fill_out_graduation(p, this_year-1)
      end
      continue(p)
      if PRODUCTION
        wait_to_see_medium { find '#' + p.copay }
        fill_out_loan_information(p)
      else
        wait_to_see_short { find '#' + p.requested_loan }
        fill_in p.requested_loan, with: '10000'
        fill_out_disbursement_information(p, this_year)
      end
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
      if PRODUCTION
        submit_application(p)
      else
        electronic_consent(p)
        wait_to_see_short { find p.dialog_frame }
        continue_in_dialog_frame(p)
        click_submit_application(p)
      end
      sleepy Sleep_lengths[:long]
      expect(find(p.title, text: /^Application Status$/)).to be
      sleep_short
    end
  end
end

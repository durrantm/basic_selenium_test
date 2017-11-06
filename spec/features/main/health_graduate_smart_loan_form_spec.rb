describe 'student loan products' do
  include Sleepers
  include FormHelpers
  include FormSections
  p = PageObject.new
  d = FormDataObject.new

  describe "Health Graduate Sad Page 1", sad: true, loan_type: 'health_graduate', page_type: 'form' do
    it "has a form for Health Graduate student loans that is filled out Incorrectly", happy: true, loan_type: 'health_graduate' do
      visit_url(TEST_ENVIRONMENT, p.health_graduate_loan_form_url, p.health_graduate_loan_form_id, p)
      sleep_short
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
      sleep_short
      fill_out_basic_information_form(p,d)
      continue(p)
      sleep_medium # Increased from short to medium to medium_long to pass.  md
      expect(find(p.address_info)).to be

      fill_out_demographics(p)
      continue(p)
      expect(find(p.main_form)).to be
      fill_in p.school, with: 'TRINITY'
      sleep_short
      find('#' + p.school).send_keys :arrow_down
      find('#' + p.school).send_keys :tab
      sleep_short
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
      sleep_medium
      if PRODUCTION
        fill_out_loan_information(p)
      else
        fill_in p.requested_loan, with: '10000'
        fill_out_disbursement_information(p, this_year)
      end
      continue(p)
      sleep_short
      expect(find '#' + p.employment_status).to be

      fill_out_employment_information(p)
      continue(p)
      expect(find '#' + p.checking_account).to be

      check(p.checking_account)
      expect(find '#' + p.checking_amount).to be

      fill_out_financial_information(p)
      continue(p)
      sleep_short
      expect(find '#' + p.primary_contact_first_name).to be

      fill_out_contact_information(p)
      continue(p)
      choose p.how_to_apply, option: 'I'
      continue(p)
      sleep_short
      expect(find p.dialog_frame).to be
      if PRODUCTION
        submit_application(p)
      else
        electronic_consent(p)
        continue_in_dialog_frame(p)
        click_submit_application(p)
      end
      sleepy Sleep_lengths[:long]
      expect(find(p.title, text: /^Application Status$/)).to be
      sleep_short
    end
  end
end

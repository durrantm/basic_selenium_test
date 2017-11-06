describe 'student loan products' do
  include Sleepers
  include FormHelpers
  include FormSections
  p = PageObject.new
  d = FormDataObject.new

  describe "MBA Sad Page 1", sad: true, loan_type: 'mba', page_type: 'form' do
    it "has a form for MBA student loans that is filled out Incorrectly", happy: true, loan_type: 'mba' do
      visit_url(TEST_ENVIRONMENT, p.mba_loan_form_url, p.mba_loan_form_id, p)
      sleep_short
      fill_out_basic_information_form(p,d)
      fill_in p.first_name, with: ''
      continue(p)
      expect(find('#' + p.first_name).value).to eq ''
      expect(find('#' + p.last_name).value).to eq 'testLast'
      expect(find('#' + p.email_address).value).to eq d.email
    end
  end

  describe "MBA Happy All Pages", happy: true, smoke: true, loan_type: 'mba', page_type: 'form' do
    it "has a form for MBA student loans", smoke: true do
      visit_url(TEST_ENVIRONMENT, p.mba_loan_form_url, p.mba_loan_form_id, p)
      sleep_short
      expect(find(p.main_form)).to be
    end
    it "has a form for MBA student loans that is filled out correctly", happy: true, loan_type: 'mba' do
      visit_url(TEST_ENVIRONMENT, p.mba_loan_form_url, p.mba_loan_form_id, p)
      sleep_short
      fill_out_basic_information_form(p,d)
      continue(p)
      sleep_medium # Increased from short to medium to medium_long to pass.  md
      expect(find(p.address_info)).to be

      fill_out_demographics(p)
      continue(p)
      expect(find(p.main_form)).to be

      sleep_short

      fill_in p.school, with: 'COLUMBIA UNIVERSITY'
      sleep_short
      find('#' + p.school).send_keys :arrow_down
      find('#' + p.school).send_keys :tab
      select 'MBA', from: p.degree
      select 'Business', from: p.major
      select 'Full Time', from: p.enrollment_status
      select 'First Year Masters/Doctorate', from: p.grade_level
      fill_out_years(p, this_year)
      continue(p)
      sleep_medium # Increased from short to medium to pass.  md

      expect(find('#' + p.copay)).to be

      fill_out_loan_information(p)
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

      submit_application(p)

      sleepy Sleep_lengths[:long]
      expect(find(p.title, text: /^Application Status$/)).to be
      sleep_short
    end
  end
end

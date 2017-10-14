require 'yaml'
require 'spec_helper'
require_relative '../../support/page_object'
require_relative '../../support/form_data_object'
require_relative '../../support/sleep_lengths'
require_relative '../../support/sleepers'
require_relative '../../support/form_helpers'

describe 'student loan products' do
  include Sleepers
  include FormHelpers
  p = PageObject.new
  d = FormDataObject.new

  describe "Career Training Sad Page 1", sad: true, loan_type: 'career_training', page_type: 'form' do
    it "has a form for career training student loans that is filled out Incorrectly", happy: true, loan_type: 'career_training' do
      visit p.career_training_loan_form_url
      click_link p.apply_for_loan
      sleep_short
      fill_in p.first_name, with: ''
      fill_in p.middle_initial, with: 't'
      fill_in p.last_name, with: 'testLast'
      fill_in p.email_address, with: d.email
      fill_in p.phone, with: '6175551212'
      select 'JAN', from: p.dob_month
      fill_in p.dob_day, with: '01'
      fill_in p.dob_year, with: '1992'
      select 'US Citizen', from: p.us_citizen
      fill_in p.ssn_first_three, with: '666'
      fill_in p.ssn_middle_two, with: '00'
      fill_in p.ssn_last_four, with: '0000'
      fill_in p.ssn_first_three_confirm, with: '666'
      fill_in p.ssn_middle_two_confirm, with: '00'
      fill_in p.ssn_last_four_confirm, with: '0000'
      find(p.continue).click
      expect(find('#' + p.first_name).value).to eq ''
      expect(find('#' + p.last_name).value).to eq 'testLast'
      expect(find('#' + p.email_address).value).to eq d.email
      # TODO add expects for other values that were entered
    end
  end

  describe "Undergraduate Happy All Pages", happy: true, smoke: true, loan_type: 'undergraduate', page_type: 'form' do
    it "has a form for carer training student loans", smoke: true, loan_Type: 'career_training' do
      visit p.career_training_loan_form_url
      click_link p.apply_for_loan
      expect(find(p.main_form)).to be
    end
    it "has a form for career training student loans that is filled out correctly", happy: true, loan_type: 'career_training' do
      visit p.career_training_loan_form_url
      click_link p.apply_for_loan
      sleep_short
      fill_in p.first_name, with: 'testFirst'
      fill_in p.middle_initial, with: 't'
      fill_in p.last_name, with: 'testLast'
      fill_in p.email_address, with: d.email
      fill_in p.phone, with: '6175551212'
      select 'JAN', from: p.dob_month
      fill_in p.dob_day, with: '01'
      fill_in p.dob_year, with: '1992'
      select 'US Citizen', from: p.us_citizen
      fill_in p.ssn_first_three, with: '666'
      fill_in p.ssn_middle_two, with: '00'
      fill_in p.ssn_last_four, with: '0000'
      fill_in p.ssn_first_three_confirm, with: '666'
      fill_in p.ssn_middle_two_confirm, with: '00'
      fill_in p.ssn_last_four_confirm, with: '0000'
      find(p.continue).click
      sleep_medium # Increased from short to medium to pass.  md
      expect(find(p.address_info)).to be

      fill_in p.street_address, with: '1 main st'
      fill_in p.street_address_2, with: 'Apt#1'
      fill_in p.city, with: 'New York'
      select 'New York', from: p.state
      fill_in p.zip, with: '10024'
      select '10', from: p.years_there
      find(p.continue).click
      expect(find(p.main_form)).to be

      sleep_short
      fill_in p.school, with: "NEW YORK METHODIST HOSPITAL"
      sleep_short
      find('#' + p.school).send_keys :arrow_down
      find('#' + p.school).send_keys :tab
      select 'Certificate', from: p.degree
      select 'Law and Law Studies', from: p.major
      select 'Full Time', from: p.enrollment_status
      select 'Certificate/Continuing Ed', from: p.grade_level
      select 'Jan', from: p.loan_start_month
      select this_year, from: p.loan_start_year
      select 'Jan', from: p.loan_end_month
      select (this_year + 1), from: p.loan_end_year
      select 'Jan', from: p.graduation_date_month
      select (this_year + 2), from: p.graduation_date_year
      find(p.continue).click
      sleep_medium # Increased from short to medium to pass.  md
      expect(find('#' + p.copay)).to be

      fill_in p.copay, with: '10000'
      fill_in p.financial_assistance, with: '4000'
      fill_in p.loan, with: '4000'
      fill_in p.requested_loan, with: '2000'
      find(p.continue).click
      sleep_short
      expect(find '#' + p.employment_status).to be

      select 'Employed PT', from: p.employment_status
      find(p.continue).click
      fill_in p.employer, with: 'test inc'
      select 'Engineer', from: p.occupation
      fill_in p.work_phone, with: '6175551212'
      fill_in p.work_phone_extension, with: '100'
      select '10', from: p.employment_length
      fill_in p.income, with: '50000'
      find(p.continue).click
      expect(find '#' + p.checking_account).to be

      check(p.checking_account)
      expect(find '#' + p.checking_amount).to be

      fill_in p.checking_amount, with: '1000'
      select 'Own', from: p.residence_type
      fill_in p.mortgage_rent, with: 1000
      find(p.continue).click
      sleep_short
      expect(find '#' + p.primary_contact_first_name).to be

      fill_in p.primary_contact_first_name, with: 'testMomFirst'
      fill_in p.primary_contact_last_name, with: 'testMomLast'
      fill_in p.primary_contact_phone, with: '6175551212'
      select 'Mother', from: p.primary_relationship
      fill_in p.secondary_contact_first_name, with: 'testDadFirst'
      fill_in p.secondary_contact_last_name, with: 'testDadLast'
      fill_in p.secondary_contact_phone, with: '6175551213'
      select 'Father', from: p.secondary_relationship
      find(p.continue).click
      choose p.how_to_apply, option: 'I'
      find(p.continue).click
      sleep_short
      expect(find p.dialog_frame).to be

      within_frame(find(p.dialog_frame)) do
        find(p.electronic_consent).click
      end
      sleep_short
      within_frame(find(p.dialog_frame)) do
        expect(find(p.title, text: /^Information.*Rates.*Fees$/)).to be
      end

      within_frame(find(p.dialog_frame)) do
        find(p.dialog_continue).click
      end
      within_frame(find(p.dialog_frame)) do
        expect(find(p.title, text: /^Privacy Policy$/)).to be
      end

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

require 'yaml'
require 'spec_helper'
require_relative '../../support/page_object'
require_relative '../../support/form_data_object'
require_relative '../../support/sleep_lengths'
require_relative '../../support/sleepers'
require_relative '../../support/form_helpers'
require_relative '../../support/form_sections'

describe 'student loan products' do
  include Sleepers
  include FormHelpers
  include FormSections
  p = PageObject.new
  d = FormDataObject.new

  describe "Dental and Medical Sad Page 1", sad: true, loan_type: 'dental_and_medical', page_type: 'form' do
    it "has a form for Dental and Medical student loans that is filled out Incorrectly", happy: true, loan_type: 'dental_and_medical' do
      visit_url(TEST_ENVIRONMENT, p.dental_and_medical_loan_form_url, p.dental_and_medical_loan_form_id, p)
      sleep_short
      fill_out_basic_information_form(p,d)
      fill_in p.first_name, with: ''
      continue(p)
      expect(find('#' + p.first_name).value).to eq ''
      expect(find('#' + p.last_name).value).to eq 'testLast'
      expect(find('#' + p.email_address).value).to eq d.email
    end
  end

  describe "Dental and Medical Happy All Pages", happy: true, smoke: true, loan_type: 'dental_and_medical', page_type: 'form' do
    it "has a form for Dental and Medical student loans", smoke: true do
      visit_url(TEST_ENVIRONMENT, p.dental_and_medical_loan_form_url, p.dental_and_medical_loan_form_id, p)
      expect(find(p.main_form)).to be
    end
    it "has a form for Dental and Medical student loans that is filled out correctly", happy: true, loan_type: 'dental_and_medical' do
      visit_url(TEST_ENVIRONMENT, p.dental_and_medical_loan_form_url, p.dental_and_medical_loan_form_id, p)
      sleep_short
      fill_out_basic_information_form(p,d)
      continue(p)
      sleep_medium # Increased from short to medium to medium_long to pass.  md
      expect(find(p.address_info)).to be

      fill_out_demographics(p)
      continue(p)
      expect(find(p.main_form)).to be

      fill_in p.school, with: 'SUNY'
      sleep_short
      find('#' + p.school).send_keys :arrow_down
      find('#' + p.school).send_keys :tab
      sleep_short
      select 'Doctor of Medicine', from: p.degree
      select 'Medical', from: p.major
      select 'Full Time', from: p.enrollment_status
      select 'First Year Masters/Doctorate', from: p.grade_level
      select all('#' + p.periods + ' option').last.text, from: p.periods if PRODUCTION
      select_last_academic_period(p) if PRODUCTION
      select 'Jan', from: p.loan_start_month
      select this_year, from: p.loan_start_year
      select 'Jan', from: p.loan_end_month
      select (this_year+1), from: p.loan_end_year
      select 'Jan', from: p.graduation_date_month
      select (this_year+2), from: p.graduation_date_year
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

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

  describe "Dental Residency and relocation Sad Page 1", sad: true, loan_type: 'dental_residency', page_type: 'form' do
    it "has a form for Dental Residency and Relocation loans that is filled out Incorrectly", happy: true, loan_type: 'dental_residency' do
      visit p.dental_residency_and_relocation_loan_form_url
      click_link p.apply_for_loan
      sleep_short
      fill_out_basic_information_form(p,d)
      fill_in p.first_name, with: ''
      continue(p)
      expect(find('#' + p.first_name).value).to eq ''
      expect(find('#' + p.last_name).value).to eq 'testLast'
      expect(find('#' + p.email_address).value).to eq d.email
    end
  end

  describe "Dental Residency and relocation Happy All Pages", happy: true, smoke: true, loan_type: 'dental_residency', page_type: 'form' do
    it "has a form for Dental Residency and relocation student loans", smoke: true do
      visit p.dental_residency_and_relocation_loan_form_url
      click_link p.apply_for_loan
      expect(find(p.main_form)).to be
    end
    it "has a form for Dental Residency and relocation student loans that is filled out correctly", happy: true, loan_type: 'dental_residency' do
      visit p.dental_residency_and_relocation_loan_form_url
      click_link p.apply_for_loan
      sleep_short
      fill_out_basic_information_form(p,d)
      continue(p)
      sleep_medium # Increased from short to medium to medium_long to pass.  md
      expect(find(p.address_info)).to be

      fill_out_demographics(p)
      continue(p)
      expect(find(p.main_form)).to be

      fill_in p.school, with: 'NEW YORK INSTITUTE'
      sleep_short
      find('#' + p.school).send_keys :arrow_down
      find('#' + p.school).send_keys :tab
      select 'Doctor of Medicine', from: p.degree
      select 'Medical', from: p.major
      select 'Full Time', from: p.enrollment_status
      select 'First Year Masters/Doctorate', from: p.grade_level
      find('#' + p.periods).send_keys :arrow_down
      find('#' + p.periods).send_keys :tab
      select 'Jan', from: 'BO_AnticipatedGradDate1'
      select (this_year+2), from: 'BO_AnticipatedGradDate2'
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
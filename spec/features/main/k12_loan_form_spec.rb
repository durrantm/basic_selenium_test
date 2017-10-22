require 'yaml'
require 'spec_helper'
require_relative '../../support/page_object'
require_relative '../../support/form_data_object'
require_relative '../../support/sleep_lengths'
require_relative '../../support/sleepers'
require_relative '../../support/form_helpers'
require_relative '../../support/form_sections'

describe 'K12 loan products' do
  include Sleepers
  include FormHelpers
  include FormSections
  p = PageObject.new
  d = FormDataObject.new
  describe "K12 Sad Page 1", sad: true, loan_type: 'k12', page_type: 'form' do
    it "has a form for K12 student loans that is filled out Incorrectly", happy: true, loan_type: 'k12' do
      visit_url(TEST_ENVIRONMENT, p.k12_loan_form_url, p.k12_loan_form_id, p)
      sleep_short
      fill_out_basic_information_form(p,d)
      fill_in p.first_name, with: ''
      continue(p)
      expect(find('#' + p.first_name).value).to eq ''
      expect(find('#' + p.last_name).value).to eq 'testLast'
      expect(find('#' + p.email_address).value).to eq d.email
      # TODO add expects for other values that were entered
    end
  end

  describe "K12 Training Happy All Pages", happy: true, smoke: true, loan_type: 'k12', page_type: 'form' do
    it "has a form for k12 training student loans", smoke: true, loan_type: 'k12' do
      visit_url(TEST_ENVIRONMENT, p.k12_loan_form_url, p.k12_loan_form_id, p)
      expect(find(p.main_form)).to be
    end
    it "has a form for K12 student loans that is filled out correctly", happy: true, loan_type: 'k12' do
      visit_url(TEST_ENVIRONMENT, p.k12_loan_form_url, p.k12_loan_form_id, p)
      sleep_short
      fill_out_basic_information_form(p,d)
      select 'Parent', from: p.relationship_to_student
      continue(p)
      sleep_medium # Increased from short to medium to pass.  md
      expect(find(p.address_info)).to be

      fill_out_demographics(p)
      continue(p)
      expect(find(p.main_form)).to be
      sleep_short
      fill_in p.student_first_name, with: 'testfirst'
      fill_in p.student_last_name, with: 'testLast'
      select 'JAN', from: p.student_dob_month
      fill_in p.student_dob_day, with: '01'
      fill_in p.student_dob_year, with: '1996'
      fill_out_student_ssn_and_confirm_ssn(p)
      fill_in p.school, with: "NEW YORK MILITARY"
      sleep_short
      find('#' + p.school).send_keys :arrow_down
      find('#' + p.school).send_keys :tab
      select 'Kindergarten', from: p.grade_level
      continue(p)
      sleep_medium # Increased from short to medium to pass.  md
      expect(find('#' + p.requested_loan)).to be

      fill_in p.requested_loan, with: '4000'
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

      within_frame(find(p.dialog_frame)) do
        find(p.electronic_consent).click
      end

      sleep_short

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

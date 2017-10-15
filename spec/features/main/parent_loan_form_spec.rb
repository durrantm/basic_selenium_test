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

  describe "Parent Sad Page 1", sad: true, loan_type: 'parent', page_type: 'form' do
    it "has a form for parent loans that is filled out Incorrectly", happy: true, loan_type: 'parent' do
      visit p.parent_loan_form_url
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

  describe "Parent Happy All Pages", happy: true, smoke: true, loan_type: 'parent', page_type: 'form' do
    it "has a form for parent student loans", smoke: true do
      visit p.parent_loan_form_url
      click_link p.apply_for_loan
      expect(find(p.main_form)).to be
    end
    it "has a form for parent student loans that is filled out correctly", happy: true, loan_type: 'parent' do
      visit p.parent_loan_form_url
      click_link p.apply_for_loan
      sleep_short
      fill_out_basic_information_form(p,d)
      select 'Parent', from: p.relationship_to_student
      continue(p)
      sleep_medium # Increased from short to medium to to pass.  md
      expect(find(p.address_info)).to be

      fill_out_demographics(p)
      continue(p)
      expect(find(p.main_form)).to be

      sleep_short
      fill_in p.student_first_name, with: 'testFirst'
      fill_in p.student_last_name, with: 'testLast'
      select 'JAN', from: p.student_dob_month
      fill_in p.student_dob_day, with: '01'
      fill_in p.student_dob_year, with: '1996'
      select 'US Citizen', from: 'BO_ST_Citizenship'
      fill_in p.student_SSN_first_3, with: '000'
      fill_in p.student_SSN_middle_2, with: '66'
      fill_in p.student_SSN_last_4, with: '0000'
      fill_in p.student_SSN_first_3_confirm, with: '000'
      fill_in p.student_SSN_middle_2_confirm, with: '66'
      fill_in p.student_SSN_last_4_confirm, with: '0000'

      fill_in p.school, with: 'NEW YORK LAW SCHOOL, NEW YORK, NY, 00278300'
      sleep_short
      find('#' + p.school).send_keys :arrow_down
      find('#' + p.school).send_keys :tab
      fill_out_education_degree_information(p, this_year)
      continue(p)
      sleep_medium # Increased from short to medium to pass.  md

      fill_out_loan_information(p)
      continue(p)
      sleep_short
      expect(find '#' + p.employment_status).to be

      fill_out_employment_information(p)
      continue(p)
      sleep_short

      check(p.checking_account)
      expect(find '#' + p.checking_amount).to be

      fill_out_financial_information(p)
      continue(p)
      choose p.how_to_apply, option: 'I'
      continue(p)
      sleep_short
      within_frame(find(p.dialog_frame)) do
        first('input#rdoStudentDependentConfirmation').click
      end
      submit_application(p)
      sleepy Sleep_lengths[:long]
      expect(find(p.title, text: /^Application Status$/)).to be
      sleep_short
    end
  end
end

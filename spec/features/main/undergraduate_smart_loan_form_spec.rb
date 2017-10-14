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

  describe "Undergraduate Sad Page 1", sad: true, loan_type: 'undergraduate', page_type: 'form' do
    it "has a form for undergraduate student loans that is filled out Incorrectly", happy: true, loan_type: 'undergraduate' do
      visit p.undergraduate_loan_form_url
      click_link p.apply_for_loan
      sleep_short
      fill_out_basic_information_form(p,d)
      fill_in p.first_name, with: ''
      find(p.continue).click
      expect(find('#' + p.first_name).value).to eq ''
      expect(find('#' + p.last_name).value).to eq 'testLast'
      expect(find('#' + p.email_address).value).to eq d.email
    end
  end

  describe "Undergraduate Happy All Pages", happy: true, smoke: true, loan_type: 'undergraduate', page_type: 'form' do
    it "has a form for undergraduate student loans", smoke: true do
      visit p.undergraduate_loan_form_url
      click_link p.apply_for_loan
      expect(find(p.main_form)).to be
    end
    it "has a form for undergraduate student loans that is filled out correctly", happy: true, loan_type: 'undergraduate' do
      visit p.undergraduate_loan_form_url
      click_link p.apply_for_loan
      sleep_short
      fill_out_basic_information_form(p,d)
      find(p.continue).click
      sleep_medium # Increased from short to medium to medium_long to pass.  md
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
      fill_in p.school, with: 'NEW YORK LAW SCHOOL, NEW YORK, NY, 00278300'
      sleep_short
      find('#' + p.school).send_keys :arrow_down
      find('#' + p.school).send_keys :tab
      fill_out_education_degree_information(p, this_year)
      find(p.continue).click
      sleep_medium # Increased from short to medium to pass.  md
      expect(find('#' + p.copay)).to be

      fill_out_loan_information(p)
      find(p.continue).click
      sleep_short
      expect(find '#' + p.employment_status).to be

      fill_out_employment_information(p)
      find(p.continue).click
      expect(find '#' + p.checking_account).to be

      check(p.checking_account)
      expect(find '#' + p.checking_amount).to be

      fill_out_financial_information(p)
      find(p.continue).click
      sleep_short
      expect(find '#' + p.primary_contact_first_name).to be

      fill_out_contact_information(p)
      find(p.continue).click
      choose p.how_to_apply, option: 'I'
      find(p.continue).click
      sleep_short
      expect(find p.dialog_frame).to be

      within_frame(find(p.dialog_frame)) do
        find(p.electronic_consent).click
      end
      sleep_short
      accept_dialogs(p)

      within_frame(find(p.dialog_frame)) do
        find(p.submit_application).click
      end

      sleepy Sleep_lengths[:long]
      expect(find(p.title, text: /^Application Status$/)).to be
      sleep_short
    end
  end
end

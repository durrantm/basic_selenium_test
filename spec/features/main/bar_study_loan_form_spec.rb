describe 'student loan products' do
  include Sleepers
  include FormHelpers
  include FormSections
  include WaitForAjax

  p = PageObject.new
  d = FormDataObject.new

  describe "Bar Study Sad Page 1", sad: true, loan_type: 'bar', page_type: 'form' do
    it "has a form for Bar Study student loans that is filled out Incorrectly", happy: true, loan_type: 'graduate' do
      visit_url(TEST_ENVIRONMENT, p.bar_study_loan_form_url, p.bar_study_loan_form_id, p)
      fill_out_basic_information_form(p,d)
      fill_in p.first_name, with: ''
      continue(p)
      expect(find_by_id(p.first_name).value).to eq ''
      expect(find_by_id(p.last_name).value).to eq 'testLast'
      expect(find_by_id(p.email_address).value).to eq d.email
    end
  end

  describe "Bar Study Happy All Pages", happy: true, smoke: true, loan_type: 'graduate', page_type: 'form' do
    it "has a form for Bar Study student loans", smoke: true do
      visit_url(TEST_ENVIRONMENT, p.bar_study_loan_form_url, p.bar_study_loan_form_id, p)
      find p.main_form, visible: true
      expect(find(p.main_form)).to be
    end
    it "has a form for Bar Study student loans that is filled out correctly", happy: true, loan_type: 'graduate' do
      visit_url(TEST_ENVIRONMENT, p.bar_study_loan_form_url, p.bar_study_loan_form_id, p)
      fill_out_basic_information_form(p,d)
      continue(p)
      fill_out_address(p)
      continue(p)
      fill_out_school(p, 'DRAKE')
      wait_for_ajax
      find_by_id p.degree
      select 'Juris Doctor (JD)', from: p.degree
      select 'Full Time', from: p.enrollment_status
      select 'Jan', from: p.graduation_date_month
      select this_year, from: p.graduation_date_year
      select 'Jan', from: p.exam_date_month
      select this_year, from: p.exam_date_year
      continue(p)
      wait_to_see_medium { find_by_id p.requested_loan }
      fill_in p.requested_loan, with: 10000
      fill_out_disbursement_information(p, this_year)
      continue(p)
      fill_out_employment_information(p)
      continue(p)
      fill_out_financial_information(p)
      continue(p)
      fill_out_contact_information(p)
      continue(p)
      wait_to_see_medium { first '#' + p.how_to_apply }
      choose p.how_to_apply, option: 'I'
      continue(p)
      wait_to_see_medium { find p.dialog_frame }
      within_frame(find(p.dialog_frame)) do
        find(p.electronic_consent).click
      end
      find(p.dialog_frame)
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

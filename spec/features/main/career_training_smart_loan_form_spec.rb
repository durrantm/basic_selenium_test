describe 'student loan products' do
  include Sleepers
  include FormHelpers
  include FormSections
  include WaitForAjax

  p = PageObject.new
  d = FormDataObject.new
  describe "Career Training Sad Page 1", sad: true, loan_type: 'career_training', page_type: 'form' do
    it "has a form for career training student loans that is filled out Incorrectly", happy: true, loan_type: 'career_training' do
      visit_url(TEST_ENVIRONMENT, p.career_training_loan_form_url, p.career_training_loan_form_id, p)
      fill_out_basic_information_form(p,d)
      fill_in p.first_name, with: ''
      continue(p)
      expect(find_by_id(p.first_name).value).to eq ''
      expect(find_by_id(p.last_name).value).to eq 'testLast'
      expect(find_by_id(p.email_address).value).to eq d.email
      # TODO add expects for other values that were entered
    end
  end

  describe "Career Training Happy All Pages", happy: true, smoke: true, loan_type: 'career_training', page_type: 'form' do
    it "has a form for carer training student loans", smoke: true, loan_Type: 'career_training' do
      visit_url(TEST_ENVIRONMENT, p.career_training_loan_form_url, p.career_training_loan_form_id, p)
      find p.main_form, visible: true
      expect(find(p.main_form)).to be
    end
    it "has a form for career training student loans that is filled out correctly", happy: true, loan_type: 'career_training' do
      visit_url(TEST_ENVIRONMENT, p.career_training_loan_form_url, p.career_training_loan_form_id, p)
      fill_out_basic_information_form(p,d)
      continue(p)
      fill_out_address(p)
      continue(p)
      fill_out_school(p, 'NEW YORK METHODIST HOSPITAL')
      wait_for_ajax
      find_by_id p.degree
      fill_out_education_certificate_information(p, this_year)
      continue(p)
      wait_to_see_medium { find_by_id p.copay }
      fill_out_loan_information(p)
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
      wait_to_see_short { find p.dialog_frame }
      submit_application(p)
      sleepy Sleep_lengths[:long]
      expect(find(p.title, text: /^Application Status$/)).to be
      sleep_short
    end
  end
end

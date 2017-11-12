module Sleepers
  def sleepy(sleep_length=2)
  	sleep sleep_length
  end
  def sleep_short
  	sleep Sleep_lengths[:short]
  end
  def sleep_medium
  	sleep Sleep_lengths[:medium]
  end
  def wait_to_see_short(&code)
    wait = Selenium::WebDriver::Wait.new(:timeout => sleep_short)
    wait.until { yield }
  end
  def wait_to_see_medium(&code)
    sleep 1
    wait = Selenium::WebDriver::Wait.new(:timeout => sleep_medium)
    wait.until { yield }
  end
end

module Sleepers
  def sleepy(sleep_length=2)
  	sleep sleep_length
  end
  def sleep_short
  	sleep Sleep_lengths[:short]
  end
  def wait_to_see_short(&code)
    wait = Selenium::WebDriver::Wait.new(:timeout => sleep_short)
    wait.until { yield }
  end
end

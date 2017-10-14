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
end

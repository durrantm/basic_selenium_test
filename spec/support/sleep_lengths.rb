Sleep_lengths = Hash.new
if PRODUCTION
	Sleep_lengths[:short] = 2
	Sleep_lengths[:medium] = 4
	Sleep_lengths[:medium_long] = 16
	Sleep_lengths[:long] = 40
else
	Sleep_lengths[:short] = 2
	Sleep_lengths[:medium] = 8
	Sleep_lengths[:medium_long] = 16
	Sleep_lengths[:long] = 60
end

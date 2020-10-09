function fish_right_prompt
	if [ $last_status -ne 0 ]
		set_color FFFFFF
		echo -ns ""
		set_color -b FFFFFF
		set_color FF0000
		echo -ns " $last_status "
	end

	echo -ns (_cmd_duration)

	set_color normal
end

function _cmd_duration -d 'Displays the elapsed time of last command and show notification for long lasting commands'
	set -l days ''; set -l hours ''; set -l minutes ''; set -l seconds ''
	set -l duration (expr $CMD_DURATION / 1000)
	if [ $duration -gt 0 ]
		set timeM (expr $duration \% 68400 \% 3600 \% 60)
		test $timeM -ne 0; and set seconds $timeM's'
		if [ $duration -ge 60 ]
			set timeM (expr $duration \% 68400 \% 3600 / 60)
			test $timeM -ne 0; and set minutes $timeM'm'
			if [ $duration -ge 3600 ]
				set timeM (expr $duration \% 68400 / 3600)
				test $timeM -ne 0; and set hours $timeM'h'
				if [ $duration -ge 68400 ]
					set timeM (expr $duration / 68400)
					test $timeM -ne 0; and set days $timeM'd'
				end
			end
		end

		set -l duration ""
		test -n $days; and set duration "$duration$days "
		test -n $hours; and set duration "$duration$hours "
		test -n $minutes; and set duration "$duration$minutes "
		test -n $seconds; and set duration "$duration$seconds "
		
		echo -ns (set_color 3A3A3A) "" (set_color -b 3A3A3A) (set_color afaf87) " $duration"
	end

	# OS X notification when a command takes longer than notify_duration and iTerm is not focused
	set notify_duration 10000
	set exclude_cmd "bash|less|man|more|ssh"
	if begin
		test $CMD_DURATION -gt $notify_duration
		and echo $history[1] | grep -vqE "^($exclude_cmd).*"
	end
	set -l osname (uname)
	if test $osname = Darwin          # only show notification in OS X
		#Only show the notification if iTerm and Terminal are not focused
		echo "
			tell application \"System Events\"
				set activeApp to name of first application process whose frontmost is true
				if \"iTerm\" is not in activeApp and \"Terminal\" is not in activeApp then
					display notification \"Finished in $duration\" with title \"$history[1]\"
				end if
			end tell
			" | osascript
		end
	end
end
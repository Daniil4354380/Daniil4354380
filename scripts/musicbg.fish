#!/usr/bin/env fish

set musicdir ~/Music/sync/

if set -q TERMUX_VERSION
	function setbg
		termux-wallpaper -f $argv[1]
		termux-wallpaper -l -f $argv[1]
	end
	function notify
		termux-notification -i cmus -t musicbg -c $argv[1]
	end
else
	switch $XDG_SESSION_TYPE
		case wayland
			function setbg
				swww img -t none --resize crop $argv[1]
			end
		case x11
			function setbg
				feh --bg-max $argv[1]
			end
	end
	function notify
		notify-send $argv[1]
	end
end

function loop
	set player $argv[1]
	set oldtrack ''
	while pidof -q $player
		if test -f ~/lock-mb
			notify 'musicbg locked'
			break
		else
			switch $player
				case cmus
					set track (path basename (cmus-remote -Q | grep file))
				case mpv
					set track (string sub -s 33 (playerctl metadata | grep 'mpv   xesam:title'))
			end
			if test $track != $oldtrack
				set oldtrack $track
				set bname (string sub -e -(string length (path extension $track)) $track)
				set image (fd -e png -e jpg -1 --base-directory $musicdir \
					--absolute-path --fixed-strings $bname)
				echo $image
				setbg $image
			end
		end
		sleep 1
	end
end

if pidof -q cmus
	loop cmus
else if pidof -q mpv
	loop mpv
else
	notify 'Плеер не запущен!'
end

echo "end, $(date)"

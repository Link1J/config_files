# enable keybindings
function fish_user_key_bindings
	if not fish_vercheck 3.0.0
		abbr -a && 'commandline -i "; and"'
		abbr -a || 'commandline -i "; or"'
	end
end

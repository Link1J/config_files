function ls
	if type -fq colorls
		colorls $argv
	else if type -fq ls
		command ls --color $argv
	end
end

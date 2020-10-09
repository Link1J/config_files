function ls
	if type -fq colorls
		colorls $argv
	else if type -fq ls
		command ls $argv
	end
end

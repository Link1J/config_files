function fish_vercheck -a expected actual
	if test -z "$actual"
		set actual $FISH_VERSION
	end
	begin; echo $expected; echo $actual; end | sort --check=silent --version-sort
	return $status
end
set branch_glyph     \uF418
set detached_glyph   \uF417
set tag_glyph        \uF412

set git_dirty_glyph      \uF448
set git_staged_glyph     \uF457
set git_stashed_glyph    \uF48D
set git_untracked_glyph  \uF41B
set git_conflicted_glyph \uF421
set git_unmerged_glyph   \uF459
set git_deleted_glyph    \uF458
set git_renamed_glyph    \uF45A

set git_ahead_glyph      \uF431
set git_behind_glyph     \uF433

set -g ICON_NODE                  \UE718" "     #  from Devicons or ⬢
set -g ICON_RUBY                  \UE791" "     # \UE791 from Devicons; \UF047; \UE739; 💎
set -g ICON_PYTHON                \UE606" "     # \UE606; \UE73C
set -g ICON_PERL                  \UE769" "     # 
set -g ICON_TEST                  \UF091        # 
set -g ICON_VCS_UNTRACKED         \UF420" "     #  there are untracked (new) files
set -g ICON_VCS_UNMERGED          \UFA59" "     # 繁there are unmerged commits
set -g ICON_VCS_MODIFIED          \UF459" "     # 
set -g ICON_VCS_STAGED            \UF457" "     # 
set -g ICON_VCS_DELETED           \UF458" "     # 
set -g ICON_VCS_DIFF              \UF440" "     # 
set -g ICON_VCS_RENAME            \UF45A" "     # 
set -g ICON_VCS_STASH             \UF0CF" "     # ✭ there are stashed commits
set -g ICON_VCS_INCOMING_CHANGES  \UF409" "     # 
set -g ICON_VCS_OUTGOING_CHANGES  \UF40A" "     # 
set -g ICON_VCS_TAG               \UF412" "     # 
set -g ICON_VCS_BOOKMARK          \UF461" "     # 
set -g ICON_VCS_COMMIT            \UF417" "     # 
set -g ICON_VCS_BRANCH            \UF418        # 
set -g ICON_VCS_REMOTE_BRANCH     \UE804" "     #  not displayed, should be branch icon on a book
set -g ICON_VCS_DETACHED_BRANCH   \U27A6" "     # ➦
set -g ICON_VCS_GIT               \UF7A1" "     #  from Octicons
set -g ICON_VCS_HG                \F0DD" "      #   Got cut off from Octicons on patching
set -g ICON_VCS_CLEAN             \UF42E        # 
set -g ICON_VCS_PUSH              \UF403        # 
set -g ICON_VCS_DIRTY             ±             #
set -g ICON_ARROW_UP              \UF431""      # 
set -g ICON_ARROW_DOWN            \UF433""      # 
set -g ICON_OK                    \UF42E        # 
set -g ICON_FAIL                  \UF467        # 
set -g ICON_STAR                  \UF41E        # 
set -g ICON_JOBS                  \U2699" "     # ⚙
set -g ICON_VIM                   \UE7C5" "     # 

set -g PRINT_SPLITER_CALL_COUNT 0

function print_spliter
	if test "$PRINT_SPLITER_CALL_COUNT" -gt 0
		echo -ns ''
	else 
		echo -ns ''
	end
	set -g PRINT_SPLITER_CALL_COUNT 1
end

function prompt_status -S -a last_status
	set -l nonzero
	set -l superuser
	set -l bg_jobs

	# Last exit was nonzero
	[ $last_status -ne 0 ]
	and set nonzero 1

	# Jobs display
	jobs -p >/dev/null
	and set bg_jobs 1

	set_color -b 3A3A3A
	if [ "$nonzero" ]
		set_color ff0000
	else
		set_color 4E9A06
	end
	echo -ns " " $last_status " "

	if [ "$bg_jobs" ]
		echo -ns (set_color afaf87)' % '
	end
	set_color 3A3A3A
end

function print_user
	set_color -b 00FF00
	print_spliter
	echo -ns (set_color black) " $USER " (set_color 00FF00) 
	set_color -b 7F7F7F
	print_spliter
	echo -ns (set_color black) " " (hostname) " " (set_color 7F7F7F) 
end

function _col                                     #Set Color 'name b u' bold, underline
	set -l col; set -l bold; set -l under
	if [ -n "$argv[1]" ];       set col   $argv[1]; end
	if [ (count $argv) -gt 1 ]; set bold  "-"(string replace b o $argv[2] 2>/dev/null); end
	if [ (count $argv) -gt 2 ]; set under "-"$argv[3]; end
	set_color $bold $under $argv[1]
end

function git_prompt
	set -l git_toplevel (command git rev-parse --show-toplevel 2>/dev/null)
	test -z "$git_toplevel"; and return

	set -l branch (git symbolic-ref -q HEAD 2>/dev/null | cut -c 12-)
	set -l tag (git describe --tags --exact-match 2>/dev/null)
	set -l detached (git show-ref --head -s --abbrev | head -n1 2>/dev/null)

	set -l ahead 0 
	set -l behind 0

	if [ "$branch" ]
		set -l remote_name  (git config branch.$branch.remote)

		if test -n "$remote_name"
			set merge_name (git config branch.$branch.merge)
			set merge_name_short (echo $merge_name | cut -c 12-)
		else
			set remote_name "origin"
			set merge_name "refs/heads/$branch"
			set merge_name_short $branch
		end

		if [ $remote_name = '.' ]  # local
			set remote_ref $merge_name
		else
			set remote_ref "refs/remotes/$remote_name/$merge_name_short"
		end

		set -l rev_git (eval "git rev-list --left-right $remote_ref...HEAD" ^/dev/null)
		if test $status != "0"
			set rev_git (eval "git rev-list --left-right $merge_name...HEAD" ^/dev/null)
		end

		for i in $rev_git
			if echo $i | grep '>' >/dev/null
			   set isAhead $isAhead ">"
			end
		end

		set -l remote_diff (count $rev_git)
		set ahead (count $isAhead)
		set behind (math $remote_diff - $ahead)
	end

	set -l changedFiles (git diff --name-status | cut -c 1-2)
	set -l stagedFiles (git diff --staged --name-status | cut -c 1-2)

	set -l changed (math (count $changedFiles) - (count (echo $changedFiles | grep "U")))
	set -l conflicted (count (echo $stagedFiles | grep "U"))
	set -l staged (math (count $stagedFiles) - $conflicted)
	set -l untracked (count (git ls-files --others --exclude-standard))

	set -l background 202020
	set -l foreground addc10
	
	echo -ns (set_color -b $background) ' ' (set_color $foreground)

	if [ "$branch" ]
		echo -ns "$ICON_VCS_BRANCH $branch "
	else if [ "$tag" ]
		echo -ns "$ICON_VCS_TAG $tag "
	else
		echo -ns "$ICON_VCS_DETACHED_BRANCH $detached "
	end

	if test $ahead -o $behind -o $changed -o $conflicted -o $staged -o $untracked
		test $ahead -gt 0; and echo -ns "  $ICON_ARROW_UP$ahead "
		test $behind -gt 0; and echo -ns "  $ICON_ARROW_DOWN$behind "

		if test $changed -o $conflicted -o $staged -o $untracked
			echo -ns " "

			set -l git_status (command git status --porcelain 2> /dev/null | cut -c 1-2)

			if [ (echo -sn $git_status\n | egrep -c "[ACDMT][ MT]|[ACMT]D") -gt 0 ]      #added
				echo -ns (set_color brgreen)$ICON_VCS_STAGED
			end
			if [ (echo -sn $git_status\n | egrep -c "[ ACMRT]D") -gt 0 ]                  #deleted
				echo -ns (set_color red)$ICON_VCS_DELETED
			end
			if [ (echo -sn $git_status\n | egrep -c ".[MT]") -gt 0 ]                      #modified
				echo -ns (set_color FF8C00)$ICON_VCS_MODIFIED
			end
			if [ (echo -sn $git_status\n | egrep -c "R.") -gt 0 ]                         #renamed
				echo -n (set_color purple)$ICON_VCS_RENAME
			end
			if [ (echo -sn $git_status\n | egrep -c "AA|DD|U.|.U") -gt 0 ]                #unmerged
				echo -ns (set_color brred)$ICON_VCS_UNMERGED
			end
			if [ (echo -sn $git_status\n | egrep -c "\?\?") -gt 0 ]                       #untracked (new) files
				echo -ns (set_color brcyan)$ICON_VCS_UNTRACKED
			end
			if test (command git rev-parse --verify --quiet refs/stash >/dev/null)        #stashed (was '$')
				echo -ns (set_color brred)$ICON_VCS_STASH
			end

			echo -ns " "
		end
	end

	set_color $background
end

function print_pwd
	set_color -b 3A3A3A
	print_spliter
	set_color afaf87	
	echo -ns " " (prompt_pwd) " "
	set_color 3A3A3A
end

function fish_prompt
	set -g PRINT_SPLITER_CALL_COUNT 0
	set -g last_status $status

	print_user
	print_pwd
	git_prompt

	set_color -b 9F9F9F
	print_spliter
	echo -ns (set_color black) " " (tty | sed -e "s:/dev/::") " " (set_color 9F9F9F) 
	
	echo -ens "\e[49m"

	set_color normal
	echo -ens "\n"
	set_color $fish_color_autosuggestion
	echo -ens " "
	set_color normal
end
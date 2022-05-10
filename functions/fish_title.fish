function fish_title

	set -l process $_
	set -l god ""
	set -l on_project ""
	set -l title ""

	if [ (whoami) = "root" -o $process = "sudo" ]
		set god "( ⚡ )"
	end

	if set -q FISH_TITLE
		set title $FISH_TITLE
	else
		if [ $process = "fish" ]
			set title (prompt_pwd)
		else
			if git_is_repo
				and test -n git_repository_root
				set on_project " on "(basename (git_repository_root))
			end

			if [ $process = "sudo" ]
				set process (echo $argv | sed -e 's/^ *//g' -e 's/^sudo *//g' -e 's/\(^[^ ]*\)\(.*\)/\1/g')
			end

			set title $process""$on_project
		end
	end

	echo "$god  $title"

end

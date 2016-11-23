set -g glyph_git_has_staged_changes '±' # Alternatives: ~+±
set -g glyph_git_has_stashes '≡'
set -g glyph_git_has_untracked_files '…' # Alternatives: …☡+±
set -g glyph_git_is_ahead '⭱' # Alternatives: ⭱⭡↑⤽⤼
set -g glyph_git_is_behind '⭳' # Alternatives: ⭳⭣↓⤽⤼
set -g glyph_git_is_dirty '*'
set -g glyph_git_is_diverged '🔀' # Alternatives: ⭿⮁⇅ ⤲⤱⤮⤭ 🔄🔀
set -g glyph_git_on_branch '⎇ ' # Alternatives: 🜉⎇
set -g glyph_git_on_detached '⌀'
set -g glyph_git_on_tag '⌂'

set -g glyph_bg_jobs '⚙ ' # Alternatives: ⛭⚙⚒
set -g glyph_input_start '❭' # Alternatives: 〉❭❯❱⟩⟫
set -g glyph_regular_user '•'
set -g glyph_status_zero '•'
set -g glyph_superpower '⌁' # Alternatives: 🗲⚡⌁ϟ

set -g glyph_nodejs_logo '⬡ ' # Alternatives: ⬡⌬⏣

set -g glyph_vagrant_logo '🇻' # Alternatives: ᴠ▿▾ⅤⅴṿṾＶ𝐕𝕍𝕧𝘃Ⓥⓥ🅅🅥🆅🇻
# Skipping `vagrant status` because it is extremly slow
# set -g glyph_vagrant_running '↑'
# set -g glyph_vagrant_poweroff '↓'
# set -g glyph_vagrant_aborted '✕'
# set -g glyph_vagrant_saved '⇡'
# set -g glyph_vagrant_stopping '⇣'
# set -g glyph_vagrant_unknown '!'


function fish_prompt --description 'bigfish: A long two-lines fish prompt'
    # Requires to be set before any other set calls
    set -l last_status $status

    set -l leftPrompt ''
    set -l padding ''
    set -l rightPrompt ''
    set -l bottomPrompt ''

    # Assamble the left prompt

    # Current directory
    set leftPrompt (bf_concat_segments $leftPrompt (bf_pwd) blue normal true)

    # Display gear if there are any background jobs
    if test (jobs | wc -l) -gt 0
        set leftPrompt (bf_concat_segments $leftPrompt ' ╱ ' grey normal)
        set leftPrompt (bf_concat_segments $leftPrompt $glyph_bg_jobs magenta normal true)
    end

    # git
    if git_is_repo
      set leftPrompt (bf_concat_segments $leftPrompt ' ╱ ' grey normal)
      set leftPrompt (bf_concat_segments $leftPrompt (bf_get_git_status_info) \
          (git_is_touched; and echo yellow; or echo green) normal)
    end

    # node
    if lookup package.json > /dev/null
        set leftPrompt (bf_concat_segments $leftPrompt ' ╱ ' grey normal)
        set leftPrompt (bf_concat_segments $leftPrompt \
            (node --version | sed "s/v/$glyph_nodejs_logo/") cyan normal)
    end

    # vagrant
    if lookup Vagrantfile > /dev/null
        set leftPrompt (bf_concat_segments $leftPrompt ' ╱ ' grey normal)
        set leftPrompt (bf_concat_segments $leftPrompt $glyph_vagrant_logo purple normal)
    end

    # Assamble the right prompt

    # Last command duration
    set rightPrompt (bf_concat_segments $rightPrompt \
        (echo $CMD_DURATION | humanize_duration) grey normal true)
    set rightPrompt (bf_concat_segments $rightPrompt ' ╱ ' grey normal)
    # When did the last command finish
    set rightPrompt (bf_concat_segments $rightPrompt (date '+%T') grey normal)
    set rightPrompt (bf_concat_segments $rightPrompt ' ╱ ' grey normal)
    # Last command's status code
    set rightPrompt (bf_concat_segments $rightPrompt \
        (test 0 = $last_status; and echo $glyph_status_zero; or echo $last_status) \
        (test 0 = $last_status; and echo grey; or echo red) normal \
        (test 0 = $last_status; and echo false; or echo true))

    # Calculate padding
    set paddding (bf_create_padding \
        (math $COLUMNS - (bf_remove_color $leftPrompt$rightPrompt | string length)))

    # Assamble second line of the prompt
    if test (whoami) = "root"
        set bottomPrompt (bf_concat_segments $bottomPrompt \
            "$glyph_superpower$glyph_input_start " red normal)
    else
        set bottomPrompt (bf_concat_segments $bottomPrompt \
            "$glyph_regular_user$glyph_input_start " grey normal)
    end

    # Print the prompt

    # Print first line of the fish prompt
    printf $leftPrompt$paddding$rightPrompt
    # Jump to next line
    printf \n
    # Print second line of the fish prompt
    printf $bottomPrompt

end

function bf_get_git_status_info --description 'Get git info text with pglyphs'
    if git_is_tag
        printf $glyph_git_on_tag
    else if git_is_detached_head
        printf $glyph_git_on_detached
    else
        printf $glyph_git_on_branch
    end

    printf ' %s ' (git_branch_name)

    if not git_is_detached_head; and test -n (git_ahead)
        printf '%s ' (git_ahead $glyph_git_is_ahead $glyph_git_is_behind $glyph_git_is_diverged)
    end

    if git_is_stashed
        printf '%s ' $glyph_git_has_stashes
    end

    if git_is_staged
        printf '%s' $glyph_git_has_staged_changes
    end

    if git_is_dirty
        printf '%s' $glyph_git_is_dirty
    end

    if git_untracked_files > /dev/null
        printf '%s' $glyph_git_has_untracked_files
    end

end

function bf_concat_segments --argument-names previous next color bgcolor bold underline --description 'Concact two segments'
    printf "$previous"(bf_style_string $next $color $bgcolor $bold $underline)
end

function bf_style_string --argument-names text color bgcolor bold underline --description 'Style a string'
    set_color $color --background $bgcolor

    if test -n "$bold" -a "$bold" = true
        set_color --bold
    end

    if test -n "$underline" -a "$underline" = true
        set_color --underline
    end

    printf $text

    set_color normal
end

function bf_create_padding --argument-names amount --description 'Print N amount of spaces'
    printf "%-"$amount"s%s"
end

function bf_remove_color --description 'Remove color escape sequences from string'
    printf $argv | perl -pe 's/\x1b.*?[mGKH]//g'
end

function bf_pwd --description 'Print the current working directory, shortened a bit'
    echo $PWD | sed -e "s|^$HOME|~|" -e 's|\([^/.]\{3\}\)[^/]*/|\1/|g'
end

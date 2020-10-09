SEPARATOR_LEFT=""
SEPARATOR_RIGHT=""
PWD_LENGTH_LIMIT=55

__prompt_command() {
    local EXIT="$?"
    PS1=""

    local FG=0
    local BG=1
    local SEPARATOR=$SEPARATOR_LEFT

    set_color() {
        local plane=$1 red=$2 green=$3 blue=$4
        printf "%s" "\033[$((38+10*$plane));2;${red};${green};${blue}m"
    }
    reset() {
        if [ $# = 0 ]; then printf "%s" "\033[0m"
        else printf "%s" "\033[$((39+10*$1))m"; fi
    }
    write_sep() {
        printf "%s" "${SEPARATOR}"
    }
    strlen() {
        local clean=`printf "%s" "${1}" | sed -r 's/\\\033\[([0-9]{1,2}(;[0-9]{1,3})*)?[mK]//g'`
        printf "%d" "$((${#clean}-1))"
    }
    _pwd() {
        local PRE= NAME="$1" LENGTH="$2";
        if [ $LENGTH = 0 ]; then echo $NAME
        else
            [[ "$NAME" != "${NAME#$HOME/}" || -z "${NAME#$HOME}" ]] && PRE+='~' NAME="${NAME#$HOME}" LENGTH=$[LENGTH-1];
            ((${#NAME}>$LENGTH)) && NAME="/...${NAME:$[${#NAME}-LENGTH+4]}";
            echo "$PRE$NAME"
        fi
	}

    local l=`tty | sed -e "s:/dev/::"`
    local w=`_pwd "$PWD" $PWD_LENGTH_LIMIT`

    PS1+="$(set_color $BG   0 255   0;            set_color $FG   0   0   0) \u $(set_color $FG   0 255   0)" # Username
    PS1+="$(set_color $BG 127 127 127; write_sep; set_color $FG   0   0   0) \h $(set_color $FG 127 127 127)" # Hostname
    PS1+="$(set_color $BG  58  58  58; write_sep; set_color $FG 175 175 135) $w $(set_color $FG  58  58  58)" # Path
    PS1+="$(set_color $BG 159 159 159; write_sep; set_color $FG   0   0   0) $l $(set_color $FG 159 159 159)" # Terminal Device Name
    PS1+="$(reset     $BG            ; write_sep                           )\a\n$(reset     $FG            )" # Newline

    SEPARATOR=$SEPARATOR_RIGHT
    local PSR=""

    if [ $EXIT -ne 0 ]; then
        PSR+="$(set_color $FG 255 255 255; write_sep; set_color $BG 255 255 255; set_color $FG 255 0 0) $EXIT $(reset)"
    fi

    if [ "$(strlen "${PSR}")" -gt "-1" ]; then
        PS1+="$(tput sc; tput cuf $(tput cols); tput cub $(strlen "${PSR}"))${PSR}$(tput rc)"
    fi

    SEPARATOR=$SEPARATOR_LEFT
    PS1+="$(set_color $FG 88 88 88; write_sep; reset) "
}

PROMPT_COMMAND=__prompt_command
PS2=$SEPARATOR_LEFT
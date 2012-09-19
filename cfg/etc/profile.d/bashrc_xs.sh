#=============================================================#
#set -vx
# PERSONAL $HOME/.bashrc FILE for bash-3.0 (or later)
# By Emmanuel Rouat <no-email>
#
# Last modified: Sun Nov 30 16:27:45 CET 2008
# This file is read (normally) by interactive shells only.
# Here is the place to define your aliases, functions and
# other interactive features like your prompt.
#
# The majority of the code here assumes you are on a GNU 
# system (most likely a Linux box) and is based on code found
# on Usenet or internet. See for instance:
#
# http://tldp.org/LDP/abs/html/index.html
# http://www.caliban.org/bash/
# http://www.shelldorado.com/scripts/categories.html
# http://www.dotfiles.org/
#
# This bashrc file is a bit overcrowded -- remember it is just
# just an example. Tailor it to your needs.
#
#
#=============================================================

# --> Comments added by HOWTO author.


#-------------------------------------------------------------
# Source global definitions (if any)
#-------------------------------------------------------------


#if [ -f /etc/bashrc ]; then
#        . /etc/bashrc   # --> Read /etc/bashrc, if present.
#fi

#-------------------------------------------------------------
# Automatic setting of $DISPLAY (if not set already).
# This works for linux - your mileage may vary. ... 
# The problem is that different types of terminals give
# different answers to 'who am i' (rxvt in particular can be
# troublesome).
# I have not found a 'universal' method yet.
#-------------------------------------------------------------

function get_xserver ()
{
    case $TERM in
       xterm )
            XSERVER=$(who am i | awk '{print $NF}' | tr -d ')''(' ) 
            # Ane-Pieter Wieringa suggests the following alternative:
            # I_AM=$(who am i)
            # SERVER=${I_AM#*(}
            # SERVER=${SERVER%*)}

            XSERVER=${XSERVER%%:*}
            ;;
        aterm | rxvt)
        # Find some code that works here. ...
            ;;
    esac  
}

if [ -z ${DISPLAY:=""} ]; then
    get_xserver
    if [[ -z ${XSERVER}  || ${XSERVER} == $(hostname) || \
      ${XSERVER} == "unix" ]]; then 
        DISPLAY=":0.0"          # Display on local host.
    else
        DISPLAY=${XSERVER}:0.0  # Display on remote host.
    fi
fi

export DISPLAY

#-------------------------------------------------------------
# Some settings
#-------------------------------------------------------------
export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'
export HISTTIMEFORMAT="%H:%M > "
export HISTIGNORE="&:bg:fg:ll:h"
export HOSTFILE=$HOME/.hosts    # Put list of remote hosts in ~/.hosts ...



#-------------------------------------------------------------
# Greeting, motd etc...
#-------------------------------------------------------------

# Define some colors first:
red='\e[0;31m'
RED='\e[1;31m'
blue='\e[0;34m'
BLUE='\e[1;34m'
cyan='\e[0;36m'
CYAN='\e[1;36m'
NC='\e[0m'              # No Color
# --> Nice. Has the same effect as using "ansi.sys" in DOS.


# Looks best on a terminal with black background.....
echo -e "${CYAN}This is BASH ${RED}${BASH_VERSION%.*}\
${CYAN} - DISPLAY on ${RED}$DISPLAY${NC}\n"
date
function _exit()        # Function to run upon exit of shell.
{
    echo -e "${RED}Hasta la vista, baby${NC}"
}
trap _exit EXIT


#-------------------------------------------------------------
# Shell Prompt
#-------------------------------------------------------------


if [[ "${DISPLAY%%:0*}" != "" ]]; then  
    HILIT=${red}   # remote machine: prompt will be partly red
else
    HILIT=${cyan}  # local machine: prompt will be partly cyan
fi

#  --> Replace instances of \W with \w in prompt functions below
#+ --> to get display of full path name.

function fastprompt()
{
    unset PROMPT_COMMAND
    case $TERM in
        *term | rxvt )
            #PS1="${HILIT}[\h]$NC \W > \[\033]0;\${TERM} [\u@\h] \w\007\]" ;;
            PS1="${HILIT}[\h]$NC \W >"  ;;
        linux )
            PS1="${HILIT}[\h]$NC \W > " ;;
        *)
            PS1="[\h] \W > " ;;
    esac
}


_powerprompt()
{
    LOAD=$(uptime|sed -e "s/.*: \([^,]*\).*/\1/" -e "s/ //g")
}

function powerprompt()
{

    PROMPT_COMMAND=_powerprompt
    case $TERM in
        *term | rxvt  )
            PS1="${HILIT}[\A - \$LOAD]$NC\n[\u@\h \#] \W > \
                 \[\033]0;\${TERM} [\u@\h] \w\007\]" ;;
        linux )
            PS1="${HILIT}[\A - \$LOAD]$NC\n[\u@\h \#] \W > " ;;
        * )
            PS1="[\A - \$LOAD]\n[\u@\h \#] \W > " ;;
    esac
}

powerprompt     # This is the default prompt -- might be slow.
                # If too slow, use fastprompt instead. ...

#===============================================================
#
# ALIASES AND FUNCTIONS
#
# Arguably, some functions defined here are quite big.
# If you want to make this file smaller, these functions can
# be converted into scripts and removed from here.
#
# Many functions were taken (almost) straight from the bash-2.04
# examples.
#
#===============================================================

#-------------------
# Personnal Aliases
#-------------------

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
# -> Prevents accidentally clobbering files.
alias mkdir='mkdir -p'

alias h='history'
alias j='jobs -l'
alias which='type -a'
alias ..='cd ..'
alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'
alias setg='set | grep '
alias print='/usr/bin/lp -o nobanner -d $LPDEST'
            # Assumes LPDEST is defined (default printer)
alias pjet='enscript -h -G -fCourier9 -d $LPDEST'
            # Pretty-print using enscript

alias du='du -kh'       # Makes a more readable output.
alias du1='du -h --max-depth=1 '
alias df='df -kTh'
alias ts='ssh root@172.18.96.1'
alias psl='ps ax|less'
alias vlm='less /var/log/messages'

#-------------------------------------------------------------
# The 'ls' family (this assumes you use a recent GNU ls)
#-------------------------------------------------------------
alias ll="ls -l --group-directories-first"
alias ls='ls -hF --color'  # add colors for filetype recognition
alias la='ls -Al'          # show hidden files
alias lx='ls -lXB'         # sort by extension
alias lk='ls -lSr'         # sort by size, biggest last
alias lc='ls -ltcr'        # sort by and show change time, most recent last
alias lu='ls -ltur'        # sort by and show access time, most recent last
alias lt='ls -ltr'         # sort by date, most recent last
alias lm='ls -al |more'    # pipe through 'more'
alias lr='ls -lR'          # recursive ls
alias tree='tree -Csu'     # nice alternative to 'recursive ls'

# If your version of 'ls' doesn't support --group-directories-first try this:
# function ll(){ ls -l "$@"| egrep "^d" ; ls -lXB "$@" 2>&-| \
#                egrep -v "^d|total "; }


#-------------------------------------------------------------
# tailoring 'less'
#-------------------------------------------------------------

alias more='less'
export PAGER=less
export LESSCHARSET='latin1'
#export LESSOPEN='|/usr/bin/lesspipe.sh %s 2>&-'
   # Use this if lesspipe.sh exists
#export LESS='-i -N -w  -z-4 -g -e -M -X -F -R -P%t?f%f \
#:stdin .?pb%pb\%:?lbLine %lb:?bbByte %bb:-...'


#-------------------------------------------------------------
# spelling typos - highly personnal and keyboard-dependent :-)
#-------------------------------------------------------------

alias xs='cd'
alias vf='cd'
alias moer='more'
alias moew='more'
alias kk='ll'


#-------------------------------------------------------------
# File & string-related functions:
#-------------------------------------------------------------


# Find a file with a pattern in name:
function ff() { find . -type f -iname '*'$*'*' -ls ; }

# Find a file with pattern $1 in name and Execute $2 on it:
function fe()
{ find . -type f -iname '*'${1:-}'*' -exec ${2:-file} {} \;  ; }

# Find a pattern in a set of files and highlight them:
# (needs a recent version of egrep)
function fstr()
{
    OPTIND=1
    local case=""
    local usage="fstr: find string in files.
Usage: fstr [-i] \"pattern\" [\"filename pattern\"] "
    while getopts :it opt
    do
        case "$opt" in
        i) case="-i " ;;
        *) echo "$usage"; return;;
        esac
    done
    shift $(( $OPTIND - 1 ))
    if [ "$#" -lt 1 ]; then
        echo "$usage"
        return;
    fi
    find . -type f -name "${2:-*}" -print0 | \
    xargs -0 egrep --color=always -sn ${case} "$1" 2>&- | more 

}

function cuttail() # cut last n lines in file, 10 by default
{
    nlines=${2:-10}
    #sed -n -e :a -e "1,${nlines}!{P;N;D;};N;ba" $1
}

function lowercase()  # move filenames to lowercase
{
    for file ; do
        filename=${file##*/}
        case "$filename" in
        */*) dirname==${file%/*} ;;
        *) dirname=.;;
        esac
        nf=$(echo $filename | tr A-Z a-z)
        newname="${dirname}/${nf}"
        if [ "$nf" != "$filename" ]; then
            mv "$file" "$newname"
            echo "lowercase: $file --> $newname"
        else
            echo "lowercase: $file not changed."
        fi
    done
}


function swap()  # Swap 2 filenames around, if they exist
{                #(from Uzi's bashrc).
    local TMPFILE=tmp.$$ 

    [ $# -ne 2 ] && echo "swap: 2 arguments needed" && return 1
    [ ! -e $1 ] && echo "swap: $1 does not exist" && return 1
    [ ! -e $2 ] && echo "swap: $2 does not exist" && return 1

    mv "$1" $TMPFILE 
    mv "$2" "$1"
    mv $TMPFILE "$2"
}


#-------------------------------------------------------------
# Process/system related functions:
#-------------------------------------------------------------

alias psg='ps ax|grep '
function my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,bsdtime,command ; }
function pp() { my_ps f | awk '!/awk/ && $0~var' var=${1:-".*"} ; }


function killps()                 # Kill by process name.
{
    local pid pname sig="-TERM"   # Default signal.
    if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
        echo "Usage: killps [-SIGNAL] pattern"
        return;
    fi
    if [ $# = 2 ]; then sig=$1 ; fi
    for pid in $(my_ps| awk '!/awk/ && $0~pat { print $1 }' pat=${!#} ) ; do
        pname=$(my_ps | awk '$1~var { print $5 }' var=$pid )
        if ask "Kill process $pid <$pname> with signal $sig?"
            then kill $sig $pid
        fi
    done
}

function my_ip() # Get IP adresses.
{
    MY_IP=$(/sbin/ifconfig ppp0 | awk '/inet/ { print $2 } ' | \
sed -e s/addr://)
    MY_ISP=$(/sbin/ifconfig ppp0 | awk '/P-t-P/ { print $3 } ' | \
sed -e s/P-t-P://)
}

function ii()   # Get current host related info.
{
    echo -e "\nYou are logged on ${RED}$HOST"
    echo -e "\nAdditionnal information:$NC " ; uname -a
    echo -e "\n${RED}Users logged on:$NC " ; w -h
    echo -e "\n${RED}Current date :$NC " ; date
    echo -e "\n${RED}Machine stats :$NC " ; uptime
    echo -e "\n${RED}Memory stats :$NC " ; free
    my_ip 2>&- ;
    echo -e "\n${RED}Local IP Address :$NC" ; echo ${MY_IP:-"Not connected"}
    echo -e "\n${RED}ISP Address :$NC" ; echo ${MY_ISP:-"Not connected"}
    echo -e "\n${RED}Open connections :$NC "; netstat -pan --inet;
    echo
}

#-------------------------------------------------------------
# Misc utilities:
#-------------------------------------------------------------

function repeat()       # Repeat n times command.
{
    local i max
    max=$1; shift;
    for ((i=1; i <= max ; i++)); do  # --> C-like syntax
        eval "$@";
    done
}


function ask()          # See 'killps' for example of use.
{
    echo -n "$@" '[y/n] ' ; read ans
    case "$ans" in
        y*|Y*) return 0 ;;
        *) return 1 ;;
    esac
}

function corename()   # Get name of app that created a corefile.
{ 
    for file ; do
        echo -n $file : ; gdb --core=$file --batch | head -1
    done 
}





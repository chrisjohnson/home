###########################################
# Set up the history
###########################################
HISTFILE=~/.zsh_hist
HISTSIZE=1000
SAVEHIST=1000

###########################################
# Auto CD, completion, history search
###########################################
setopt appendhistory autocd
setopt menucomplete
setopt completeinword # Enable in-word completion

bindkey -e
bindkey ' ' magic-space    # also do history expansion on space
# Make them work on some funky systems
bindkey '\e[1~'   beginning-of-line  # Linux console
bindkey '\e[H'    beginning-of-line  # xterm
bindkey '\eOH'    beginning-of-line  # gnome-terminal
bindkey '\e[2~'   overwrite-mode     # Linux console, xterm, gnome-terminal
bindkey '\e[3~'   delete-char        # Linux console, xterm, gnome-terminal
bindkey '\e[4~'   end-of-line        # Linux console
bindkey '\e[F'    end-of-line        # xterm
bindkey '\eOF'    end-of-line        # gnome-terminal
bindkey '^[[1;5D'    backward-word
bindkey '^[[1;5C'    forward-word
# not working http://zsh.sourceforge.net/FAQ/zshfaq04.html
#bindkey "^xc" expand-or-complete-prefix

# C-x <tab> to force file-completion only (no magic completions)
zle -C complete-files complete-word _generic
zstyle ':completion:complete-files:*' completer _files
bindkey '^x\t' complete-files

###########################################
# Auto completion
###########################################
# Enable it
zstyle :compinstall filename '/home/dmsuperman/.zshrc'
autoload -Uz compinit
compinit -C

# Case insensitive matching
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'm:{a-z}={A-Z}'

# Cache all the completions
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh/cache

# Set up the formatting
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*' format '%B---- %d%b'
zstyle ':completion:*:messages' format '%B%U---- %d%u%b'
zstyle ':completion:*:warnings' format "%B$fg[red]%}---- no match for: $fg[white]%d%b"
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'

# Enable the menu for easier navigation
zstyle ':completion:*' menu select=6 _complete _ignored _approximate # select=4 indicates that the menu should be shown when at least 4 choices exist
zstyle ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX+$#SUFFIX)/2 )) numeric )'

# Group the results of the menu
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*' group-name ''

# Provide more processes in completion of programs like killall:
zstyle ':completion:*:processes-names' command 'ps c -u ${USER} -o command | uniq'

# App specific completions
zstyle ':completion:*:kill:*'   force-list always
zstyle ':completion:*:killall:*'   force-list always

# SSH Completion
zstyle ':completion:*:scp:*' tag-order \
   files users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:scp:*' group-order \
   files all-files users hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order \
   users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:ssh:*' group-order \
   hosts-domain hosts-host users hosts-ipaddr

# Add completion for "fork", lazily
compdef _sudo fork

# Change C-w to work on alphanumeric words
autoload -U select-word-style
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
select-word-style normal

###########################################
# Prompt style
###########################################
autoload -U promptinit
promptinit
autoload -U colors zsh/terminfo
colors
# Expansion in prompt
setopt prompt_subst
refresh-prompt(){
	# Prepare the colors
	for color in RED GREEN; do
		eval PR_$color='%{$fg[${(L)color}]%}'
	done
	PR_NO_COLOR="%{$terminfo[sgr0]%}"

	# Check the UID, make it red if we're root
	if [[ $UID -ge 500 ]]; then # normal user
		eval PR_USER='%n'
		eval PR_USER_OP='%#'
	elif [[ $UID -eq 0 ]]; then # root
		eval PR_USER='${PR_RED}%n${PR_NO_COLOR}'
		eval PR_USER_OP='${PR_RED}%#${PR_NO_COLOR}'
	fi

	# Check if we're SSHed in. Show the host if we are
	if [[ -z "$SSH_CLIENT" && -z "$SSH2_CLIENT" ]]; then
	#	eval PR_HOST='%M' # no SSH
		eval PR_HOST='' # localhost, why show the host?
	else
		eval PR_HOST='@${PR_GREEN}%M${PR_NO_COLOR}' #SSH
	fi


	# set the prompt
	PS1=$'[${PR_USER}${PR_HOST}:%~]'
	PS2=$'%_ > '
}
refresh-prompt

###########################################
# Extended glob
###########################################
setopt extendedglob

###########################################
# Load the command-not-found if it exists
###########################################
if [ -x /etc/zsh_command_not_found ]; then
	. /etc/zsh_command_not_found
fi

###########################################
# Load local settings specific to each machine
###########################################
if [ -x ~/.zshrc_local ]; then
	. ~/.zshrc_local
else
	touch ~/.zshrc_local
	chmod 755 ~/.zshrc_local
fi

###########################################
# Set some defaults
###########################################
# Set the path
export PATH="$HOME/bin:${PATH}"

# Applications
export PAGER='less'
export EDITOR='vim'
export BROWSER='chromium-browser'

# Language
export LC_ALL='en_US.UTF-8'
export LANG='en_US.UTF-8'

###########################################
# Setup some event handlers
###########################################
typeset -ga preexec_functions
typeset -ga precmd_functions
typeset -ga chpwd_functions

###########################################
# Set the title
###########################################
refresh-title(){
	case $TERM in
		xterm*)
			print -Pn "\e]0;%n@%m: %~\a"
			;;
		screen)
			print -Pn "\e]83;title \"$1\"\a"
			if [[ "$1" == "" ]]; then
				print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~]\a"
			else
				print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~] ($1)\a"
			fi
		;;
	esac
}
# Only add the event handler if we haven't already sourced the config file
if [[ "$ZSH_FIRST_RUN" != "0" ]]; then
	preexec_functions+='refresh-title'
	precmd_functions+='refresh-title'
fi

###########################################
# Standard aliases
###########################################
sudo(){
	local -a cmd
	if [[ -n ${aliases[$1]} ]]; then
		cmd=( ${(z)${aliases[$1]}} )
		shift
		command sudo $cmd "$@"
	else
		cmd=( $1 )
		shift
		command sudo $cmd "$@"
	fi
}
alias s="sudo"
alias stealth-mode="HISTSIZE=; HISTFILE=;"
alias install="sudo apt-get install"
alias remove="sudo apt-get remove"
alias ls="ls -ABhp --color=always"
alias ls.real="/bin/ls"
alias files="ls -ABlhp --color=always"
alias f="files | less -r"
alias lsa="ls -a"
alias -g l="| less"
alias -g g="| grep"
alias -g p="| sed 's/\\\\/\\\\\\\\/g' | sed \"s/\\s/\\\\ /g\" | sed \"s/'/\\\\\\\\'/g\" | sed 's/\"/\\\\\\\"/g' | xargs -I\"{}\" "
alias -g t="| tail"
alias -g s="| sed"
alias -g a="| awk"
alias -g h="| head"
alias -g e="; exit"
alias gmp="gnome-mplayer"
alias vmplayer="mplayer -vo vdpau -vc ffh264vdpau"
alias hdvmplayer="mplayer -vo vdpau -vc ffh264vdpau -cache-min 75 -cache 65536"
alias id3="mid3v2"
alias grep="grep --color=auto"
alias gz="tar xvzf"
alias bz="tar xvjf"
alias scr="screen -URAad"
alias rtch="screen -rxU"
alias nano="nano -w"
alias source="source ~/.zshrc"
alias source.real="source"
alias rsync.exact="rsync -rtpogxv -P -l -H"
alias rsync.to-host="rsync -urltPv --delete --bwlimit=30"
alias rsync.loose="rsync -zvru -P"
alias fullupdate="cd $HOME; git pull; source ~/.zshrc; cd -"

mvln(){
	mv $1 $2
	ln -s $2 $1
}
mid(){
	if test $# -lt 2; then
		echo "$0: Insufficient arguments"
		echo "Usage: $0 <start> <number> <file>"
	else
		tail -n +$1 $3 | head -n $2
	fi
}
c(){
   if [ $# = 0 ]; then
      cd && files
   else
      cd "$*" && files
   fi
}
mc(){
	mkdir -p "$*" && cd "$*" && pwd
}
fork(){
	sh -c "$* &" &
	disown 2> /dev/null
}
archive-history(){
	if [ ! -e ~/.zsh_hist ]; then
		touch ~/.zsh_hist
	fi
	if [ ! -e ~/.zsh_hist.archive ]; then
		touch ~/.zsh_hist.archive
	fi

	# Get each command in order
	cat ~/.zsh_hist | sort | uniq > /tmp/.zsh_hist_left
	cat ~/.zsh_hist.archive | sort | uniq > /tmp/.zsh_hist_right

	diff --ignore-all-space --suppress-common-lines -N /tmp/.zsh_hist_left /tmp/.zsh_hist_right | # Diff the files
		uniq -u | # Don't duplicate
		grep "^<" | # Only get the new commnands
		sed "s/^< //" | # Remove space from the front
		grep -v "^$" >> ~/.zsh_hist.archive

	# Clean up
	rm /tmp/.zsh_hist_left
	rm /tmp/.zsh_hist_right
}
flac-to-mp3(){
	QUALITY="$1"
	TOTALTRACKS="`ls *flac | wc -l`"
	echo "Found $TOTALTRACKS files to convert"
	for f in *.flac; do
		OUT=$(echo "$f" | sed s/\.flac$/.mp3/g)
		ARTIST=$(metaflac "$f" --show-tag=ARTIST | sed "s/.*=//g")
		TITLE=$(metaflac "$f" --show-tag=TITLE | sed "s/.*=//g")
		ALBUM=$(metaflac "$f" --show-tag=ALBUM | sed "s/.*=//g")
		GENRE=$(metaflac "$f" --show-tag=GENRE | sed "s/.*=//g")
		TRACK=$(metaflac "$f" --show-tag=TRACKNUMBER | sed "s/.*=//g")
		DATE=$(metaflac "$f" --show-tag=DATE | sed "s/.*=//g")
		echo "Converting $f to $OUT"
		flac -c -d "$f" | lame -mj -q0 -s44.1 $QUALITY - "$OUT"
		echo "Tagging $OUT with id3v1 and then id3v2"
		id3 -t "$TITLE" -T "$TRACK" -A "$ALBUM" -y "$DATE" -g "$GENRE" "$OUT"
		id3v2 -t "$TITLE" -T "${TRACK:-0}" -a "$ARTIST" -A "$ALBUM" -y "$DATE" -g "${GENRE:-12}" "$OUT"
		echo "Updating the tags for $OUT with a more modern track and genre (id3v2.4)"
		mid3v2 -T "${TRACK:-0}/$TOTALTRACKS" -g "$GENRE" "$OUT" # Add the genre and track in a more modern fashion
	done
}
flac-to-v0(){
	flac-to-mp3 "-V0"
}
flac-to-v2(){
	flac-to-mp3 "-V2"
}

id3-read-tag(){
	# Given a filename, hash it and read the id3 tags from the hash table using the md5 hash of the file as key
	# If the file hasn't already been scanned, read it into the hash table
	HASHNAME=`echo $1 | md5sum | awk '{print $1}'`
	typeset -gA "ID3_FILE_DB"
	if [[ "$ID3_FILE_DB[$HASHNAME]" == "" ]]; then
		id3-read-file $HASHNAME "$1"
	fi
	case ${2:l} in
		tit2|title) field="TIT2";;
		tpe1|artist) field="TPE1";;
		talb|album) field="TALB";;
		trck|track) field="TRCK";;
		tyer|year) field="TYER";;
		tcon|genre) field="TCON";;
		*) field="";;
	esac
	echo $ID3_FILE_DB[$HASHNAME] | grep -a "^${field}" 2>/dev/null | sed "s/^${field}=//"
}
id3-read-file(){
	# Read the tags for a given file and store the results in a searchable array
	typeset -gA "ID3_FILE_DB"
	ID3_FILE_DB[$1]=`mid3v2 $2`
}
id3-rename-file(){
	# Given a filename, read all the relevant information from the hash table and rename it appropriately
	typeset -gA "ID3_FILE_DB"
	filename=$1
	basedir=`dirname $1`
	title=`id3-read-tag $filename title | sed "s/\//-/g"`
	album=`id3-read-tag $filename album`
	artist=`id3-read-tag $filename artist`
	track=`id3-read-tag $filename track | sed "s/\/.*//g"`
	track=`track-clean $track`
	year=`id3-read-tag $filename year`
	if [[ "$track" == "00" ]]; then
		newfilename="$basedir/$artist - $title.mp3"
	else
		newfilename="$basedir/$track.$title.mp3"
	fi
	if [[ "$filename" != "$newfilename" ]]; then
		echo "Moving \"$filename\" to \"$newfilename\""
		mv "$filename" "$newfilename"
	fi
}
id3-clean-tags(){
	filename=$1
	title=`id3-read-tag $filename title`
	title-clean $title | read newtitle
	artist=`id3-read-tag $filename artist`
	title-clean $artist | read newartist
	album=`id3-read-tag $filename album`
	title-clean $album | read newalbum
	echo "Title: $title => $newtitle"
	echo "Album: $album => $newalbum"
	echo "Artist: $artist => $newartist"
	mid3v2 -a "$newartist" -A "$newalbum" -t "$newtitle" --TPOS "1/1" "$filename"
}
id3-clean-dir(){
	if [[ "$1" == "" ]]; then
		dir=`pwd`
	else
		dir="$1"
		if [[ "$2" == "track" ]]; then
			albumtrack=1
		else
			albumtrack=0
		fi
	fi
	find $dir -type f -iname "*mp3" | wc -l | read ALBUMCOUNT
	find $dir -type f -iname "*mp3" | while read FILE; do
		echo "Found $FILE"
		id3-clean-file "$FILE" "$albumtrack" "$ALBUMCOUNT"
		echo "==============="
	done
	echo "Done!"
}
id3-clean-files(){
	for file in $*
		do id3-clean-file $file
	done
}
id3-clean-file(){
	FILE="$1"
	ALBUMTRACK="$2"
	ALBUMCOUNT="$3"
	id3-clean-tags "$FILE"
	if [[ "$ALBUMTRACK" == "1" ]]; then
		echo "Fixing track"
		id3-fix-track "$FILE" "$ALBUMCOUNT"
	fi
	id3-rename-file "$FILE"
}
id3-fix-track(){
	echo $1 | read FILE
	echo $2 | read ALBUMCOUNT
	track-clean $ALBUMCOUNT | read ALBUMCOUNT
	id3-read-tag $FILE track | read TRACK
	track-clean $TRACK | read NEWTRACK
	NEWTRACK="$NEWTRACK/$ALBUMCOUNT"
	mid3v2 -T "$NEWTRACK" "$FILE"
}
title-clean(){
	echo $1 | sed 's/\sof\s/ of /gi' | sed 's/(?![-\(\)&])\sthe\s/ the /gi' | sed 's/\sand\s/ and /gi' | sed 's/\sa\s/ a /gi'
}
track-clean(){
	printf '%02d' "`echo $1 | sed 's/\/.*$//g'`"
}
pslist(){
	case $1 in
		cpu | CPU | %cpu) sort="-%cpu";;
		mem | memory) sort="-rss";;
		pid | PID | process) sort="pid";;
		cmd | command | name) sort="cmd";;
		rcpu | RCPU | r%cpu) sort="%cpu";;
		rmem | rmemory) sort="rss";;
		rpid | RPID | rprocess) sort="-pid";;
		rcmd | rcommand | rname) sort="-cmd";;
		*) sort="-%cpu";;
	esac

	ps -e hx -o pid,%cpu,rss,cmd --sort=$sort | awk '{text = ""; for(i=4; i <= NF; i++){ text = text OFS $i }; printf "%5.0f\t%2.2f%s\t%4.2fM\t %s\n", $1, $2, "%", ($3 / 1024), text}'
}
profile(){
	ZSH_PROFILE_RC=1 zsh "$@"
}
profile-init(){
	zmodload zsh/zprof
}
extract(){
    emulate -L zsh
    if [[ -f $1 ]] ; then
        case $1 in
            *.tar.bz2)  bzip2 -v -d $1 $2   ;;
            *.tar.gz)   tar -xvzf $1 $2     ;;
            *.rar)      unrar x $1 $2       ;;
            *.deb)      ar -x $1 $2         ;;
            *.bz2)      bzip2 -d $1         ;;
            *.lzh)      lha x $1 $2         ;;
            *.gz)       gunzip -d $1 $2     ;;
            *.tar)      tar -xvf $1 $2      ;;
            *.tgz)      gunzip -d $1 $2     ;;
            *.tbz2)     tar -jxvf $1 $2     ;;
            *.zip)      unzip $1 $2         ;;
            *.Z)        uncompress $1 $2    ;;
            *)          echo "'$1' Error. Please go away" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# File extension aliases, for autolaunch based on the given path
alias -s php=vim
alias -s js=vim
alias -s sql=vim
alias -s com=$BROWSER
alias -s org=$BROWSER
alias -s net=$BROWSER
alias -s html=$BROWSER
alias -s htm=$BROWSER

# SSH aliases
alias home="ssh -XC dmsuperman@dmsuperman.com"
alias host="ssh -C -p 33445 dmsuperman@cjohnson.me"
alias host-attach-im="ssh -Cp 33445 dmsuperman@cjohnson.me -t \"screen -radA -p im\""
alias host-attach-irc="ssh -Cp 33445 dmsuperman@cjohnson.me -t \"screen -rx -p irc\""

# Edit aliases inline
edalias(){
    [[ -z "$1" ]] && { echo "Usage: edalias <alias_to_edit>" ; return 1 } || vared aliases'[$1]' ;
}
compdef _aliases edalias

# Provides useful information on globbing
help-zshglob() {
    echo -e "
    /      directories
    .      plain files
    @      symbolic links
    =      sockets
    p      named pipes (FIFOs)
    *      executable plain files (0100)
    %      device files (character or block special)
    %b     block special files
    %c     character special files
    r      owner-readable files (0400)
    w      owner-writable files (0200)
    x      owner-executable files (0100)
    A      group-readable files (0040)
    I      group-writable files (0020)
    E      group-executable files (0010)
    R      world-readable files (0004)
    W      world-writable files (0002)
    X      world-executable files (0001)
    s      setuid files (04000)
    S      setgid files (02000)
    t      files with the sticky bit (01000)

  print *(m-1)          # Files modified up to a day ago
  print *(a1)           # Files accessed a day ago
  print *(@)            # Just symlinks
  print *(Lk+50)        # Files bigger than 50 kilobytes
  print *(Lk-50)        # Files smaller than 50 kilobytes
  print **/*.c          # All *.c files recursively starting in \$PWD
  print **/*.c~file.c   # Same as above, but excluding 'file.c'
  print (foo|bar).*     # Files starting with 'foo' or 'bar'
  print *~*.*           # All Files that do not contain a dot
  chmod 644 *(.^x)      # make all plain non-executable files publically readable
  print -l *(.c|.h)     # Lists *.c and *.h
  print **/*(g:users:)  # Recursively match all files that are owned by group 'users'
  echo /proc/*/cwd(:h:t:s/self//) # Analogous to >ps ax | awk '{print $1}'<"
}

help-zshhistory(){
	echo -e "
  !!      Immediately preceeding line (all of it)
  !{!}    Same, but protected
  !       Line just referred to (default !!)
  !13     Line numbered 13
  !-2     Line two before current
  !cmd    Last command beginning with cmd
  !?str   Last command containing str
  !$      Current command line so far
  !#:2    Second argument of current command line so far
  !!:0    First word of the last line (the command)
  !!:1    Second word of the last line (first argument)
  !!:^    Second word of the last line (first argument)
  !!:$    Last word of last line (last argument)
  !!:2-4  Words 2 to 4 inclusive of last line
  !!:-4   Words 0 to 4 inclusive of last line
  !!:*    Words 1 to $ inclusive of last line
  !!:2*   Words 2 to $ inclusive of last line"
}

###########################################
# Various ZSH hooks
###########################################
zshexit(){
	# Tell it to archive my history
	archive-history
}

# {{{ Restore Ubuntu's command not found handler, it tends to tell me which package provides the command }}}
command_not_found_handler(){
	/usr/lib/command-not-found $1 2>&1 | head -n -0
}

###########################################
# ZSH / Git stuff
###########################################
if which git 2>&1 >/dev/null; then
	alias gc="git commit"
	alias ga="git add"
	alias gd="git diff"
	alias gck="git checkout"
	alias gb="git checkout -b"
	alias gp="git push"
	alias push="git push"
	alias pull="git pull"
	get-zsh-git-prompt(){
		# Make sure the prompt has been enabled for this session,
		# otherwise it'll probably consume tons of time for each command I execute
		if [[ "$GIT_PROMPT_ENABLE" != "" ]]; then
			# Get the status and parse it
			GIT_CURRENT_STATUS=`git status 2>/dev/null`
			if [[ "$GIT_CURRENT_STATUS" != "" ]]; then
				# Prepare the colors
				for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
					eval PR_$color='%{$fg[${(L)color}]%}'
				done
				PR_NO_COLOR="%{$terminfo[sgr0]%}"
				# Get the current branch
				echo $GIT_CURRENT_STATUS | head -1 | grep 'On branch' | sed 's/^# On branch //' | read GIT_BRANCH
				if [[ "$GIT_BRANCH" == "" ]]; then
					# No branch but we're in a git-tracked directory, so perhaps we're in a rebase
					DOT_GIT_DIR=`git rev-parse --git-dir`
					if [[ -d $DOT_GIT_DIR/rebase-merge ]]; then
						# Read the topic branch from the rebase file
						cat $DOT_GIT_DIR/rebase-merge/head-name | sed 's/refs\/heads\///' | read GIT_BRANCH
						GIT_BRANCH="${GIT_BRANCH} rebasing"
					fi
				fi
				if [[ "$GIT_BRANCH" != "" ]]; then
					# These statements are in a specific order. The color is overwritten if the next statement is true
					eval GIT_STATUS_COLOR='${PR_WHITE}'
					GIT_TRACK_STATUS=""
					GIT_PUSH_STATUS=""
					GIT_COMMIT_STATUS=""
					# See if they have changes not yet pushed (but committed)
					if GARBAGE=$(echo $GIT_CURRENT_STATUS | grep 'Your branch is ahead'); then
						eval GIT_STATUS_COLOR='${PR_RED}'
						GIT_PUSH_STATUS=" ↑"
					fi
					# See if they have changes not yet committed (but staged)
					if GARBAGE=$(echo $GIT_CURRENT_STATUS | grep 'Changes to be committed'); then
						eval GIT_STATUS_COLOR='${PR_GREEN}'
						GIT_COMMIT_STATUS=" →"
					fi
					# See if they have changes not yet staged
					git diff --quiet || eval GIT_STATUS_COLOR='${PR_CYAN}'
					# See if they have files not yet tracked
					echo $GIT_CURRENT_STATUS | grep 'Untracked files' 1>/dev/null && eval GIT_TRACK_STATUS="*"

					GIT_PROMPT=" [${GIT_STATUS_COLOR}${GIT_TRACK_STATUS}${GIT_BRANCH}${GIT_COMMIT_STATUS}${GIT_PUSH_STATUS}${PR_NO_COLOR}]"
					echo $GIT_PROMPT
				fi
			fi
		fi
	}
	RPS1='[%!]$(get-zsh-git-prompt)'
	git-scoreboard(){
		git log | grep '^Author' | sort | uniq -ci | sort -r
	}
	alias git-prompt-enable="export GIT_PROMPT_ENABLE=1"

	zsh-git-status(){
		# If the directory we just moved into is tracked by git, show the status to refresh my memory
		if [ -d .git ]; then
			git status
		fi
	}
	if [[ "$ZSH_FIRST_RUN" != "0" ]]; then
		chpwd_functions+='zsh-git-status'
	fi
fi

# Set it to 0, telling any one-time-per-session code not to run again
ZSH_FIRST_RUN="0"

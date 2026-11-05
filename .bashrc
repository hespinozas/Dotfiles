# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc
. "$HOME/.cargo/env"
export PATH="$PATH:/opt/mssql-tools18/bin"



# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

case ":$PATH:" in
    *:/home/hespinozas/.juliaup/bin:*)
        ;;

    *)
        export PATH=/home/hespinozas/.juliaup/bin${PATH:+:${PATH}}
        ;;
esac
# Tab completion for juliaup and julia channel selection
[ -f "/home/hespinozas/.julia/juliaup/completions/bash.sh" ] && source "/home/hespinozas/.julia/juliaup/completions/bash.sh"

# <<< juliaup initialize <<<

# Tmux aliases
alias tn='tmux new-session -s'
alias tl='tmux list-sessions'
alias ta='tmux attach-session'


# Python PYTHONPATH Environment Variable
export PYTHONPATH="/home/hespinozas/.local/lib/python3.14/site-packages:$PYTHONPATH"

bind 'set bell-style none'

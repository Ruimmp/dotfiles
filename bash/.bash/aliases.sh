alias reload='source ~/.bashrc'

alias lla='ls -la'
alias ll='ls -l'
alias la='ls -a'
alias rm='rm -rf'
alias mkdir='mkdir -p'

alias home="cd ~"
alias docs="cd ~/Documents"
alias dls="cd ~/Downloads"
alias desk="cd ~/Desktop"
alias projects="cd ~/Projects"
alias ..="cd .."

alias cls='clear'
alias ip='ipconfig'
alias ports='netstat -ano | findstr "LISTENING"'
alias hosts='nano C:/Windows/System32/drivers/etc/hosts'

alias ssh='ssh_connect'
alias ssh.config='nano ~/.ssh/config'
alias ssh.config.show='cat ~/.ssh/config'
alias ssh.config.code='code ~/.ssh/config'

alias docker.reset='docker nuke'
alias docker.nuke='docker nuke'
alias docker.redo='docker redo'

alias commit='git add . && git commit -m "update" && git push'

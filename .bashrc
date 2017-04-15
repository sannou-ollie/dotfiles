# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

alias gs="git status -s"
alias gc="git commit"
alias gd="git diff"
alias gp="git pull"
alias gr="git reset HEAD"
alias fing="find -type f | xargs grep "
alias ga="git add"
alias ctg="ctags -R -f ~/.vt_locations /var/www/app/v1/"
alias fingrep="find -type f | xargs grep "
alias todaylog="cat /tmp/application.log.`date +%Y%m%d`"

function a2() {
    awk '{print $2}'
}

function gsm() {
    gs | grep "^ M"
}

function toUtf8() {
     iconv -t UTF-8 $1 -o $1
}


function toUnix() {
     sed -i -e "s/\r//g" $1
}

function cutWhiteSpace() {
     sed -i 's/[ ]*$//g' $1
}

function pp() {
    toUnix $1
    toUtf8 $1
    cutWhiteSpace $1
}

function phpUnSerialize() {
    php -r "var_dump(unserialize(trim(fgets(STDIN))));"
}


# User specific aliases and functions

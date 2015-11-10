# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

# GIT/SVN stuff
parse_svn_url() {
    svn info 2>/dev/null | sed -ne 's#^URL: ##p'
}
parse_svn_repository_root() {
    svn info 2>/dev/null | sed -ne 's#^Repository Root: ##p'
}
parse_git_branch ()
{
    git branch 2>/dev/null | grep "^*" | sed 's#* \(.*\)#[git:\1]#'
}
parse_svn_branch() {
    parse_svn_url | sed -e 's#^'"$(parse_svn_repository_root)"'##g' | awk -F / '{print "(svn:"$1 "/" $2 ")"}'
}

export PS1="\[\033[01;34m\]${debian_chroot:+($debian_chroot)}\u:\w \[\033[31m\]\$(parse_git_branch)\$(parse_svn_branch)\[\033[00m\]$\[\033[00m\] "

# JHBUILD stuff
parse_jhbuild ()
{
    env | grep "/home/mario/work/gnome/inst" > /dev/null && echo "jhbuild" || echo "\u"
}
export PS1="\[\033[01;34m\]${debian_chroot:+($debian_chroot)}$(parse_jhbuild):\w \[\033[31m\]\$(parse_git_branch)\$(parse_svn_branch)\[\033[00m\]$\[\033[00m\] "


# ENVIRONMENT VARIABLES

export EMAIL=mario@mariospr.org
export LANG=en_US.UTF-8

# ECLIPSE
export PATH=$PATH:/opt/eclipse

# DEBIAN
export DEBEMAIL="mario@endlessm.com"
export DEBFULLNAME="Mario Sanchez Prada"

# QUILT
alias dquilt="quilt --quiltrc=${HOME}/.quiltrc-dpkg"
complete -F _quilt_completion $_quilt_complete_opt dquilt

# WEBKIT
export SVN_LOG_EDITOR=/bin/nano
export EDITOR=/bin/nano
export PATH=${PATH}:$HOME/work/WebKit/Tools/Scripts
export EMAIL_ADDRESS=mario@endlessm.com

COREDUMPS_DIR=/tmp/coredumps
mkdir -p ${COREDUMPS_DIR}
export WEBKIT_CORE_DUMPS_DIRECTORY=${COREDUMPS_DIR}
ulimit -c unlimited

# ANDROID
export PATH=${PATH}:/opt/android-sdk-linux_x86/tools:/opt/android-sdk-linux_x86/platform-tools
export JAVA_HOME="/usr/java/latest"

# ARDUINO
export ARDUINODIR=/usr/share/arduino
export BOARD=uno
export SERIALDEV=/dev/ttyACM0

# GSTREAMER
export GST_UNINSTALLED_ROOT=$HOME/work/gstreamer/head

# ALIASES
alias psc='ps xawf -eo pid,user,cgroup,args'
alias ls='ls --color'
alias enox='emacs-nox'




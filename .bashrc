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

# Make sure DISPLAY is always exported (useful for chroots)
export DISPLAY=:0.0

# ENDLESS

if [ -d /var/endless ]; then
    # Add ccache inside Endless's chroot
    export PATH=/usr/lib/ccache:$PATH
    export CCACHE_DIR=$HOME/work/endless/ccache-chroot/$(arch)
    mkdir -p $CCACHE_DIR

    # Chromium sandbox
    export CHROME_DEVEL_SANDBOX=/usr/local/bin/chrome-devel-sandbox
else
    # CHROMIUM
    export PATH=$HOME/work/chromium/depot_tools:$PATH
    export GYP_DEFINES="$GYP_DEFINES component=shared_library"
    export CHROME_DEVEL_SANDBOX=$HOME/work/chromium/chrome_sandbox

    if [ -e /trusty-amd64 ]; then
        # Trusty 64 bit chroot
        export PATH=/usr/lib/ccache:$PATH
        export CCACHE_DIR=$HOME/work/endless/ccache-chroot/trusty-amd64

	# Icecc does not seem to work well at all while in the chroot
        #export CCACHE_PREFIX=icecc
    elif [ -e /wily-amd64 ]; then
        # Wily 64 bit chroot
        export PATH=/usr/lib/ccache:$PATH
        export CCACHE_DIR=$HOME/work/endless/ccache-chroot/wily-amd64

	# Icecc does not seem to work well at all while in the chroot
        #export CCACHE_PREFIX=icecc
    else
        # Icecc Integration outside any chroot (not using clang)
        export GYP_DEFINES="$GYP_DEFINES clang=0 linux_use_debug_fission=0 linux_use_bundled_binutils=0"
    fi

    # ccache defines needed for chromium
    export CCACHE_CPP2=yes
    export CCACHE_SLOPPINESS=time_macros

    # Icecc + clang (does not work, but it should)
    # http://mkollaro.github.io/2015/05/08/compiling-chromium-with-clang-and-icecc/
    #export PATH=$PATH:$HOME/work/chromium/src/third_party/llvm-build/Release+Asserts/bin
    #export GYP_DEFINES="$GYP_DEFINES clang=1 make_clang_dir=/usr/lib64/ccache/clang clang_use_chrome_plugins=0 linux_use_debug_fission=0 linux_use_bundled_binutils=0"
    #export ICECC_VERSION=$HOME/work/chromium/clang.tar.gz
    #export ICECC_CLANG_REMOTE_CPP=1
fi

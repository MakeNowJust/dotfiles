setopt no_global_rcs

path=(
  /usr/local/opt/coreutils/libexec/gnubin(N-)
  /usr/local/opt/gnu-sed/libexec/gnubin(N-)
  ~/perl5/bin(N-)
  ~/.local/bin(N-)
  ~/.cargo/bin(N-)
  /usr/local/bin(N-) /usr/local/sbin(N-)
  /usr/local/opt/llvm/bin(N-)
  /Library/TeX/texbin(N-)
  ~/.anyenv/bin(N-)
  $path
)

export MANPAGE="/usr/local/opt/coreutils/libexec/gnuman:$MANPAGE"

which anyenv 2>&1 >/dev/null && eval "$(anyenv init -)"

export MONO_GAC_PREFIX="/usr/local"

export GTK_PATH=/usr/local/lib/gtk-2.0

export GOPATH=$HOME/.go
path=($GOPATH/bin $path)

export PERL5LIB=$HOME/perl5/lib/perl5

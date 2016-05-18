export GOROOT=/usr/local/go
export GOPATH=$HOME/gowork:$HOME/go:$GOROOT
export PATH=$HOME/gowork/bin:$HOME/go/bin:$GOROOT/bin:/usr/local/bin:$PATH
export CGO_CFLAGS="-I `mecab-config --inc-dir`"
export CGO_LDFLAGS="`mecab-config --libs`"

GIT_PROMPT_END='\n\[\033[0;37m\]$(date +%H:%M) \h\[\033[0;0m\] $ '
PROMPT_END='\n\[\033[0;37m\]$(date +%H:%M) \h\[\033[0;0m\] $ '
GIT_PROMPT_SHOW_UPSTREAM=1
. $HOME/.bash-git-prompt/gitprompt.sh
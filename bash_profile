nv=$(which nvim)

if [ -x $HOME/go/bin/go ]; then
    GOROOT=$HOME/go
elif [ -x /usr/local/go/bin/go ]; then
    GOROOT=/usr/local/go
else
    echo "Install Go!"
fi

if [ ${BASH_VERSINFO[0]} -ge 4 ]; then
    shopt -s globstar
    shopt -s dirspell
    shopt -s cdspell
    shopt -s histappend
fi

export GOROOT
export GOPATH=$HOME/gowork
export PATH=$HOME/bin:$GOPATH/bin:$GOROOT/bin:/usr/local/bin:/usr/local/opt/gnupg/libexec/gpgbin:$PATH
export EDITOR=$nv
export CGO_CFLAGS="-I $(mecab-config --inc-dir)"
export CGO_LDFLAGS="$(mecab-config --libs)"

alias vi=$nv
alias vim=$nv
alias gowin="GOOS=windows GOARCH=amd64 go"
alias golnx="GOOS=linux GOARCH=amd64 go"

# build go static binary from root of project
gostatic(){
    local dir=$1
    local arg=$2

    if [[ -z $dir ]]; then
        dir=$(pwd)
    fi

    local name=$(basename "$dir")
    (
    cd $dir
    #export GOOS=linux
    export GOOS=darwin
    echo "Building static binary for $name in $dir"

    case $arg in
        "netgo")
            set -x
            go build -a \
                -tags 'netgo static_build' \
                -installsuffix netgo \
                -ldflags "-w" \
                -o "$name" .
            ;;
        "cgo")
            set -x
            CGO_ENABLED=1 go build -a \
                -tags 'cgo static_build' \
                -ldflags "-w -extldflags -static" \
                -o "$name" .
            ;;
        *)
            set -x
            CGO_ENABLED=0 go build -a \
                -installsuffix cgo \
                -ldflags "-w" \
                -o "$name" .
            ;;
    esac
    )
}

# go to a folder easily in your gopath
gogo(){
    local d=$1

    if [[ -z $d ]]; then
        echo "You need to specify a project name."
        return 1
    fi

    if [[ "$d" == github* ]]; then
        d=$(echo $d | sed 's/.*\///')
    fi
    d=${d%/}

    # search for the project dir in the GOPATH
    local path=( `find "${GOPATH}/src" \( -type d -o -type l \) -iname "$d"  | awk '{print length, $0;}' | sort -n | awk '{print $2}'` )

    if [ "$path" == "" ] || [ "${path[*]}" == "" ]; then
        echo "Could not find a directory named $d in $GOPATH"
        echo "Maybe you need to 'go get' it ;)"
        return 1
    fi

    # enter the first path found
    cd "${path[0]}"
}

golistdeps(){
    (
    if [[ ! -z "$1" ]]; then
        gogo $@
    fi

    go list -e -f '{{join .Deps "\n"}}' ./... | xargs go list -e -f '{{if not .Standard}}{{.ImportPath}}{{end}}'
    )
}

GIT_PROMPT_END='\n\[\033[0;37m\]$(date +%H:%M) \h\[\033[0;0m\] $ '
PROMPT_END='\n\[\033[0;37m\]$(date +%H:%M) \h\[\033[0;0m\] $ '
GIT_PROMPT_SHOW_UPSTREAM=1
. $HOME/.bash-git-prompt/gitprompt.sh
eval "$(rbenv init -)"

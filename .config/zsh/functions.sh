alias quack="python3 -m http.server 8123 --directory \"$HOME/Desktop/hacking/webdev/quack/\" >/dev/null 2>&1 &"

vault_add() {
  local name="$1"
  [ -z "$name" ] && echo "Usage: vault_add <name>" && return 1

  tmpfile=$(mktemp)
  ${EDITOR:-nano} "$tmpfile"   # Type your secret, save, exit

  openssl enc -aes-256-cbc -salt -pbkdf2 \
    -in "$tmpfile" \
    -out "$HOME/.vault/$name.enc"

  shred -u "$tmpfile" 2>/dev/null || rm -P "$tmpfile" 2>/dev/null || rm "$tmpfile"
  echo "Stored secret as $name"
}


vault_get() {
  local name="$1"
  [ -z "$name" ] && echo "Usage: vault_get <name>" && return 1

  local file="$HOME/.vault/$name.enc"
  if [ ! -f "$file" ]; then
    echo "No such secret: $name"
    return 1
  fi

  # Capture stdout only if openssl exits successfully
  local plaintext
  if plaintext=$(openssl enc -d -aes-256-cbc -salt -pbkdf2 \
                    -in "$file" 2>/dev/null); then
    printf '%s' "$plaintext" | pbcopy
    echo "Secret '$name' copied to clipboard."
  else
    echo "Decryption failed (wrong password?)."
    return 1
  fi
}

vault() {
	if [ $1 == "add" ]; then
		shift
		vault_add $@
		return
	fi

	if [ $1 == "get" ]; then
		shift
		vault_get $@
		return
	fi

	echo "usage: vault [add/get] [file_id]"
}

# Ensure vault dir exists
_vault_dir() {
  mkdir -p "$HOME/.vault"
  chmod 700 "$HOME/.vault"
}

# vault_add <name>
# Reads *raw clipboard bytes* and stores encrypted at ~/.vault/<name>.enc
vault_add() {
  local name="$1"
  [ -z "$name" ] && echo "Usage: vault_add <name>" && return 1

  _vault_dir

  local outfile="$HOME/.vault/$name.enc"

  # Encrypt clipboard bytes -> encrypted file
  # - pbpaste writes clipboard contents to stdout
  # - openssl reads from stdin (-in /dev/stdin) and writes to outfile
  if pbpaste | openssl enc -aes-256-cbc -salt -pbkdf2 -in /dev/stdin -out "$outfile"; then
    chmod 600 "$outfile"
    echo "Stored clipboard as secret '$name' -> $outfile"
  else
    echo "Encryption failed."
    rm -f "$outfile"
    return 1
  fi
}

# vault_get <name>
# Decrypts ~/.vault/<name>.enc and puts *raw bytes* onto clipboard
vault_get() {
  local name="$1"
  [ -z "$name" ] && echo "Usage: vault_get <name>" && return 1

  local file="$HOME/.vault/$name.enc"
  if [ ! -f "$file" ]; then
    echo "No such secret: $name"
    return 1
  fi

  # Decrypt -> pbcopy (binary-safe). Don't capture into variables.
  if openssl enc -d -aes-256-cbc -salt -pbkdf2 -in "$file" 2>/dev/null | pbcopy; then
    echo "Secret '$name' copied to clipboard."
  else
    echo "Decryption failed (wrong password?)."
    return 1
  fi
}

rcc(){
	gcc $@
	./a.out

}

fcd() {
	a=$(fzf)
	cd $a
}

shcolor() {
	local color=$1
	case $color in
		black) echo ${BLACK};;
		red) echo ${RED};;
		green) echo ${GREEN};;
		yellow) echo ${YELLOW};;
		blue) echo ${BLUE};;
		purple) echo ${PURPLE};;
		cyan) echo ${CYAN};;
		white) echo ${WHITE};;
		reset) echo ${NC};;
	esac
}

sysedit(){
	p=$(pwd)
	cd
	vi .bashrc
	cd $p
}

wdhelper(){
	bash /Users/aiden/desktop/hacking/ShellScripts/wdhelper.sh $@
}


cargo-exe(){
	./target/debug/$1
}

. "$HOME/.cargo/env"

rms() {
	mv $1 $HOME/.trashfiles
}

trash() {
	TRASH_DIR=~/.trashfiles
	mkdir -p "$TRASH_DIR"
	for file in "$@"; do
		if [ -e "$file" ]; then
			mv "$file" "$TRASH_DIR/$(basename "$file").$(date +%s)"
			echo "Moved $file to trash."
		else
			echo "$RED$file not found.$NC"
		fi
	done
}

alias rm="trash"

v() {
  if ! fc -s vi 2>/dev/null; then
    fc -s vi  2>/dev/null || {
      printf 'v: no previous vi/vim command found in history\n' >&2
      return 1
    }
  fi
}

c() {
  if ! fc -s clang 2>/dev/null; then
    fc -s clang  2>/dev/null || {
      printf 've no previous clang command found in history\n' >&2
      return 1
    }
  fi
}

draul() {
	c=$(pwd)
	cd /Users/aiden/desktop/hacking/draul
	flask run
	cd $c
}

draul-clean() {
	rm /Users/aiden/desktop/hacking/draul/static/downloads/*
}


hx() {
	emulate -L zsh -o extendedglob
  local after_dd=0 arg f

  for arg in "$@"; do
    if (( ! after_dd )); then
      [[ $arg == -- ]] && { after_dd=1; continue; }
      [[ $arg == -* ]] && continue
    fi

    # strip trailing :line[:col] suffixes
    f="$arg"
    while [[ $f == *:[0-9]## ]]; do f="${f%:[0-9]##}"; done

    [[ -f $f ]] || continue

		tstamp=$(date +"%Y%m%d-%H%M%S")
		backup="$HOME/.vim/backups/$(basename $f).$tstamp.hx.bak"

		touch $backup
		cat $f > $backup
  done

	command hx $@

}

javal() {
	if [[ -f "$1.java" ]]; then
		echo "javal: error: existent file"
		return 1
	fi

	if [[ $2 == 's' ]]; then
		echo "import java.util.Scanner;" >> "$1.java"
	fi

	echo "public class $1 {\n\tpublic static void main(String[] args){\n" >> "$1.java"

	if [[ $2 == 's' ]]; then
		echo "\t\tScanner input = new Scanner(System.in);\n" >> "$1.java"
	fi

	echo "\t}\n}\n" >> "$1.java"
}
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export HOMEBREW_NO_AUTO_UPDATE=1
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"


slinter() {
	echo "[build]\ntarget-dir = /Users/aiden/.cargo/slint-target"
}

cargoconf() {
	echo "$(dirname $(cargo locate-project --message-format plain))/.cargo/config.toml"
}

gitfile() {
	curl "https://raw.githubusercontent.com/$1/$2/main/$3"
}
bakstats(){
    echo "vim $(du -sh ~/.vim/backups)\nemacs $(du -sh ~/.emacs_backups)\ntrashfiles $(du -sh ~/.trashfiles)"
}


zsh-alias() {
	echo $@ >> ~/.confg/zsh/aliases.sh
}

ed() {
	emulate -L zsh -o extendedglob
  local after_dd=0 arg f

  for arg in "$@"; do
    if (( ! after_dd )); then
      [[ $arg == -- ]] && { after_dd=1; continue; }
      [[ $arg == -* ]] && continue
    fi

    # strip trailing :line[:col] suffixes
    f="$arg"
    while [[ $f == *:[0-9]## ]]; do f="${f%:[0-9]##}"; done

    [[ -f $f ]] || continue

		tstamp=$(date +"%Y%m%d-%H%M%S")
		backup="$HOME/.vim/backups/$(basename $f).$tstamp.ed.bak"

		touch $backup
		cat $f > $backup
  done

	command ed $@

}

# lazy-load thefuck on first use
fuck() {
	unfunction fuck
	eval "$(thefuck --alias fuck)"
	eval "fuck ${(@q)@}"
}


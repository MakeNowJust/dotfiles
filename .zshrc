# setopt {{{1

# Changing directories
setopt no_auto_cd auto_pushd no_cdable_vars \
       chase_dots no_chase_links no_posix_cd \
       pushd_ignore_dups no_pushd_minus no_pushd_silent \
       pushd_to_home
# Completion
setopt always_last_prompt always_to_end auto_list \
       auto_menu auto_name_dirs auto_param_keys \
       auto_param_slash auto_remove_slash no_bash_auto_list \
       no_complete_aliases complete_in_word glob_complete \
       hash_list_all no_list_ambiguous no_list_beep \
       list_packed list_rows_first list_types \
       menu_complete rec_exact
# Expansion and Globbing
setopt bad_pattern bare_glob_qual brace_ccl \
       no_case_glob no_case_match no_csh_null_glob \
       equals extended_glob no_force_float \
       glob no_glob_assign no_glob_dots \
       glob_subst hist_subst_pattern no_ignore_braces \
       no_ignore_close_braces no_ksh_glob magic_equal_subst \
       mark_dirs multibyte nomatch \
       no_null_glob numeric_glob_sort no_sh_glob \
       unset no_warn_create_global
# History
setopt append_history bang_hist extended_history \
       hist_allow_clobber no_hist_beep hist_expire_dups_first \
       hist_fcntl_lock hist_find_no_dups hist_ignore_all_dups \
       hist_ignore_dups hist_ignore_space hist_lex_words \
       no_hist_no_functions no_hist_no_store hist_reduce_blanks \
       hist_save_by_copy hist_save_no_dups hist_verify \
       inc_append_history inc_append_history_time share_history
# Initialisation
setopt no_all_export no_global_export global_rcs \
       rcs
# Input/Output
setopt aliases clobber correct \
       correct_all no_dvorak no_flow_control \
       ignore_eof interactive_comments hash_cmds \
       hash_dirs hash_executables_only no_mail_warning \
       path_dirs no_path_script print_eight_bit \
       no_print_exit_value no_rc_quotes no_rm_star_silent \
       rm_star_wait short_loops no_sun_keyboard_hack
# Job Control
setopt no_auto_continue no_auto_resume bg_nice \
       check_jobs hup long_list_jobs \
       monitor notify no_posix_jobs
# Prompting
setopt prompt_bang prompt_cr prompt_sp \
       prompt_percent prompt_subst transient_rprompt
# Scripts and Functions 
setopt c_bases c_precedences debug_before_cmd \
       no_err_exit no_err_return eval_lineno \
       exec function_argzero local_loops \
       local_options local_patterns local_traps \
       multi_func_def multios no_octal_zeroes \
       pipe_fail no_source_trace no_typeset_silent \
       no_verbose no_xtrace

# alias and utility functions {{{1
function take() {
  local target="$1"

  if [[ -e "$target" ]]; then
    echo "already existed: $target"
    cd "$target" && echo "Moved to: $target" && return
  fi

  mkdir -p "$target" && cd "$target" && echo "Craeted and moved to: $target"
}

function has() {
  which $1 &>/dev/null
}

alias ..='popd'

if has exa; then
  alias ls='exa --group-directories-first -F'
  alias ll='ls -l --git'
  alias lt='ls --tree'
else
  alias ls='ls --color=auto -Fh --group-directories-first'
  alias ll='ls -l'
fi
alias la='ls -a'
alias lla='ls -la'

# open multiple files on tabs
alias vim='vim -p'

# create a new file with executable flag, then open this
vimx() {
  local file="$1"
  touch "$file" && chmod +x "$file" && vim "$file"
}

alias cls='clear'

alias mv='nocorrect mv'
alias cp='nocorrect cp'
alias mkdir='nocorrect mkdir -p'

alias ch='cp -t .'
alias mh='mv -t .'

if has hub; then
  alias git='hub'

  alias gcr='git create'
  alias gfk='git fork'
fi

alias gad='git add'
alias gadp='git add -p'
alias gbr='git branch -v'
alias gcl='git clone --recursive'
alias gcm='git commit -v'
alias gcml='git commit --allow-empty --cleanup=whitespace --no-status'
alias gcmm='git commit -m'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcobf='git checkout -B'
alias gdf='git diff HEAD'
alias gdfm='git diff master..HEAD'
alias gdfs='gdf --staged'
alias gft='git fetch'
alias glg='git log --oneline --graph'
alias gls='git ls-files'
alias gpl='git pull'
alias gps='git push'
alias gst='git status --short --branch'
alias gsh='git show'

# variables {{{1

# zsh-completions
fpath=(/usr/local/share/zsh-completions(N-) $fpath)

DIRSTACKSIZE=100

has dircolors && eval "$(dircolors)"

# auto correction
CORRECT_IGNORE='_*'
CORRECT_IGNORE_FILE='.*'

# prompt {{{1

PROMPT=$'%(?.%F{green}.%F{red})\u2118%f '
RPROMPT=$'%B%F{blue}%~%f%b'

# autoload {{{1
autoload -Uz compinit; compinit

# zstyle {{{1
zstyle ':completion:*' completer _complete _expand _match _prefix _approximate _list _history
zstyle ':completion:*' list-separator "-->"
zstyle ':completion:*' rehash true
zstyle ':completion:*' use-cache true
zstyle ':completion:*' verbose yes
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
zstyle ':completion:*:corrections' format "%F{yellow}%U%d %F{red}(errors: %e)%u%f"
zstyle ':completion:*:default' menu select
zstyle ':completion:*:descriptions' format "%F{yellow}completing %U%d%u%f"
zstyle ':completion:*:messages' format "%F{yellow}%d%f"
zstyle ':completion:*:options' description yes
zstyle ':completion:*:warnings' format "%F{red}no matches for:%F{yellow} %d%f"
zstyle ':completion:*' group-name ''
[[ -n $LS_COLORS ]] && zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

zstyle -e ':completion:*' file-patterns "$(cat <<"EOF"
  if [[ ${PREFIX##*/} = .* ]]; then
    reply=('{.,..,.*}(-/):hidden-directories:hidden\ directories' '.*(^-/):hidden-files:hidden\ files')
  else
    reply=('^(.*)(-/):normal-directories:directories' '^(.*)(^-/):normal-files:files')
  fi
EOF
)"

# tiny patch for _files
autoload +XUz _files
eval function "$(functions _files | sed 's/(( ret )) || return 0/# &/')"

# key binding {{{1

bindkey -v

# hook {{{1

function preexec-send-history() {
  echo -En "$1" | curl -XPUT :4219/histories --data-binary @- &>/dev/null || true
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec preexec-send-history

has direnv && eval "$(direnv hook $SHELL)"

# extra {{{1

# added by travis gem
[ -f "$HOME/.travis/travis.sh" ] && source "$HOME/.travis/travis.sh"

cls

# vim:set foldenable foldmethod=marker:

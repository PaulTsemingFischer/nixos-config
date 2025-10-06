# ===== Zsh Powerline Prompt =====
# Colors and styles (Zsh-safe escapes)

BG_GREEN="%{\e[48;5;151m%}"     # pastel green background
FG_GREEN="%{\e[38;5;151m%}"
BG_BLUE="%{\e[48;5;74m%}"
FG_BLUE="%{\e[38;5;74m%}"
BG_DARK_BLUE="%{\e[48;5;67m%}"
FG_DARK_BLUE="%{\e[38;5;67m%}"
BG_CYAN="%{\e[48;5;116m%}"
FG_CYAN="%{\e[38;5;116m%}"
BG_RED="%{\e[48;5;181m%}"
FG_RED="%{\e[38;5;181m%}"
BG_BLACK="%{\e[48;5;0m%}"
FG_BLACK="%{\e[38;5;0m%}"
FG_WHITE="%{\e[38;5;255m%}"
BG_WHITE="%{\e[48;5;255m%}"
BOLD="%{\e[1m%}"
ITALIC="%{\e[3m%}"
BOLD_ITALIC="%{\e[1;3m%}"
RESET="%{\e[0m%}"

RIGHT_ARROW=$'\ue0b0'           # 
GIT_LOGO=$'\ue725'              # 
WHITE_SEPARATOR=$'\ue0b1'       # 

# --- Git branch detection ---
git_branch() {
  if command git rev-parse --is-inside-work-tree &>/dev/null; then
    git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD
  fi
}

# --- Path formatting with color blocks ---
format_path() {
  local pwd_path=$(pwd | sed "s|^$HOME|~|")
  local path_display=""
  local has_subdirs=false
  local is_special_dir=false

  if [[ $pwd_path == "/mnt/c/Users/Skylar"* ]]; then
    is_special_dir=true
    if [[ $pwd_path == "/mnt/c/Users/Skylar/Downloads/Code"* ]]; then
      if [[ $pwd_path == "/mnt/c/Users/Skylar/Downloads/Code" ]]; then
        path_display="${BG_DARK_BLUE}${FG_WHITE}${BOLD_ITALIC} code ${RESET}"
        has_subdirs=false
      else
        local subdir=${pwd_path#/mnt/c/Users/Skylar/Downloads/Code}
        path_display="${BG_DARK_BLUE}${FG_WHITE}${BOLD_ITALIC} code ${RESET}"
        has_subdirs=true
        local IFS='/'
        for dir in $subdir; do
          [[ -z $dir ]] && continue
          if [[ -z $first ]]; then
            path_display+="${FG_DARK_BLUE}${BG_BLUE}${RIGHT_ARROW}${RESET}${BG_BLUE}${FG_WHITE} $dir"
            first=1
          else
            path_display+=" ${FG_WHITE}${WHITE_SEPARATOR}${RESET}${BG_BLUE} $dir"
          fi
        done
      fi
    else
      if [[ $pwd_path == "/mnt/c/Users/Skylar" ]]; then
        path_display="${BG_DARK_BLUE}${FG_WHITE}${BOLD_ITALIC} winhome ${RESET}"
      else
        local subdir=${pwd_path#/mnt/c/Users/Skylar}
        path_display="${BG_DARK_BLUE}${FG_WHITE}${BOLD_ITALIC} winhome ${RESET}"
        has_subdirs=true
        local IFS='/'
        for dir in $subdir; do
          [[ -z $dir ]] && continue
          if [[ -z $first ]]; then
            path_display+="${FG_DARK_BLUE}${BG_BLUE}${RIGHT_ARROW}${RESET}${BG_BLUE}${FG_WHITE} $dir"
            first=1
          else
            path_display+=" ${FG_WHITE}${WHITE_SEPARATOR}${RESET}${BG_BLUE} $dir"
          fi
        done
      fi
    fi
  elif [[ $pwd_path == "~"* ]]; then
    is_special_dir=true
    if [[ $pwd_path == "~" ]]; then
      path_display="${BG_DARK_BLUE}${FG_WHITE}${BOLD_ITALIC} ~ ${RESET}"
    else
      local subdir=${pwd_path#\~}
      path_display="${BG_DARK_BLUE}${FG_WHITE}${BOLD_ITALIC} ~ ${RESET}"
      has_subdirs=true
      local IFS='/'
      for dir in $subdir; do
        [[ -z $dir ]] && continue
        if [[ -z $first ]]; then
          path_display+="${FG_DARK_BLUE}${BG_BLUE}${RIGHT_ARROW}${RESET}${BG_BLUE}${FG_WHITE} $dir"
          first=1
        else
          path_display+=" ${FG_WHITE}${WHITE_SEPARATOR}${RESET}${BG_BLUE} $dir"
        fi
      done
    fi
  else
    local IFS='/'
    for dir in $pwd_path; do
      [[ -z $dir ]] && continue
      if [[ -z $first ]]; then
        path_display+="${BG_BLUE}${FG_WHITE} $dir"
        first=1
      else
        path_display+=" ${FG_WHITE}${WHITE_SEPARATOR}${RESET}${BG_BLUE} $dir"
      fi
      has_subdirs=true
    done
    [[ "$pwd_path" == "/" ]] && path_display="${BG_BLUE}${FG_WHITE} /"
  fi

  echo "$path_display"
  echo "$has_subdirs"
  echo "$is_special_dir"
}

# --- Prompt segments ---
segment_user() {
  local path_info=($(format_path))
  local is_special_dir=${path_info[-1]}
  if [[ $is_special_dir == "true" ]]; then
    echo "${BG_GREEN}${FG_BLACK}${BOLD} %n ${RESET}${FG_GREEN}${BG_DARK_BLUE}${RIGHT_ARROW}${RESET}"
  else
    echo "${BG_GREEN}${FG_BLACK}${BOLD} %n ${RESET}${FG_GREEN}${BG_BLUE}${RIGHT_ARROW}${RESET}"
  fi
}

segment_path_and_git() {
  local path_info
  path_info=($(format_path))
  local path_content=$(format_path | head -n1)
  local has_subdirs=$(format_path | sed -n '2p')
  local is_special_dir=$(format_path | tail -n1)
  local branch=$(git_branch)

  echo -n "$path_content"

  if [[ $has_subdirs == "true" ]]; then
    if [[ -n $branch ]]; then
      echo -n " ${RESET}${FG_BLUE}${BG_CYAN}${RIGHT_ARROW}${RESET}${BG_CYAN}${FG_BLACK}${BOLD} ${GIT_LOGO} $branch ${RESET}${FG_CYAN}${BG_RED}${RIGHT_ARROW}${RESET}"
    else
      echo -n " ${RESET}${FG_BLUE}${BG_RED}${RIGHT_ARROW}${RESET}"
    fi
  else
    if [[ -n $branch ]]; then
      if [[ $is_special_dir == "true" ]]; then
        echo -n "${FG_DARK_BLUE}${BG_CYAN}${RIGHT_ARROW}${RESET}${BG_CYAN}${FG_BLACK}${BOLD} ${GIT_LOGO} $branch ${RESET}${FG_CYAN}${BG_RED}${RIGHT_ARROW}${RESET}"
      else
        echo -n "${FG_BLUE}${BG_CYAN}${RIGHT_ARROW}${RESET}${BG_CYAN}${FG_BLACK}${BOLD} ${GIT_LOGO} $branch ${RESET}${FG_CYAN}${BG_RED}${RIGHT_ARROW}${RESET}"
      fi
    else
      if [[ $is_special_dir == "true" ]]; then
        echo -n "${FG_DARK_BLUE}${BG_RED}${RIGHT_ARROW}${RESET}"
      else
        echo -n "${FG_BLUE}${BG_RED}${RIGHT_ARROW}${RESET}"
      fi
    fi
  fi
}

segment_prompt() {
  echo "${BG_RED}${FG_WHITE}${BOLD_ITALIC} %# ${RESET}${FG_RED}${RIGHT_ARROW}${RESET} "
}

# --- Assemble final prompt ---
setopt prompt_subst
PROMPT='$(segment_user)$(segment_path_and_git)$(segment_prompt)'

# Optional environment
export PATH="$HOME/bin:$PATH"
# export VISUAL=nvim

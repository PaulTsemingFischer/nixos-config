# ===== Zsh Powerline Prompt =====

# ========== COLOR THEME ==========
# Customize your prompt colors here
THEME_USER_BG="151"           # pastel green - username background
THEME_USER_FG="0"             # black - username text
THEME_SPECIAL_DIR_BG="67"     # dark blue - special dirs (~ or custom) background
THEME_SPECIAL_DIR_FG="255"    # white - special dirs text
THEME_PATH_BG="74"            # blue - path background
THEME_PATH_FG="255"           # white - path text
THEME_GIT_BG="116"            # cyan - git branch background
THEME_GIT_FG="0"              # black - git branch text
THEME_PROMPT_BG="181"         # red/pink - prompt symbol background
THEME_PROMPT_FG="255"         # white - prompt symbol text

# ========== INTERNAL COLOR VARIABLES (Do not edit below this line) ==========
BG_USER="%{\e[48;5;${THEME_USER_BG}m%}"
FG_USER="%{\e[38;5;${THEME_USER_BG}m%}"
BG_SPECIAL_DIR="%{\e[48;5;${THEME_SPECIAL_DIR_BG}m%}"
FG_SPECIAL_DIR="%{\e[38;5;${THEME_SPECIAL_DIR_BG}m%}"
BG_PATH="%{\e[48;5;${THEME_PATH_BG}m%}"
FG_PATH="%{\e[38;5;${THEME_PATH_BG}m%}"
BG_GIT="%{\e[48;5;${THEME_GIT_BG}m%}"
FG_GIT="%{\e[38;5;${THEME_GIT_BG}m%}"
BG_PROMPT="%{\e[48;5;${THEME_PROMPT_BG}m%}"
FG_PROMPT="%{\e[38;5;${THEME_PROMPT_BG}m%}"

# Text colors
TXT_USER_FG="%{\e[38;5;${THEME_USER_FG}m%}"
TXT_SPECIAL_DIR_FG="%{\e[38;5;${THEME_SPECIAL_DIR_FG}m%}"
TXT_PATH_FG="%{\e[38;5;${THEME_PATH_FG}m%}"
TXT_GIT_FG="%{\e[38;5;${THEME_GIT_FG}m%}"
TXT_PROMPT_FG="%{\e[38;5;${THEME_PROMPT_FG}m%}"

# Text styles
BOLD="%{\e[1m%}"
ITALIC="%{\e[3m%}"
BOLD_ITALIC="%{\e[1;3m%}"
RESET="%{\e[0m%}"

# Powerline symbols
RIGHT_ARROW=$'\ue0b0'           # 
GIT_LOGO=$'\ue725'              # 
WHITE_SEPARATOR=$'\ue0b1'       # 

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

  # WSL-specific path handling (commented out for Linux)
  # if [[ $pwd_path == "/mnt/c/Users/Skylar"* ]]; then
  #   is_special_dir=true
  #   if [[ $pwd_path == "/mnt/c/Users/Skylar/Downloads/Code"* ]]; then
  #     if [[ $pwd_path == "/mnt/c/Users/Skylar/Downloads/Code" ]]; then
  #       path_display="${BG_SPECIAL_DIR}${TXT_SPECIAL_DIR_FG}${BOLD_ITALIC} code ${RESET}"
  #       has_subdirs=false
  #     else
  #       local subdir=${pwd_path#/mnt/c/Users/Skylar/Downloads/Code}
  #       path_display="${BG_SPECIAL_DIR}${TXT_SPECIAL_DIR_FG}${BOLD_ITALIC} code ${RESET}"
  #       has_subdirs=true
  #       local IFS='/'
  #       for dir in $subdir; do
  #         [[ -z $dir ]] && continue
  #         if [[ -z $first ]]; then
  #           path_display+="${FG_SPECIAL_DIR}${BG_PATH}${RIGHT_ARROW}${RESET}${BG_PATH}${TXT_PATH_FG} $dir"
  #           first=1
  #         else
  #           path_display+=" ${TXT_PATH_FG}${WHITE_SEPARATOR}${RESET}${BG_PATH} $dir"
  #         fi
  #       done
  #     fi
  #   else
  #     if [[ $pwd_path == "/mnt/c/Users/Skylar" ]]; then
  #       path_display="${BG_SPECIAL_DIR}${TXT_SPECIAL_DIR_FG}${BOLD_ITALIC} winhome ${RESET}"
  #     else
  #       local subdir=${pwd_path#/mnt/c/Users/Skylar}
  #       path_display="${BG_SPECIAL_DIR}${TXT_SPECIAL_DIR_FG}${BOLD_ITALIC} winhome ${RESET}"
  #       has_subdirs=true
  #       local IFS='/'
  #       for dir in $subdir; do
  #         [[ -z $dir ]] && continue
  #         if [[ -z $first ]]; then
  #           path_display+="${FG_SPECIAL_DIR}${BG_PATH}${RIGHT_ARROW}${RESET}${BG_PATH}${TXT_PATH_FG} $dir"
  #           first=1
  #         else
  #           path_display+=" ${TXT_PATH_FG}${WHITE_SEPARATOR}${RESET}${BG_PATH} $dir"
  #         fi
  #       done
  #     fi
  #   fi
  # el
  if [[ $pwd_path == "~"* ]]; then
    is_special_dir=true
    if [[ $pwd_path == "~" ]]; then
      path_display="${BG_SPECIAL_DIR}${TXT_SPECIAL_DIR_FG}${BOLD_ITALIC} ~ ${RESET}"
    else
      local subdir=${pwd_path#\~}
      path_display="${BG_SPECIAL_DIR}${TXT_SPECIAL_DIR_FG}${BOLD_ITALIC} ~ ${RESET}"
      has_subdirs=true
      local IFS='/'
      for dir in $subdir; do
        [[ -z $dir ]] && continue
        if [[ -z $first ]]; then
          path_display+="${FG_SPECIAL_DIR}${BG_PATH}${RIGHT_ARROW}${RESET}${BG_PATH}${TXT_PATH_FG} $dir"
          first=1
        else
          path_display+=" ${TXT_PATH_FG}${WHITE_SEPARATOR}${RESET}${BG_PATH} $dir"
        fi
      done
    fi
  else
    local IFS='/'
    for dir in $pwd_path; do
      [[ -z $dir ]] && continue
      if [[ -z $first ]]; then
        path_display+="${BG_PATH}${TXT_PATH_FG} $dir"
        first=1
      else
        path_display+=" ${TXT_PATH_FG}${WHITE_SEPARATOR}${RESET}${BG_PATH} $dir"
      fi
      has_subdirs=true
    done
    [[ "$pwd_path" == "/" ]] && path_display="${BG_PATH}${TXT_PATH_FG} /"
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
    echo "${BG_USER}${TXT_USER_FG}${BOLD} %n ${RESET}${FG_USER}${BG_SPECIAL_DIR}${RIGHT_ARROW}${RESET}"
  else
    echo "${BG_USER}${TXT_USER_FG}${BOLD} %n ${RESET}${FG_USER}${BG_PATH}${RIGHT_ARROW}${RESET}"
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
      echo -n " ${RESET}${FG_PATH}${BG_GIT}${RIGHT_ARROW}${RESET}${BG_GIT}${TXT_GIT_FG}${BOLD} ${GIT_LOGO} $branch ${RESET}${FG_GIT}${RIGHT_ARROW}${RESET}"
    else
      echo -n " ${RESET}${FG_PATH}${RIGHT_ARROW}${RESET}"
    fi
  else
    if [[ -n $branch ]]; then
      if [[ $is_special_dir == "true" ]]; then
        echo -n "${FG_SPECIAL_DIR}${BG_GIT}${RIGHT_ARROW}${RESET}${BG_GIT}${TXT_GIT_FG}${BOLD} ${GIT_LOGO} $branch ${RESET}${FG_GIT}${RIGHT_ARROW}${RESET}"
      else
        echo -n "${FG_PATH}${BG_GIT}${RIGHT_ARROW}${RESET}${BG_GIT}${TXT_GIT_FG}${BOLD} ${GIT_LOGO} $branch ${RESET}${FG_GIT}${RIGHT_ARROW}${RESET}"
      fi
    else
      if [[ $is_special_dir == "true" ]]; then
        echo -n "${FG_SPECIAL_DIR}${RIGHT_ARROW}${RESET}"
      else
        echo -n "${FG_PATH}${RIGHT_ARROW}${RESET}"
      fi
    fi
  fi
}

segment_prompt() {
  echo " "
}

# --- Assemble final prompt ---
setopt prompt_subst
PROMPT='$(segment_user)$(segment_path_and_git)$(segment_prompt)'

# Optional environment
export PATH="$HOME/bin:$PATH"
# export VISUAL=nvim
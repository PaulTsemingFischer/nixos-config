# ===== Zsh Powerline Prompt with Color Constants =====

# ================= BASIC COLORS =================
COLOR_BLACK=0
COLOR_RED=196
COLOR_GREEN=46
COLOR_YELLOW=226
COLOR_BLUE=21
COLOR_MAGENTA=201
COLOR_CYAN=51
COLOR_WHITE=15

# ================= BRIGHT / LIGHT COLORS =================
COLOR_LIGHT_GRAY=250
COLOR_DARK_GRAY=235
COLOR_LIGHT_BLUE=74
COLOR_DARK_BLUE=67
COLOR_LIGHT_RED=181
COLOR_CYAN_LIGHT=116
COLOR_ORANGE=208
COLOR_PINK=212

# ================= PASTEL COLORS =================
COLOR_PASTEL_GREEN=151
COLOR_PASTEL_GREEN_LIGHT=157
COLOR_PASTEL_PINK=218
COLOR_PASTEL_ORANGE=215
COLOR_PASTEL_YELLOW=229
COLOR_PASTEL_CYAN=159
COLOR_PASTEL_BLUE=153
COLOR_PASTEL_PURPLE=183
COLOR_PASTEL_LAVENDER=225
COLOR_PASTEL_CORAL=210
COLOR_PASTEL_MINT=195

# ================= OPTIONAL ADDITIONAL SHADES =================
COLOR_BROWN=94
COLOR_TAN=180
COLOR_SOFT_BLUE=111
COLOR_SOFT_PURPLE=147
COLOR_SOFT_PINK=218   # same as pastel pink
COLOR_SOFT_GREEN=120


# ================= THEME COLORS =================
# Assign theme elements using color constants
THEME_USER_BG=$COLOR_PASTEL_GREEN
THEME_USER_FG=$COLOR_BLACK
THEME_SPECIAL_DIR_BG=$COLOR_DARK_BLUE
THEME_SPECIAL_DIR_FG=$COLOR_WHITE
THEME_PATH_BG=$COLOR_LIGHT_BLUE
THEME_PATH_FG=$COLOR_WHITE
THEME_GIT_BG=$COLOR_CYAN_LIGHT
THEME_GIT_FG=$COLOR_BLACK
THEME_PROMPT_BG=$COLOR_LIGHT_RED
THEME_PROMPT_FG=$COLOR_WHITE

# ================= INTERNAL COLOR VARIABLES =================
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

TXT_USER_FG="%{\e[38;5;${THEME_USER_FG}m%}"
TXT_SPECIAL_DIR_FG="%{\e[38;5;${THEME_SPECIAL_DIR_FG}m%}"
TXT_PATH_FG="%{\e[38;5;${THEME_PATH_FG}m%}"
TXT_GIT_FG="%{\e[38;5;${THEME_GIT_FG}m%}"
TXT_PROMPT_FG="%{\e[38;5;${THEME_PROMPT_FG}m%}"

# ================= TEXT STYLES =================
BOLD="%{\e[1m%}"
ITALIC="%{\e[3m%}"
BOLD_ITALIC="%{\e[1;3m%}"
RESET="%{\e[0m%}"

# ================= POWERLINE SYMBOLS =================
RIGHT_ARROW=$'\ue0b0'
GIT_LOGO=$'\ue725'
WHITE_SEPARATOR=$'\ue0b1'

# ================= GIT BRANCH DETECTION =================
git_branch() {
  if command git rev-parse --is-inside-work-tree &>/dev/null; then
    git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD
  fi
}

# ================= PATH FORMATTING =================
format_path() {
  local pwd_path=$(pwd | sed "s|^$HOME|~|")
  local path_display=""
  local has_subdirs=false
  local is_special_dir=false
  local first=

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

# ================= PROMPT SEGMENTS =================
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

# ================= ASSEMBLE FINAL PROMPT =================
setopt prompt_subst
PROMPT='$(segment_user)$(segment_path_and_git)$(segment_prompt)'

# ================= OPTIONAL ENVIRONMENT =================
export PATH="$HOME/bin:$PATH"
# export VISUAL=nvim

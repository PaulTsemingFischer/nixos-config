# ===== Zsh Powerline Prompt with Color Constants and Dynamic Git =====

# ================= BASIC COLORS =================
COLOR_BLACK=16        # #000000
COLOR_RED=196        # #FF0000
COLOR_GREEN=46       # #00FF00
COLOR_YELLOW=226     # #FFFF00
COLOR_BLUE=21        # #0000FF
COLOR_MAGENTA=201    # #FF00FF
COLOR_CYAN=51        # #00FFFF
COLOR_WHITE=15       # #FFFFFF

# ================= BRIGHT / LIGHT COLORS =================
COLOR_LIGHT_GRAY=250 # #D7D7D7
COLOR_DARK_GRAY=235  # #303030
COLOR_LIGHT_BLUE=74  # #5F87FF
COLOR_DARK_BLUE=67   # #005F87
COLOR_LIGHT_RED=181  # #FF5F87
COLOR_CYAN_LIGHT=116 # #87FFD7
COLOR_ORANGE=208     # #FFAF00
COLOR_PINK=212       # #FF87AF

# ================= PASTEL COLORS =================
COLOR_PASTEL_GREEN=151      # #87D7AF
COLOR_PASTEL_GREEN_LIGHT=157 # #AFD7AF
COLOR_PASTEL_PINK=218       # #FFAFD7
COLOR_PASTEL_ORANGE=215     # #FFD7AF
COLOR_PASTEL_YELLOW=229     # #FFFFAF
COLOR_PASTEL_CYAN=159       # #AFD7D7
COLOR_PASTEL_BLUE=153       # #87D7FF
COLOR_PASTEL_PURPLE=183     # #D7AFD7
COLOR_PASTEL_LAVENDER=225   # #FFD7FF
COLOR_PASTEL_CORAL=210      # #FFBFBF
COLOR_PASTEL_MINT=195       # #BFFFD7

# ================= OPTIONAL ADDITIONAL SHADES =================
COLOR_BROWN=94        # #875F00
COLOR_TAN=180         # #FFD7AF
COLOR_SOFT_BLUE=111   # #87D7FF
COLOR_SOFT_PURPLE=147 # #AF87FF
COLOR_SOFT_PINK=218   # #FFAFD7 (same as pastel pink)
COLOR_SOFT_GREEN=120  # #87FF87


# ================= THEME COLORS =================
THEME_USER_BG=$COLOR_SOFT_PURPLE
THEME_USER_FG=$COLOR_BLACK
THEME_SPECIAL_DIR_BG=$COLOR_PASTEL_GREEN
THEME_SPECIAL_DIR_FG=$COLOR_BLACK
THEME_PATH_BG=$COLOR_PASTEL_BLUE
THEME_PATH_FG=$COLOR_BLACK
THEME_PROMPT_BG=$COLOR_LIGHT_RED
THEME_PROMPT_FG=$COLOR_WHITE

# Git status colors
THEME_GIT_CLEAN_BG=$COLOR_PASTEL_ORANGE
THEME_GIT_CLEAN_FG=$COLOR_BLACK
THEME_GIT_STAGED_BG=$COLOR_PASTEL_YELLOW
THEME_GIT_STAGED_FG=$COLOR_BLACK
THEME_GIT_UNCOMMITTED_BG=$COLOR_SOFT_PINK
THEME_GIT_UNCOMMITTED_FG=$COLOR_BLACK

# ================= INTERNAL COLOR VARIABLES =================
BG_USER="%{\e[48;5;${THEME_USER_BG}m%}"
FG_USER="%{\e[38;5;${THEME_USER_BG}m%}"
BG_SPECIAL_DIR="%{\e[48;5;${THEME_SPECIAL_DIR_BG}m%}"
FG_SPECIAL_DIR="%{\e[38;5;${THEME_SPECIAL_DIR_BG}m%}"
BG_PATH="%{\e[48;5;${THEME_PATH_BG}m%}"
FG_PATH="%{\e[38;5;${THEME_PATH_BG}m%}"
BG_PROMPT="%{\e[48;5;${THEME_PROMPT_BG}m%}"
FG_PROMPT="%{\e[38;5;${THEME_PROMPT_BG}m%}"

TXT_USER_FG="%{\e[38;5;${THEME_USER_FG}m%}"
TXT_SPECIAL_DIR_FG="%{\e[38;5;${THEME_SPECIAL_DIR_FG}m%}"
TXT_PATH_FG="%{\e[38;5;${THEME_PATH_FG}m%}"
TXT_PROMPT_FG="%{\e[38;5;${THEME_PROMPT_FG}m%}"

# Git status colors
BG_GIT_CLEAN="%{\e[48;5;${THEME_GIT_CLEAN_BG}m%}"
TXT_GIT_CLEAN_FG="%{\e[38;5;${THEME_GIT_CLEAN_FG}m%}"
BG_GIT_STAGED="%{\e[48;5;${THEME_GIT_STAGED_BG}m%}"
TXT_GIT_STAGED_FG="%{\e[38;5;${THEME_GIT_STAGED_FG}m%}"
BG_GIT_UNCOMMITTED="%{\e[48;5;${THEME_GIT_UNCOMMITTED_BG}m%}"
TXT_GIT_UNCOMMITTED_FG="%{\e[38;5;${THEME_GIT_UNCOMMITTED_FG}m%}"

# Foreground colors for git arrow
FG_GIT_CLEAN="%{\e[38;5;${THEME_GIT_CLEAN_BG}m%}"
FG_GIT_STAGED="%{\e[38;5;${THEME_GIT_STAGED_BG}m%}"
FG_GIT_UNCOMMITTED="%{\e[38;5;${THEME_GIT_UNCOMMITTED_BG}m%}"

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

# ================= GIT STATUS DETECTION =================
git_status_info() {
  if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    return
  fi

  local git_st=$(git status --porcelain 2>/dev/null)

  if [[ -z $git_st ]]; then
    echo "clean"
    return
  fi

  if echo "$git_st" | grep -q "^[AMDR]"; then
    echo "staged"
    return
  fi

  echo "uncommitted"
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

  if [[ -n $branch ]]; then
    local git_state=$(git_status_info)
    
    local git_bg git_fg git_arrow_fg
    case $git_state in
      clean)
        git_bg="${BG_GIT_CLEAN}"
        git_fg="${TXT_GIT_CLEAN_FG}"
        git_arrow_fg="${FG_GIT_CLEAN}"
        ;;
      staged)
        git_bg="${BG_GIT_STAGED}"
        git_fg="${TXT_GIT_STAGED_FG}"
        git_arrow_fg="${FG_GIT_STAGED}"
        ;;
      uncommitted)
        git_bg="${BG_GIT_UNCOMMITTED}"
        git_fg="${TXT_GIT_UNCOMMITTED_FG}"
        git_arrow_fg="${FG_GIT_UNCOMMITTED}"
        ;;
    esac
    
    echo -n " ${RESET}${FG_PATH}${git_bg}${RIGHT_ARROW}${RESET}${git_bg}${git_fg}${BOLD} ${GIT_LOGO} $branch ${RESET}${git_arrow_fg}${RIGHT_ARROW}${RESET}"
  else
    if [[ $has_subdirs == "true" ]]; then
      echo -n " ${RESET}${FG_PATH}${RIGHT_ARROW}${RESET}"
    else
      echo -n "${FG_SPECIAL_DIR}${RIGHT_ARROW}${RESET}"
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
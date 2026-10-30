# worktrunk (installed by run_once_install-worktrunk.sh)
command -v wt >/dev/null || return
eval "$(wt config shell init zsh)"

# Repo parent folders to scan for cross-repo commands.
WT_ROOTS=(~/projects/LEGO)

_wt_repos() { local d; for d in $^WT_ROOTS/*(N/); [[ -d $d/.git ]] && print -r -- $d; }

# List worktrees of all repos.
wta() { local r; for r in $(_wt_repos); do print "== ${r:t}"; (cd $r && wt list); done; }

# Pick a worktree in any repo with fzf, then cd to it.
wtj() {
  local p r
  p=$(for r in $(_wt_repos); do git -C $r worktree list --porcelain | awk '/^worktree /{print $2}'; done \
    | grep '/\.worktrees/' \
    | fzf --preview 'git -C {} status -sb; echo; git -C {} log --oneline -5; echo; git -C {} diff --stat') || return
  cd "$p"
}

# Remove merged worktrees and branches in all repos.
wtprune() {
  local r
  for r in $(_wt_repos); do
    print "== ${r:t}"
    git -C $r fetch --prune --quiet
    (cd $r && wt step prune)
  done
}

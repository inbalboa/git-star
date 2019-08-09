#!/usr/bin/env bash

# are we in a git repo?
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
  echo 'Not a git repository.' 1>&2
  exit 1
fi

# choose remote. priority to: provided argument, default in config, detected tracked remote, 'origin'
branch=${2:-$(git symbolic-ref -q --short HEAD)}
upstream_branch_full_name=$(git config "branch.$branch.merge")
upstream_branch=${upstream_branch_full_name#"refs/heads/"}
tracked_remote=$(git config "branch.$branch.remote")
default_remote=$(git config open.default.remote)
remote=${1:-$default_remote}
remote=${remote:-$tracked_remote}
remote=${remote:-"origin"}

giturl=$(git ls-remote --get-url "$remote")

if [[ -z "$giturl" ]]; then
  echo "Git remote is not set for $remote" 1>&2
  exit 1
fi

# From git-fetch(5), native protocols:
# ssh://[user@]host.xz[:port]/path/to/repo.git/
# git://host.xz[:port]/path/to/repo.git/
# http[s]://host.xz[:port]/path/to/repo.git/
# ftp[s]://host.xz[:port]/path/to/repo.git/
# [user@]host.xz:path/to/repo.git/ - scp-like but is an alternative to ssh.
# [user@]hostalias:path/to/repo.git/ - handles host aliases defined in ssh_config(5)

# Determine whether this is a url (https, ssh, git+ssh...) or an scp-style path
if [[ "$giturl" =~ ^[a-z\+]+://.* ]]; then  
  uri=${giturl#*://} uri=${uri#*@} # Trim URL scheme and possible username
  domain=${uri%%/*} urlpath=${uri#*/} # Split on first '/ to get server name and path
else
  uri=${giturl##*@} # Trim possible username from SSH path
  domain=${uri%%:*} urlpath=${uri#*:} # Split on first ':' to get server name and path
fi

if [ $domain != 'github.com' ]; then
  echo 'Not a Github repository.' 1>&2
  exit 1
fi

urlpath=${urlpath#/} urlpath=${urlpath%/} urlpath=${urlpath%.git} # Trim "/" from beginning of URL; "/" and ".git" from end of URL
user=${urlpath%%/*} repo=${urlpath#*/} # get user & repo

printf "https://$domain/$urlpath\n"
curl --silent https://api.github.com/repos/$user/$repo | jq --raw-output '"★ Star \(.stargazers_count) · ⑂ Fork \(.forks)"'

EAPI=8
inherit acct-user
ACCT_USER_ID=-1
ACCT_USER_GROUPS=( urbackup )
ACCT_USER_COMMENT="urbackup server user (overlay)"
ACCT_USER_HOME="/var/lib/urbackup"
ACCT_USER_SHELL="/bin/bash"
acct-user_add_deps

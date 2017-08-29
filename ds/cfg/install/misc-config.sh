#!/bin/bash -x

source /host/settings.sh

### expose the logo file on the drupal dir
ln -s $DRUPAL_DIR/profiles/btr_client/btr_client.png $DRUPAL_DIR/logo.png

### put the cache on RAM (to improve efficiency)
sed -i /etc/fstab \
    -e '/appended by installation scripts/,$ d'
cat <<EOF >> /etc/fstab
##### appended by installation scripts
tmpfs		/dev/shm	tmpfs	defaults,noexec,nosuid	0	0
tmpfs		/var/www/bcl/cache	tmpfs	defaults,size=5M,mode=0777,noexec,nosuid	0	0
devpts		/dev/pts	devpts	rw,noexec,nosuid,gid=5,mode=620		0	0
# mount /tmp on RAM for better performance
tmpfs /tmp              tmpfs  defaults,noatime,mode=1777,nosuid  0 0
tmpfs /var/log/apache2  tmpfs  defaults,noatime                   0 0
EOF

### customize the configuration of sshd
sed -i /etc/ssh/sshd_config \
    -e 's/^Port/#Port/' \
    -e 's/^PasswordAuthentication/#PasswordAuthentication/' \
    -e 's/^X11Forwarding/#X11Forwarding/'

sed -i /etc/ssh/sshd_config \
    -e '/^### custom config/,$ d'

sshd_port=${SSHD_PORT:-2201}
cat <<EOF >> /etc/ssh/sshd_config
### custom config
Port $sshd_port
PasswordAuthentication no
X11Forwarding no
EOF

echo $DOMAIN > /etc/hostname

cat <<EOF > /root/.bash_aliases
alias mysql='mysql --defaults-file=/etc/mysql/debian.cnf'
#alias git='hub'
alias g='git status -sb'
alias gh='git hist'
alias gp='git pull'
alias gpr='git pull --rebase'
alias gpp='git pull --rebase && git push'
alias gf='git fetch'
alias gb='git branch'
alias ga='git add'
alias gc='git commit'
alias gca='git commit --amend'
alias gcv='git commit --no-verify'
alias gd='git diff --color-words'
alias gdc='git diff --cached -w'
alias gdw='git diff --no-ext-diff --word-diff'
alias gdv='git diff'
alias gl='git log --oneline --decorate'
alias gt='git tag'
alias grc='git rebase --continue'
alias grs='git rebase --skip'
alias gsl='git stash list'
alias gss='git stash save'
EOF

cat <<EOF > /root/.gitconfig
[alias]
    hist = log --color --pretty=format:\"%C(yellow)%h%C(reset) %s%C(bold red)%d%C(reset) %C(green)%ad%C(reset) %C(blue)[%an]%C(reset)\" --relative-date --decorate
    unstage = reset HEAD --
    restore = checkout --
    cn = commit --no-verify
    co = checkout
    praise = blame
    visualise = !gitk
    graph = log --color --graph --pretty=format:\"%h | %ad | %an | %s%d\" --date=short
EOF

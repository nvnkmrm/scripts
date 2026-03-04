git rebase HEAD~$N --exec \
  'git commit --amend --no-edit --author="Your Name <new@email.com>"'
git push --force origin <branch>
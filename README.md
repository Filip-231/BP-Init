# Init
```
git clone git@github.com:Filip-231/Init.git && cd Init
git filter-branch --index-filter 'git rm --ignore-unmatch --cached -qr -- . && git reset -q $GIT_COMMIT -- . ' --prune-empty -- --all
git remote rm origin
git remote add origin git@github.com:Filip-231/1.git
git pull origin master --allow-unrelated-histories
git push origin master

```


Project initialization:
```angular2html
make test
make init

```
# Init
This repository is made to initialize new projects with all design patterns included. All You need to do is:
```
git clone git@github.com:Filip-231/Init.git && cd Init
git remote rm origin
git remote add origin git@github.com:Filip-231/1.git
git push origin master
make test
make init
```

To configure pytest in Pycharm add: ```-p no:allure_pytest_bdd``` to additional parameters.

### Useful not necessary commands:

- Can be used for filtering git repo if you want to delete some files:

```git filter-branch --index-filter 'git rm --ignore-unmatch --cached -qr -- . && git reset -q $GIT_COMMIT -- . ' --prune-empty -- --all```


- Can be used for pulling when repo is not empty:

``git pull origin master --allow-unrelated-histories``
# dotfiles

## Install chezmoi and your dotfiles on a new machine with a single command
```
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply boalbert
```
### Setting up transitory environments
(e.g. short-lived Linux containers)
```
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --one-shot boalbert
```


## Pull the latest changes from your repo and apply them
```
chezmoi update
```


## Pull the latest changes from your repo and see what would change, without actually applying the changes

```
chezmoi git pull -- --autostash --rebase && chezmoi diff
```

If you're happy with the changes, then you can run
```
chezmoi apply
```

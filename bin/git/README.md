Git Commands
==

# Setup

To use these commands, add AD/dev-tools/git to your PATH variable

# Usage

The following are git commands that are provided to be more useful than the native git commands:

* add
* commit
* push
* pull
* merge
* merge-into
* staged
* unstaged
* stash
* unstash
* cherry-pick
* refresh
* sync-dev-to-prod

## add
`add foo` will add foo to the staging area for commit

## commit
`commit -m 'My commit message'` will commit the staged changes. If -m is omitted an editor is launched where you'll type your commit message in. Make it descriptive

## merge
`merge foo` will merge foo into the current branch

## merge-into
`merge-into foo` will merge the current branch into branch foo

## refresh
`refresh` is the same as `merge master`, it will merge master into the current branch

## staged
`staged` will show you all of the changes (in diff format) that are currently staged for commit

## unstaged
`unstaged` will show you all of the changes (in diff format) that are *not yet* staged for commit (use `add` to stage them)

## sync-dev-to-prod
`sync-dev-to-prod` will find the Site you are currently in (you need to run it from within a specific Site dir) and it will rsync the entire dev folder to prod. Use this when you want to test changes on dev instances before copying the changes to prod

# Output

Each command will tell you the exact git commands it is running for you, so if you want to re-run part of an alias, or just learn more about what's going on, look at the yellow lines starting with ::

![Terminal output](https://i.imgur.com/Fm0WyrP.png "Terminal output")

It will also prepend each command with a short description of what it's doing, and after the command it will print the output of whatever it ran. In this case you can see that running commit actually ran both a `git status` and a `git commit`, to give you a quick snapshot of the changes you just committed

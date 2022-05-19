# APCSFinalProject
Final project for APCS MKS22X course at Stuyvesant High School

## Guide to Branching & Merging
To avoid pushing non-functional code to main and to reduce the number of merge operations that need to be performed while maintaining regular commits, **DO NOT** push directly to main.

Branches have been created for each person called `frank-branch` and `ntarsis-branch` respectively. You should do your work on your individual branch, then merge it to master only when give-or-take a feature has been mostly finished.

This does not preclude you from committing regularly and you should still do that.

To switch to a branch, do `git checkout [branch_name]`, example would be `git checkout ntarsis-branch`.

To check which branch you are on, you can do `git status`.

Committing, pushing, and pulling from remote will work the same when you're on a branch.

To update your branch with content from main, make sure you are on the correct branch, then do `git merge main`.

When you are ready to merge your branch to main, do `git checkout main`, and then do `git merge [branch_name]`.

In case there is a merge conflict, you may fix it by opening the files concerned and looking for the conflict markers, fixing it manually, then committing it.

In case you are having trouble on fixing it, you may do `git merge --abort` to stop the merge and then ask for help after that.

Other helpful commands that you should look at include `git branch`, `git reset`, and `git rebase`.

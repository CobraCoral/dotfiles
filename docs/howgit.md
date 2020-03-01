Create a new repository, or reuse an existing one.

Generate a new SSH key:
```
ssh-keygen -t rsa -C "your_email@example.com"
```

Copy the contents of the file `~/.ssh/id_rsa.pub` to your SSH keys in your GitHub account settings.

Test SSH key:
```
$ ssh -T git@github.com
Hi cobracoral! You've successfully authenticated, but GitHub does not provide shell access.
```

Change directory into the local clone of your repository (if you're not already there) and run:

```
git remote set-url origin git@github.com:username/your-repository.git
```

Now try editing a file (try the README) and then do:

```
$ git commit -am "Update README.md"
$ git push
```

You should not be asked for a username or password. If it works, your SSH key is correctly configured.

Example:
```
$ git init
$ git remote add origin git@github.com:CobraCoral/opencv_fun.git
$ git remote add origin https://github.com/CobraCoral/dotfiles.git
$ git remote add upstream https://github.com/CobraCoral/dotfiles.git
$ git remote set-url origin git@github.com:cobracoral/dotfiles.git
$ git pull origin master
$ git add .
$ git commit
$ git push --set-upstream origin master
```

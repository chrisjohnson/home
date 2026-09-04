### New Mac?

1. Download Firefox, Ghostty
2. Sign into Firefox, sync
3. https://github.com, login
4. Open Ghostty:

```
# Install homebrew, git
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install git

# Setup ssh key
ssh-keygen -t rsa

# In your browser, navigate to https://github.com/settings/keys and add your new ssh key

# Clone home.git
git clone git@github.com:chrisjohnson/home.git ~/.home
cd ~/.home

# Run the setup
./init.sh
```

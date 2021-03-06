#!/bin/bash

WORKSPACE=$HOME/workspace
LABS=$WORKSPACE/labs
PROJECTS=$WORKSPACE/projects
DOTFILES=$WORKSPACE/dotfiles


function display_title {
  echo -e "\e[34m* ${1}\e[39m"
}

# update and upgrade system
display_title "UPDATE APT PACKAGES"
sudo apt update -qq && sudo apt upgrade -y -qq


# install apps
dsplay_title "INSTALL APT PACKAGES"
sudo apt install -qq -y\
  git\
  tig\
  neovim\
  htop\
  tmux\
  zsh\
  curl\
  wget\
  httpie\
  tree\
  docker.io\
  docker-compose\
  python3-pip\
  python3-testresources\
  silversearcher-ag\
  thefuck\
  golang\
  fzf\
  npm\
  yarnpkg\
  net-tools\


# install exa
wget -P /tmp https://github.com/ogham/exa/releases/download/v0.9.0/exa-linux-x86_64-0.9.0.zip
unzip /tmp/exa-linux-x86_64-0.9.0.zip -d ~/.local/bin/
mv ~/.local/bin/exa-linux-x86_64 ~/.local/bin/exa
rm /tmp/exa-linux-x86_64-0.9.0.zip

# install fonts
display_title "INSTALL NERD FONTS"
mkdir -p .local/share/fonts
wget -P /tmp https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/DroidSansMono.zip
unzip /tmp/DroidSansMono.zip -d ~/.local/share/fonts
rm DroidSansMono.zip

fc-cache -f -v


# install python packages
display_title "PYTHON PACKAGES"
python3 -m pip install --upgrade pip
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python3 -
python3 -m pip install --quiet black
python3 -m pip install --quiet pylint


# initialize workspace
mkdir -p $PROJECTS
mkdir -p $LABS



# install tmux plugins
display_title "TMUX"
mkdir -p ~/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins

# install zsh plugins
display_title "ZSH"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k


# install neovim plugins
display_title "NEOVIM"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

python3 -m pip install neovim --force
sudo npm install -g neovim

# initialize dotfiles
display_title "DOTFILES"
git clone git@github.com:skitoo/dotfiles.git $DOTFILES

rm ~/.zshrc ~/.gitconfig ~/.tmux.conf

mkdir -p ~/.config/nvim

ln -s $DOTFILES/zsh/zshrc ~/.zshrc
ln -s $DOTFILES/git/gitconfig ~/.gitconfig
ln -s $DOTFILES/tmux/tmux.conf ~/.tmux.conf
ln -s $DOTFILES/vim/vimrc ~/.config/nvim/init.vim

# change default shell by zsh
chsh -s $(which zsh)

# docker
sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo gpasswd -a $USER docker


# clean
display_title "CLEAN"
sudo apt autoremove -y -qq

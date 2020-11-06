#!/bin/bash

WORKSPACE=$HOME/workspace
DOTFILES=$WORKSPACE/dotfiles

echo $DOTFILES

# update and upgrade system
echo "--- UPDATE APT PACKAGES ---"
sudo apt upgrade -qq && sudo apt upgrade -y -qq


# install apps
echo "--- INSTALL APT PACKAGES ---"
sudo apt install -qq -y\
	git\
	neovim\
	htop\
	tmux\
	zsh\
	curl\
	wget\
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



# install python packages
echo "--- PYTHON PACKAGES ---"
python3 -m pip install --quiet poetry


# initialize workspace
mkdir -p $WORKSPACE

# initialize dotfiles
echo "--- DOTFILES ---"
git clone git@github.com:skitoo/dotfiles.git $DOTFILES

rm ~/.zshrc ~/.gitconfig ~/.tmux.conf

mkdir -p ~/.config/nvim

ln -s $DOTFILES/zsh/zshrc ~/.zshrc
ln -s $DOTFILES/git/gitconfig ~/.gitconfig
ln -s $DOTFILES/tmux/tmux.conf ~/.tmux.conf
ln -s $DOTFILES/vim/vimrc ~/.config/nvim/init.vim


# install tmux plugins
echo "--- TMUX ---"
mkdir -p ~/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins

# install zsh plugins
echo "--- ZSH ---"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k


# install neovim plugins
echo "--- NEOVIM ---"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# clean
echo "--- CLEAN ---"
sudo apt autoremove -y -qq

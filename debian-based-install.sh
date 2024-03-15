#!/bin/bash

# URLs
ohmyzsh_install_script="https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
powerlevel10k_repo="https://github.com/romkatv/powerlevel10k.git"

# Prompt user to change password
read -p "Do you want to change the user's password? [Y/n] " input
input=${input:-Y} 
if [[ $input == "Y" || $input == "y" ]]; then
    passwd
fi

# Update and upgrade packages
sudo apt update -y || { echo "Error updating packages."; exit 1; }
sudo apt upgrade -y || { echo "Error upgrading packages."; exit 1; }

# Install necessary packages
sudo apt install git zsh wget curl neofetch bat python3-dev python3-pip python3-setuptools -y

# Install Oh My Zsh
echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL $ohmyzsh_install_script)" </dev/null

# Check if Oh My Zsh installation succeeded
if [ ! -d ~/.oh-my-zsh ]; then
    echo "Oh My Zsh installation failed."
    exit 1
fi

# Clone powerlevel10k, zsh-autosuggestions, zsh-you-should-use, zsh-bat and zsh-syntax-highlighting
git clone --depth=1 $powerlevel10k_repo ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/you-should-use
git clone https://github.com/fdellwing/zsh-bat.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-bat
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Install thefuck plugin
pip3 install thefuck --user

# Remove existing zsh configuration files
[ -e ~/.zshrc ] && rm -f ~/.zshrc
[ -e ~/.p10k.zsh ] && rm -f ~/.p10k.zsh

# Download new zsh configuration files
wget https://raw.githubusercontent.com/MushuDG/Bash-To-ZSH-Initialization/main/.p10k.zsh -O ~/.p10k.zsh
wget https://raw.githubusercontent.com/MushuDG/Bash-To-ZSH-Initialization/main/.zshrc -O ~/.zshrc

# Clean up
cd ..
rm -rf ./Bash-To-ZSH-Initialization

# Set Zsh as the default shell if user agrees
echo "Set Zsh as the default shell? [Y/n]"
read set_zsh_default
if [[ $set_zsh_default == "Y" || $set_zsh_default == "y" ]]; then
    clear
    chsh -s $(which zsh)
    # Start zsh
    zsh
fi

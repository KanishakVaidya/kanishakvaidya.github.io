#!/bin/bash
dotfile_text='
 /$$   /$$ /$$    /$$  /$$$$$$   /$$$$$$        /$$$$$$                       /$$               /$$ /$$                    
| $$  /$$/| $$   | $$ /$$__  $$ /$$__  $$      |_  $$_/                      | $$              | $$| $$                    
| $$ /$$/ | $$   | $$| $$  \ $$| $$  \__/        | $$   /$$$$$$$   /$$$$$$$ /$$$$$$    /$$$$$$ | $$| $$  /$$$$$$   /$$$$$$ 
| $$$$$/  |  $$ / $$/| $$  | $$|  $$$$$$         | $$  | $$__  $$ /$$_____/|_  $$_/   |____  $$| $$| $$ /$$__  $$ /$$__  $$
| $$  $$   \  $$ $$/ | $$  | $$ \____  $$        | $$  | $$  \ $$|  $$$$$$   | $$      /$$$$$$$| $$| $$| $$$$$$$$| $$  \__/
| $$\  $$   \  $$$/  | $$  | $$ /$$  \ $$        | $$  | $$  | $$ \____  $$  | $$ /$$ /$$__  $$| $$| $$| $$_____/| $$      
| $$ \  $$   \  $/   |  $$$$$$/|  $$$$$$/       /$$$$$$| $$  | $$ /$$$$$$$/  |  $$$$/|  $$$$$$$| $$| $$|  $$$$$$$| $$      
|__/  \__/    \_/     \______/  \______/       |______/|__/  |__/|_______/    \___/   \_______/|__/|__/ \_______/|__/      
=============================================================================================================================
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
=============================================================================================================================
'
clear
echo "$dotfile_text"

echo "Please grant root priveliges to $USER"
grep kv-arch-repo /etc/pacman.conf > /dev/null || echo "
[kv-arch-repo]
SigLevel = Optional TrustAll
Server = https://kanishakvaidya.github.io/\$repo/\$arch" | sudo tee -a /etc/pacman.conf

curl -fLo /tmp/packages.md https://kanishakvaidya.github.io/arch-KVOS/static/scripts/packages.md
while ! ( nvim /tmp/packages.md || vim /tmp/packages.md || micro /tmp/packages.md || nano /tmp/packages.md || vi /tmp/packages.md || $EDITOR /tmp/packages.md || $VISUAL /tmp/packages.md )
do
    echo "No text editor found. Installing nano now. Suffer. Atleast set an EDITOR from now"
    sleep 2
done

while ! sudo pacman -Syu --needed --noconfirm $(awk '/\- \[X\]/ {getline ; print}' /tmp/packages.md | tr "\n" " " )
do
    read -p "Some errors occured while installing packages. Rectify them and press ENTER to continue."
    sleep 2
done

echo 'export ZDOTDIR="$HOME"/.config/zsh' | sudo tee /etc/zsh/zshenv
chsh -s /usr/bin/zsh

#!/bin/bash
[[ -d $HOME/Desktop ]] && mv $HOME/Desktop $HOME/desktop || mkdir -p $HOME/desktop
[[ -d $HOME/Downloads ]] && mv $HOME/Downloads $HOME/dwn || mkdir -p $HOME/dwn
[[ -d $HOME/Templates ]] && mv $HOME/Templates $HOME/templates || mkdir -p $HOME/templates
[[ -d $HOME/Public ]] && mv $HOME/Public $HOME/shared || mkdir -p $HOME/shared
[[ -d $HOME/Documents ]] && mv $HOME/Documents $HOME/doc || mkdir -p $HOME/doc
[[ -d $HOME/Music ]] && mv $HOME/Music $HOME/music || mkdir -p $HOME/music
[[ -d $HOME/Pictures ]] && mv $HOME/Pictures $HOME/pic || mkdir -p $HOME/pic
[[ -d $HOME/Videos ]] && mv $HOME/Videos $HOME/vid || mkdir -p $HOME/vid
mkdir -p $HOME/.local/state/zsh $HOME/.local/share $HOME/.local/bin $HOME/.local/share/icons/ $HOME/.config $HOME/.local/share/AppImages $HOME/.local/share/fonts

git clone --depth=1 --separate-git-dir=$HOME/.config/my_dotfiles https://github.com/KanishakVaidya/dotfiles.git /tmp/tmpdotfiles
rsync --recursive --verbose --exclude '.git' /tmp/tmpdotfiles/ $HOME/

clear ; echo "$dotfile_text"

xdg-user-dirs-update
fc-cache -fv

# git clone --depth=1 https://github.com/KanishakVaidya/wallpapers.git $HOME/pic/.wall

echo "setting a link to xresources"
ln -sf $HOME/.config/Xresources/codedark $HOME/.Xresources

git clone --depth=1 https://github.com/PapirusDevelopmentTeam/papirus-icon-theme.git /tmp/papirus-icons
cp -r /tmp/papirus-icons/Papirus* $HOME/.local/share/icons/

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim -c PlugInstall -c qa
clear

git clone https://aur.archlinux.org/paru-bin.git /tmp/paru-bin
(cd /tmp/paru-bin ; makepkg -si)

echo '
 /$$   /$$                       /$$                     /$$        /$$$$$$                
| $$  | $$                      | $$                    | $$       /$$__  $$               
| $$  | $$  /$$$$$$   /$$$$$$$ /$$$$$$    /$$$$$$       | $$      | $$  \ $$               
| $$$$$$$$ |____  $$ /$$_____/|_  $$_/   |____  $$      | $$      | $$$$$$$$               
| $$__  $$  /$$$$$$$|  $$$$$$   | $$      /$$$$$$$      | $$      | $$__  $$               
| $$  | $$ /$$__  $$ \____  $$  | $$ /$$ /$$__  $$      | $$      | $$  | $$               
| $$  | $$|  $$$$$$$ /$$$$$$$/  |  $$$$/|  $$$$$$$      | $$$$$$$$| $$  | $$               
|__/  |__/ \_______/|_______/    \___/   \_______/      |________/|__/  |__/               
                                                                                           
                                                                                           
                                                                                           
 /$$    /$$ /$$             /$$                     /$$    /$$           /$$$$$$     /$$   
| $$   | $$|__/            | $$                    | $$   /$$/          /$$$_  $$  /$$$$$$ 
| $$   | $$ /$$  /$$$$$$$ /$$$$$$    /$$$$$$       | $$  /$$//$$    /$$| $$$$\ $$ /$$__  $$
|  $$ / $$/| $$ /$$_____/|_  $$_/   |____  $$      |__/ /$$/|  $$  /$$/| $$ $$ $$| $$  \__/
 \  $$ $$/ | $$|  $$$$$$   | $$      /$$$$$$$       /$$|  $$ \  $$/$$/ | $$\ $$$$|  $$$$$$ 
  \  $$$/  | $$ \____  $$  | $$ /$$ /$$__  $$      | $$ \  $$ \  $$$/  | $$ \ $$$ \____  $$
   \  $/   | $$ /$$$$$$$/  |  $$$$/|  $$$$$$$      | $$  \  $$ \  $/   |  $$$$$$/ /$$  \ $$
    \_/    |__/|_______/    \___/   \_______/      |__/   \__/  \_/     \______/ |  $$$$$$/
                                                                                  \_  $$_/ 
                                                                                    \__/   
                                                                                          '
exit

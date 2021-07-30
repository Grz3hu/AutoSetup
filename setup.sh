#!/bin/bash
#TODO: install autojump, fzf, st fonts
dep=(
		gcc \
		git \
		unzip \
		feh \
		light \
		acpi \
		stow \
		pulsemixer \
		autojump \
		neovim \
		fzf \
		meson \
		ninja \
		golang-go \
		libxft-dev \
		libxinerama-dev \
		libx11-xcb-dev \
		libxcb-res0-dev \
		libxext-dev \
		libxcb1-dev \
		libxcb-damage0-dev \
		libxcb-xfixes0-dev \
		libxcb-shape0-dev \
		libxcb-render-util0-dev \
		libxcb-render0-dev \
		libxcb-randr0-dev \
		libxcb-composite0-dev \
		libxcb-image0-dev \
		libxcb-present-dev \
		libxcb-xinerama0-dev \
		libxcb-glx0-dev \
		libpixman-1-dev \
		libdbus-1-dev \
		libconfig-dev \
		libgl1-mesa-dev \
		libpcre2-dev \
		libpcre3-dev \
		libevdev-dev \
		uthash-dev \
		libev-dev \
		)

echo -e "Checking dependecies: "
for d in "${dep[@]}"
do
	if dpkg -s $d &> /dev/null
	then
	    echo -e "\t $d is installed";
	else
	    echo -e "\t $d not installed";
	    guard="1"
	fi
done

if [ ! -z "$guard" ]
then 
	echo "Not all dependecies are installed, quitting"
	exit 
fi

echo "Where do you want to put install files:"
read install_path
if [ ! -d "$install_path" ]
then 
	echo "Directory does not exists"
	exit 
fi

#Dwm
echo "Downloading dwm"
git clone "https://github.com/Grz3hu/dwm.git" "$install_path/dwm"
cd $install_path/dwm/ && ./compile && cd -

echo "Installing dwm"
pwd
rm ~/.xinitrc
pwd
cp .xinitrc ~/.xinitrc
ln -s ~/.xinitrc ~/.xsession
chmod 755 ~/.xinitrc
sudo cp custom-dwm.desktop /usr/share/xsessions/custom-dwm.desktop

#Dotfiles
echo "Downloading dotfiles"
git clone "https://github.com/Grz3hu/Dotfiles.git" "$install_path/dotfiles"
cd $install_path/dotfiles/ && stow aliases cava compton dunst feh i3 mutt ncmpcpp neofetch newsboat polybar ranger termite xresources zathura -t ~ 
xrdb ~/.Xresources
echo "source ~/.config/aliasrc" >> ~/.zshrc
cd "$install_path"
##Vimplug

#Statusbar
echo "Installing gocaudices (statusbar)"
sudo cp -r gocaudices "$install_path/gocaudices"
cd "$install_path/gocaudices" && go build . && cp gocaudices /usr/local/bin/gocaudices && cd -
sudo cp statusbar/* /usr/local/bin/

#Nerdfonts
echo "Download nerdfonts"
sudo wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Mononoki.zip
sudo wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Inconsolata.zip
sudo wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/LiberationMono.zip
sudo unzip Mononoki.zip -d "$install_path/nerd-font"
sudo unzip LiberationMono.zip -d "$install_path/nerd-font"
sudo unzip Inconsolata.zip -d "$install_path/nerd-font"
sudo mv "$install_path/nerd-font/" "/usr/share/fonts/nerd-fonts"
sudo fc-cache -f -v

#Terminal
echo "Downloading st"
git clone "https://github.com/Grz3hu/st.git" "$install_path/st"
cd $install_path/st/ && ./compile && cd -

#Dmenu
echo "Downloading dmenu"
git clone "https://github.com/Grz3hu/dmenu.git" "$install_path/dmenu"
cd $install_path/dmenu/ && ./compile && cd -

#picom
echo "Downloading ibhagwan's picom fork"
git clone --single-branch --branch next-rebase --depth=1 https://github.com/ibhagwan/picom "$install_path/dmenu"
cd $install_path/picom/
git submodule update --init --recursive
meson --buildtype=release . build
ninja -C build
sudo ninja -C build install
cd -

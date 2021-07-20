#!/bin/bash
dep=(gcc git unzip libxft-dev libxinerama-dev libx11-xcb-dev libxcb-res0-dev)
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

echo "Downloading dwm"
git clone "https://github.com/Grz3hu/dwm.git" "$install_path/dwm"
cd $install_path/dwm/ && ./compile && cd -

echo "Installing dwm"
cp .xinitrc ~/.xinitrc
ln -s ~/.xinitrc ~/.xsession
chmod 755 ~/.xinitrc
sudo cp custom-dwm.desktop /usr/share/xsessions/custom-dwm.desktop

echo "Download nerdfonts"
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Mononoki.zip
unzip Mononoki.zip -d "$install_path/nerd-font"
sudo mv "$install_path/nerd-font/" "/usr/share/fonts/nerd-fonts"
sudo fc-cache -f -v

echo "Downloading st"
git clone "https://github.com/Grz3hu/st.git" "$install_path/st"
cd $install_path/st/ && ./compile && cd -

echo "Downloading dmenu"
git clone "https://github.com/Grz3hu/dmenu.git" "$install_path/dmenu"
cd $install_path/dmenu/ && ./compile && cd -

#TODO: Status bar scripts installation
#echo "Downloading statusbar scripts"
#git clone "https://github.com/Grz3hu/st.git" "$install_path/st"
#cd $install_path/st/ && ./compile

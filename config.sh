# SCRIPT FOR R AND NVIM INSTALLATION
#
# Bolean values for switching-off installation
# of particular components, for debugging purpouses.

Rinstall=true		#R 4.2 installlation
Nviminstall=false	#Nvim 0.8 installation
initconfig=false	#Nvim plugins configuration
Rlibs=true		#Installation of R libraries

# 1. APT UPDATEs
#
# NOTE: This part always run, and can't be switched off
# with bools at the top.
#
# This part contains some general apt installs
# that are either required for R/nvim functionality
# or make work easier
apt-get update
# Many popular UNIX tools are not preinstalled 
# in debian container
apt-get install curl -y
apt-get install git -y
apt-get install gpg -y
apt-get install apt-utils -y
# Nvimdependencies
apt-get install dialog
apt-get install libterm-readline-gnu-perl
# R extrnal dependencies
# Needed for R libraries to work
apt install cmake -y
apt install python3 -y
# 2. R INSTALLATION
#
# NOTE: Default R installation on Linux gives 3.8 version
# which is not compatible with many libraries, especially
# the more advanced one (i.e. Bioconductor libs). To upgrade
# R to the news version deb cran repo needs to be added to
# apt sources with approriate key.
#
# BUG: Currently  container has a problem with adding
# key for cran repo. It is possible to solve in running 
# container, thought.
if [ $Rinstall = true ]; then
    apt-get update
    apt-get install r-base r-base-dev -y
    apt-get install libatlas3-base -y
    # Adds CRAN repo on bullseye 
    # This step is needed to update R to 4.2
    # Add key for CRAN repo
    gpg --keyserver keyserver.ubuntu.com --recv-key '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7'
    gpg --armor --export '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7' | tee /etc/apt/trusted.gpg.d/cran_debian_key.asc # THIS LINE HAD A BUG

    echo "deb http://cloud.r-project.org/bin/linux/debian bullseye-cran40/" >> /etc/apt/sources.list
    apt-get update && apt-get upgrade -y
fi
# AFTER THIS STEP YOUR R SHOULD BE UPGRADED TO 4.2

# 3. NVIM INSTALLATION

#NOTE: nvim apt installation results in
#NVIM 0.3 installation, whereas at least 0.8
#is required for most plugins to works
#
# Installation of nvim
# NOTE: Running directly nvim.appimage, without its extration
# results in error. This was checked on MX, AWS cloud and 
# Deb container. Because of that I suggest to always extrat the image.
if [ $Nviminstall = true ]; then
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    chmod u+x nvim.appimage
    ./nvim.appimage --appimage-extract
    ./squashfs-root/AppRun --version
    #Exposing nvim globally.
    mv squashfs-root /
    ln -s /squashfs-root/AppRun /usr/bin/nvim
fi

# 4.NVIM PLUGINS 
#
#
if [ $initconfig = true ]; then
    # Installs Linux flatpak version
    sh -c 'curl -fLo "/root/.local/share"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    # Creates .config/nvim and empty init.vim
    mkdir ~/.config ~/.config/nvim
    touch ~/.config/nvim/init.vim
    # Modifies init.vim global variables
    echo "let g:plugged_home = '~/.config/nvim'" >> ~/.config/nvim/init.vim
    echo "let g:R_path = '/usr/bin/R'" >> ~/.config/nvim/init.vim
    echo "let g:R_assign = 1" >> ~/.config/nvim/init.vim
    echo "let R_auto_omni = 0" >> ~/.config/nvim/init.vim
    echo "  " >> ~/.config/nvim/init.vim
    # Installs plugins from nvim`
    echo "call plug#begin()" >> ~/.config/nvim/init.vim
    echo "Plug 'https://github.com/junegunn/vim-github-dashboard.git'"  >> ~/.config/nvim/init.vim
    echo "Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'" >> ~/.config/nvim/init.vim
    echo "Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }" >> ~/.config/nvim/init.vim
    echo "Plug 'tpope/vim-fireplace', { 'for': 'clojure' }" >> ~/.config/nvim/init.vim
    echo "Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }" >> ~/.config/nvim/init.vim
    echo "Plug 'fatih/vim-go', { 'tag': '*' }" >> ~/.config/nvim/init.vim
    echo "Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }" >> ~/.config/nvim/init.vim
    echo "Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }" >> ~/.config/nvim/init.vim

    #R RELATED PLUGS:
    echo "Plug 'gaalcaras/ncm-R'" >> ~/.config/nvim/init.vim
    echo "Plug 'jalvesaq/colorout'">> ~/.config/nvim/init.vim
    echo "Plug 'jalvesaq/Nvim-R'" >> ~/.config/nvim/init.vim
    echo "Plug 'gaalcaras/ncm-R'" >> ~/.config/nvim/init.vim
    echo "Plug 'jalvesaq/R-Vim-runtime'" >> ~/.config/nvim/init.vim

    echo "call plug#end()" >> ~/.config/nvim/init.vim
    echo ':set number' >> ~/.config/nvim/init.vim
    echo ':set relativenumber' >> ~/.config/nvim/init.vim
    echo ':set clipboard+=unnamedplus "Yanking between windows' >> ~/.config/nvim/init.vimv
    echo ':set shiftwidth=4 "Intendentation' >> ~/.config/nvim/init.vim
    echo "PLUG INSTALL >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    nvim +PlugInstall +q
    nvim test

fi

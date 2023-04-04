# This script contaings some general apt installs
# that are either required for R/nvim functionality
# or make work easier
apt update

apt install curl -y
apt install git -y
apt install gpg -y

# R extrnal dependencies
apt install cmake -y

# Run other scripts
bash Rconfig.sh
bash nvimconfig.sh

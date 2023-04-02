# Script for intalling R
apt get update
apt install r-base r-base-dev -y
apt install libatlas3-base -y
# Adds CRAN repo on bullseye 
# This step is needed to update R to 4.2
echo "deb http://cloud.r-project.org/bin/linux/debian bullseye-cran40/" >> /etc/apt/sources.list
# Add key for CRAN repo
gpg --armor --export '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7' | \
tee /etc/apt/trusted.gpg.d/cran_debian_key.asc
apt update && apt upgrade -y


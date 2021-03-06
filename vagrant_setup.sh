# !/bin/bash

# Updates
sudo apt-get -y update
sudo apt-get -y upgrade

sudo apt-get -y install python3-pip
sudo apt-get -y install tmux
sudo apt-get -y install gdb gdb-multiarch
sudo apt-get -y install unzip
sudo apt-get -y install foremost
sudo apt-get -y install emacs24
sudo apt-get -y install git
sudo apt-get -y install socat
sudo apt-get -y install libssl-dev

# Exec 32 bit
sudo dpkg --add-architecture i386
sudo apt-get -y update
sudo apt-get -y install libc6:i386 libncurses5:i386 libstdc++6:i386 libc6-dev-i386

# QEMU with MIPS/ARM - http://reverseengineering.stackexchange.com/questions/8829/cross-debugging-for-mips-elf-with-qemu-toolchain
sudo apt-get -y install qemu qemu-user qemu-user-static
sudo apt-get -y install 'binfmt*'
sudo apt-get -y install libc6-armhf-armel-cross
sudo apt-get -y install debian-keyring
sudo apt-get -y install debian-archive-keyring
sudo apt-get -y install emdebian-archive-keyring
tee /etc/apt/sources.list.d/emdebian.list << EOF
deb http://mirrors.mit.edu/debian squeeze main
deb http://www.emdebian.org/debian squeeze main
EOF
sudo apt-get -y install libc6-mipsel-cross
sudo apt-get -y install libc6-arm-cross
mkdir /etc/qemu-binfmt
ln -s /usr/mipsel-linux-gnu /etc/qemu-binfmt/mipsel 
ln -s /usr/arm-linux-gnueabihf /etc/qemu-binfmt/arm
rm /etc/apt/sources.list.d/emdebian.list
sudo apt-get update

cd /home/vagrant
mkdir tools
cd tools

# Install radare2
git clone https://github.com/radare/radare2
cd radare2
./sys/install.sh

# Install binwalk
cd /home/vagrant/tools
git clone https://github.com/devttys0/binwalk
cd binwalk
sudo python setup.py install
                                                                             
# Install Firmware-Mod-Kit
sudo apt-get -y install git build-essential zlib1g-dev liblzma-dev python-magic
cd /home/vagrant/tools
wget https://firmware-mod-kit.googlecode.com/files/fmk_099.tar.gz
tar xvf fmk_099.tar.gz
rm fmk_099.tar.gz
cd fmk_099/src
./configure
make

# Uninstall capstone
sudo pip2 uninstall capstone -y

# Install correct capstone
cd /home/vagrant/tools/
git clone https://github.com/aquynh/capstone
cd capstone
sudo ./make.sh install
sudo python ./bindings/python/setup.py install

# Personal config
cd /home/vagrant 
git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
~/.bash_it/install.sh
cd .bash_it/themes/
export BASH_IT_THEME='Bakke'


# Install Angr
cd /home/vagrant
cd tools
sudo apt-get -y install python-dev libffi-dev build-essential virtualenvwrapper
sudo pip install virtualenv
virtualenv angr
source angr/bin/activate
sudo pip install angr --upgrade

# gdbpeda
cd /home/vagrant/tools
git clone https://github.com/longld/peda.git ~/peda
echo "source ~/peda/peda.py" >> ~/.gdbinit

# z3
cd /home/vagrant/tools
git clone https://github.com/Z3Prover/z3
cd z3
virtualenv venv
source venv/bin/activate
python scripts/mk_make.py --python
cd build
make
sudo make install

# ROPgadget
cd /home/vagrant/tools
git clone https://github.com/JonathanSalwan/ROPgadget
cd ROPgadget
sudo python setup.py install

# Pwntools
sudo pip install pwntools

# pintool
cd /home/vagrant/tools
mkdir pintool
cd pintool
wget http://software.intel.com/sites/landingpage/pintool/downloads/pin-3.0-76991-gcc-linux.tar.gz

# unicorn-engine
sudo apt-get -y install pkg-config
sudo apt-get -y install libglib2.0
git clone https://github.com/unicorn-engine/unicorn
cd unicorn
UNICORN_ARCHS="arm aarch64 x86" ./make.sh
./make.sh
UNICORN_QEMU_FLAGS="--python=/usr/bin/python" ./make.sh
sudo ./make.sh install


tar zxf pin-3.0-76991-gcc-linux.tar.gz
rm pin-3.0-76991-gcc-linux.tar.gz
cd pin-3.0-76991-gcc-linux
cd source/tools/ManualExamples
make obj-intel64/inscount0.so TARGET=intel64
make obj-ia32/inscount0.so TARGET=ia32

cd /home/vagrant/tools/pintool
git clone https://github.com/r00ta/pintool.git

#install dex2jar
cd /home/vagrant/tools
git clone https://github.com/pxb1988/dex2jar.git

#install jadax
cd /home/vagrant/tools
https://github.com/skylot/jadx

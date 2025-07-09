# Tools installation directives
Here are the installation instruction for all needed tools.
Tested on Ubuntu 16.04, with 4.15.0 kernel.

## Generic tools
```
sudo apt-get update
sudo apt-get install g++ cmake libboost-dev python-dev libglib2.0-dev libpixman-1-dev liblua5.2-dev swig libcap-dev libattr1-dev default-jdk
```

If using Ubuntu higher than 14.04:
```
sudo apt-get install python-software-properties
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:ubuntu-toolchain-r/test
sudo apt-get update
sudo apt-get install gcc-4.8
sudo apt-get install g++-4.8
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 50
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 50
```

## SystemC library
```
wget -O systemc-2.3.0a.tar.gz http://www.accellera.org/images/downloads/standards/systemc/systemc-2.3.0a.tar.gz 
tar -xzvf systemc-2.3.0a.tar.gz
cd systemc-2.3.0a
sudo mkdir -p /usr/local/systemc/systemc-2.3.0/
mkdir objdir
cd objdir
../configure --prefix=/usr/local/systemc/systemc-2.3.0 --enable-cxx11
make
sudo make install
```

## Perl packages
```
wget -O YAML-1.24.tar.gz http://search.cpan.org/CPAN/authors/id/T/TI/TINITA/YAML-1.24.tar.gz 
tar -xzvf YAML-1.24.tar.gz 
cd YAML-1.24
perl Makefile.PL
make
sudo make install
```
wget -O IO-Tee-0.65.tar.gz http://search.cpan.org/CPAN/authors/id/N/NE/NEILB/IO-Tee-0.65.tar.gz 
tar -xzvf IO-Tee-0.65.tar.gz
cd IO-Tee-0.65
perl Makefile.PL
make
sudo make install
cpan -i Capture::Tiny [Note: Fix nvdla.org for it]
cpan -i XML::Simple [Note: Fix nvdla.org for it]
```
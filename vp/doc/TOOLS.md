# Tools installation
Here are the installation steps for all needed tools.<br>
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

Download the archive from the website, ad extract:
```
wget -O systemc-2.3.0a.tar.gz http://www.accellera.org/images/downloads/standards/systemc/systemc-2.3.0a.tar.gz 
tar -xzvf systemc-2.3.0a.tar.gz
```


```
cd systemc-2.3.0a
sudo mkdir -p /usr/local/systemc/systemc-2.3.0/
```

Configure build steps, setting the installation directory (e.g. "/usr/local/systemc/systemc-2.3.0"):
```
mkdir objdir
cd objdir
../configure --prefix=<inst_dir>

Build and install:
```
make
sudo make install
```

## Perl packages

YAML package:
```
wget -O YAML-1.24.tar.gz http://search.cpan.org/CPAN/authors/id/T/TI/TINITA/YAML-1.24.tar.gz 
tar -xzvf YAML-1.24.tar.gz 
cd YAML-1.24
perl Makefile.PL
make
sudo make install
```

Tee package:
```
wget -O IO-Tee-0.65.tar.gz http://search.cpan.org/CPAN/authors/id/N/NE/NEILB/IO-Tee-0.65.tar.gz 
tar -xzvf IO-Tee-0.65.tar.gz
cd IO-Tee-0.65
perl Makefile.PL
make
sudo make install
```

Install last packages (Tiny and Simple) from Comprehensive Perl Archive Network:
```
cpan -i Capture::Tiny
cpan -i XML::Simple
```

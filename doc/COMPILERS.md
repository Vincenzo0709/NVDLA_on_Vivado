# Compilers installation and management
You need gcc/g++-4.8 both for sw and VP compilations.
```
sudo apt-get install gcc-4.8
sudo apt-get install g++-4.8
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 50
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 60
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 50
sudo update-alternatives --install /usr/bin/gcc g++ /usr/bin/g++-5 60
```

To select the proper compilers:
```
sudo update-alternatives --config gcc
```
Then select the number corresponding to gcc-4.8 and press enter.
```
sudo update-alternatives --config g++
```
Then select the number corresponding to g++-4.8 and press enter.
# Requirements:
This config also relies on the installation of the referenced LSPs.

Install the following LSPs
```
lua_language_server
pyright
clangd
```

## lua_language_server
Build it from source:
```
sudo apt update
sudo apt install -y ninja-build build-essential unzip curl git
git clone https://github.com/LuaLS/lua-language-server
cd lua-language-server
git submodule update --init --recursive
./make.sh
echo 'export PATH="$HOME/lua-language-server/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

## pyright
Install via pip:
```
pip install pyright
```
This should be done in the globall managed environment.

## clangd
Install via apt:
```
sudo apt update
sudo apt install clangd
which clangd
```

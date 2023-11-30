# Building the game

Step 1. [Install git-scm](https://git-scm.com/downloads) if you don't have it already.

Step 2. [Install Haxe](https://haxe.org/download/)

Step 3. [Install HaxeFlixel](https://haxeflixel.com/documentation/install-haxeflixel/)

Step 4. Run these commands to install the libraries required:

```
haxelib install hmm
haxelib run hmm install
```

## IMPORTANT: use the latest stable polymod not git please

Dependencies for compiling:

## Windows

Install Visual Studio Community 2019, and while installing instead of selecting the normal options, only select these components in the 'individual components' instead (or the closest equivalents).

```txt
* MSVC v142 - VS 2019 C++ x64/x86 build tools
* Windows 10 SDK (Latest)
```

## Linux (if you decide to try and use hxCodec while compiling which requires changes at the moment)

In your package manager, install the following packages:

````sh
sudo apt-get install libvlc-dev
sudo apt-get install libvlccore-dev
sudo apt-get install vlc-bin
sudo apt-get install luajit
``` (APT Example)

```sh
sudo pacman -S vlc
sudo pacman -S luajit
``` (Pacman Example)

Step 5. Run `lime test [platform]` in the project directory while replacing '[platform]' with your build target (usually `html5`, `windows`, `linux`, `mac`, or whatever platform you are building for).
````

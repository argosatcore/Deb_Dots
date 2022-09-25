# Deb_Dots
⢀⣴⠾⠻⢶⣦⠀  
⣾⠁⢠⠒⠀⣿⡁  
⢿⡄⠘⠷⠚⠋⠀  
⠈⠳⣄⠀⠀⠀

A collection of my experiences with Linux in the form of dot files. These dotfiles were started with a minimal installation of Debian 10 Buster on 09/10/2020. The layout for this README.md as well as the contents of this dotfiles were heavily influenced by those of [Spencer Tipping](https://github.com/spencertipping/dotfiles) and [Conner McDaniel](https://github.com/connermcd/dotfiles). Now that I have been running GNU/Linux for quite some time, I feel that my configurations have become mature enough to be of the interest of other people. Just as the people mentioned above made theirs available -and in the spirit of GNU-, so do I. Reader, may you find something useful in them. 


---

## Bootstrap

 The purpose of this repository is to contain the bare minimum of what is necessary to quickly bootstrap my current sensibilities on a Linux system. At its core, there are two assumptions: 
 
 0. The use of the [Debian GNU/Linux Operating System](https://www.debian.org/), either Debian _Stable_ or Debian [Sid](https://wiki.debian.org/DebianUnstable) :skull:. The script assumes you are on a Debian Stable or Debian Sid system and has not been tested on other distributions. Depending on your distribution, the packages listed in the script may not be available or have a different name. If this is the case, modify the script accordingly, otherwise, it ***will fail***. 
 1. The implementation of the [Wayland protocol](https://wayland.freedesktop.org/) through the use of the [Sway](https://swaywm.org/) tiling Wayland compositor or through the [GNOME](https://www.gnome.org/) desktop environment. 
       
To start the bootstrap script follow this steps:

0. Use `wget` to download and run the bootstrapping script called `debstrap.sh`, which is located inside the `Debstrap` directory within this repository.  
        
        wget https://raw.githubusercontent.com/argosatcore/Deb_Dots/main/Debstrap/debstrap.sh

1. Make it executable.

        chmod +x debstrap.sh
        
2. Deploy `debstrap.sh`. To customize your bootstrap installation, answer debstrap.sh's questions at your discretion. There are twelve questions total, which can be found at the final section of the script, titled ["Debstrap Options"](./Debstrap/debstrap.sh/#L238).

        ./debstrap.sh

3. Profit:

| Sway | GNOME |
| ---  | ---   |   
| <img src="https://user-images.githubusercontent.com/64110504/146632072-aabfe18b-f28b-4a3d-85ee-8509fca82092.png" />| <img src="https://user-images.githubusercontent.com/64110504/145700568-8996890a-4ab5-4618-94b1-eaba17196b79.png" /> |

---

## Unexpected features you get right out of the gate

| Feature                                                                                                                                                                                                                                                                                  | Sway | GNOME       |
| ---                                                                                                                                                                                                                                                                                      | ---  | ---         |
| **[Bash's vim mode](./.bashrc/#L21):** When in _normal_ mode, you will see a `-` at the beginning of your prompt. When in _insert_ mode, you will see a `+` at the beginning of the prompt.                                                                                              | Yes  | Yes         |
| **[Change directories without using the `cd` command](./.bashrc/#L18):** Just type the name of the directory to move into it.                                                                                                                                                                                                                            | Yes  | Yes         |
| **[Bash completion is no longer case sensitive](./.inputrc/#L19):** No more wasted time pressing keys to get upper case letters.                                                                                                                                                                                                                       | Yes  | Yes         |
| **[Neovim as a pager for man pages](./.config/environment.d/envvars.conf/#L5):** Because man pages deserve better.                                                                                                                                                                                                                                       | Yes  | Yes         |
| **[Caps Lock key is swapped with Esc key](./.config/sway/config/#L97):** If you are a vim user (or someone that just uses the crap out of the Esc key), you know how handy this is. If you don't want this, just change it in the input configuration in Sway's config file.                                                                                | Yes  | Yes         |
| **[Mouse set for left handed people](./.config/sway/config/#L98):** If you happen to be part of the other 90% of the human population, just change the input configuration in Sway's config file or in GNOME's mouse settings.                                                                                                                                     | Yes  | Yes         |
| **[Ridiculously fast key repeat rate](./.config/sway/config/#L102):** Like, really fast.                                                                                                                                                                                                                                                                                                          | Yes  | Yes         |
| **[Alternate Keyboard layout set to Latin American](./.config/sway/config/#L99):** It is set as a second option and can be toggled by pressing `Super`+`Space`.                                                                                                                                                                                                                                                                        | Yes  | Yes         |
| **[Gapless single client](./.config/sway/config/#L344):** If there is only one client on a given workspace, gaps and borders will be disabled. As soon as another client is launched on the same workspace, gaps and borders will be activated.                                                                                                                                                                                     | Yes  | Unnecessary |

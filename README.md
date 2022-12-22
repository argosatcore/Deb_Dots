# ⚠️ DEPRECATION NOTICE ⚠️
## In the spirit of supporting truly free/libre code hosting plaforms and in oppostion to monopolisitc practices, I have migrated my configuration files over to [Codeberg](https://codeberg.org/). If you are interested in tracking their changes, you can find my dotfiles at: https://codeberg.org/argosatcore
## I will keep this dotfiles here for archival purposes, but they will not be updated any more. See you on the other side.

# Deb_Dots
⢀⣴⠾⠻⢶⣦⠀  
⣾⠁⢠⠒⠀⣿⡁  
⢿⡄⠘⠷⠚⠋⠀  
⠈⠳⣄⠀⠀⠀

A collection of my experiences with Linux in the form of dot files, started with a minimal installation of Debian 10 Buster on 2020-10-09. The contents of this dotfiles were heavily influenced by those of [Spencer Tipping](https://github.com/spencertipping/dotfiles) and [Conner McDaniel](https://github.com/connermcd/dotfiles). Just as the people mentioned above made theirs available -and in the spirit of GNU-, so do I.


---

## Bootstrap

 The purpose of this repository is to contain the bare minimum of what is necessary to quickly bootstrap my current sensibilities on a Linux system. At its core, there are two assumptions: 
 
 0. The use of the [Debian GNU/Linux Operating System](https://www.debian.org/), either Debian _Stable_ or Debian [Sid](https://wiki.debian.org/DebianUnstable) :skull:. The script assumes you are on a Debian Stable or Debian Sid system and has not been tested on other distributions. Depending on your distribution, the packages listed in the script may not be available or have a different name. If this is the case, modify the script accordingly, otherwise, it ***will fail***. 
 1. The implementation of the [Wayland protocol](https://wayland.freedesktop.org/) through the use of the [Sway](https://swaywm.org/) tiling Wayland compositor or through the [GNOME](https://www.gnome.org/) desktop environment.

To start the bootstrap script follow this steps:

0. Use `wget` to download and run the bootstrapping script called `debstrap.sh`, which is located inside the `Debstrap` directory within this repository.  

        wget https://raw.githubusercontent.com/argosatcore/Deb_Dots/main/Debstrap/debstrap.sh

1. Make `debstrap.sh` executable and deploy it. To customize your bootstrap installation, answer debstrap.sh's questions at your discretion. There are twelve questions total, which can be found at the final section of the script, titled ["Debstrap Options"](./Debstrap/debstrap.sh/#L239).

        chmod +x debstrap.sh
        ./debstrap.sh

3. Profit:

![Screenshot from 2022-12-16 14-59-04](https://user-images.githubusercontent.com/64110504/208188143-ea4d417b-9220-4e54-bf10-495bfe5d07aa.png)

---

## Unexpected features you get right out of the gate

| Feature                                                                                                                                                                                                                                                                                                                                                | Sway | GNOME       |
| ---                                                                                                                                                                                                                                                                                                                                                    | ---  | ---         |
| **[Bash's vim mode](./.bashrc/#L21):** When in _normal_ mode, you will see a `-` at the beginning of your prompt. When in _insert_ mode, you will see a `+` at the beginning of the prompt.                                                                                                                                                         | Yes  | Yes         |
| **[APT's fuzzy powers](./.bash_functions.sh/#L102):** To take a look at Debian's gargantuan repositories, type `lookapt`, then type the name of the program you want and press `Space` to obtain information about said package. You can also type `debcrawler` to install Debian packages with the same search functionality as `lookapt`.           | Yes  | Yes         |
| **[Open files with `fzf`](./.bash_functions.sh/#L64):** Type `fo` to search for and open a given file on your system. This will use your `mimeapps.list' file to decide which program will be used to open a given file type.                                                                                                                                                                                                                                                                                     | Yes  | Yes         |
| **[Change directories without using the `cd` command](./.bashrc/#L18):** Just type the name of the directory to move into it.                                                                                                                                                                                                                       | Yes  | Yes         |
| **[Bash completion is no longer case sensitive](./.inputrc/#L19):** No more wasted time pressing keys to get upper case letters.                                                                                                                                                                                                                       | Yes  | Yes         |
| **[Neovim as a pager for man pages](./.config/environment.d/envvars.conf/#L5):** Because man pages deserve better.                                                                                                                                                                                                                                     | Yes  | Yes         |
| **[Caps Lock key is swapped with Esc key](./.config/sway/config/#L97):** If you are a vim user (or someone that just uses the crap out of the Esc key), you know how handy this is. If you don't want this, just change it in the input configuration in Sway's config file.                                                                   | Yes  | Yes         |
| **[Mouse set for left handed people](./.config/sway/config/#L98):** If you happen to be part of the other 90% of the human population, just change the input configuration in Sway's config file or in GNOME's mouse settings.                                                                                                                      | Yes  | Yes         |
| **[Ridiculously fast key repeat rate](./.config/sway/config/#L102):** Like, really fast.                                                                                                                                                                                                                                                               | Yes  | Yes         |
| **[Gapless single client](./.config/sway/config/#L344):** If there is only one client on a given workspace, gaps and borders will be disabled. As soon as another client is launched on the same workspace, gaps and borders will be activated.                                                                                             | Yes  | Unnecessary |

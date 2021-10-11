<img src="https://user-images.githubusercontent.com/64110504/125571508-fc53d41f-a7e3-41c0-8a00-e6a6f8b04768.png" width="30%" align="left" />
<h1 align="left">Argos's Debian GNU/Linux Dot Files<sup>1</sup> </h1>  
<p align="left">A collection of my experiences with Linux in the form of dot files. These dotfiles were started with a minimal installation of Debian 10 Buster on 10/10/2020. It was in Debian that I found a sanctuary in the midst of this chaotic world.</p>

 \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_
   
<p align="left">1. The layout for this README.md was heavily influenced by those of <a href="https://github.com/spencertipping/dotfiles">Spencer Tipping</a> and <a href="https://github.com/dylanaraps/pure-sh-bible">Dylan Araps.</a></p>

<h2 align="left">Table of Contents</h2>

- [Introduction](#introduction)
- [Bootstrap](#bootstrap)
- [Programs referenced by these configs](#programs-referenced-by-these-configs)
- [Unexpected features you get right out of the gate](#unexpected-features-you-get-right-out-of-the-gate)
- [Sway-specific](#sway-specific)
- [Miscellaneous](#miscellaneous)

---

## Introduction

 The purpose of this repository is to contain the bare minimum of what is necessary to quickly bootstrap my current sensibilities on a Linux system. At its core, there are two assumptions: 
 
 1. The use of the [Debian GNU/Linux Operating System](https://www.debian.org/), either Debian _Stable_ or Debian [Sid](https://wiki.debian.org/DebianUnstable) :skull:.<sup>2</sup>
 2. The implementation of the [Wayland protocol](https://wayland.freedesktop.org/) through the use of the [Sway](https://swaywm.org/) tiling Wayland compositor or through the [Gnome desktop environment](https://www.gnome.org/). 
   
   \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_
   
2. If you are aware of the risks and responsibilities that using Debian's unstable branch entail and still wish to go down the Sid route, make sure to replace your apt sources with the following lines:

       deb http://deb.debian.org/debian unstable main contrib non-free
       deb-src http://deb.debian.org/debian unstable main contrib non-free
         
      Then update your sources and upgrade to Sid:
         
       sudo apt update && sudo apt full-upgrade          
       
 ---
    
## Bootstrap
 
The following steps assume that you are on a running Debian Stable or Debian Sid system. If you are running any Linux distribution other than Debian (this also includes Debian-based distributions), **make sure to double-check that the packages listed in the bootstrapping script are alvailable in your distribution's repositories, otherwise, the script _will_ fail**. 
 
1. In order to bootstrap these dot files, install and use `wget` to download and run the bootstrapping script called `debstrap.sh`, which is located inside the `Debstrap` directory within this repository. To customize your bootstrap installation, answer debstrap.sh's questions at your discretion. To deploy the script, use the following commands:
       
        sudo apt install wget
        
        wget https://raw.githubusercontent.com/argosatcore/Deb_Dots/main/Debstrap/debstrap.sh
        
        ./debstrap.sh
       
2. Profit:

| Sway | Gnome |
| --- | --- |   
| <img src="https://user-images.githubusercontent.com/64110504/128617437-a77eb588-b4a4-46a3-9b04-d22ee3695566.png" />| <img src="https://user-images.githubusercontent.com/64110504/133880720-6270bd22-4b51-487e-bf3e-55aac56a5b99.png" /> |

---

## Programs referenced by these configs 
All of which are `apt install`able on Debian:

| Program         | Description                                                                           |
| ---             | ---                                                                                   |
| `foot`          | Wayland native minimalist terminal emulator.                                          |
| `gammastep`     | Screen temperature manager.                                                           |
| `gnome`         | Wayland desktop environment.                                                          |
| `grimshot`      | Wayland native screenshot tool.                                                       |
| `mako-notifier` | Wayland native notification daemon.                                                   |
| `nautilus`      | File manager.                                                                         |
| `neovim`        | Text editor.                                                                          |
| `swaybg`        | Wayland native wallpaper utility.                                                     | 
| `swaylock`      | Wayland native screen locker.                                                         | 
| `sway`          | Wayland compositor.                                                                   | 
| `tmux`          | Terminal multiplexer.                                                        | 
| `vim-gtk`       | (Neo)Vim's clipboard integration.                                                     | 
| `waybar`        | Wayland native panel.                                                                 | 
| `wdisplays`     | Wayland native graphical tool for configuring displays.                               | 
| `wlogout`       | Wayland session menu.                                                                 |
| `wofi`          | Wayland native application launcher, window switcher, command executor and many more. |

---

## Unexpected features you get right out of the gate

### General:

- **[Bash's vim mode](./.bashrc/#L33):** When in _normal_ mode, you will see a `-` at the beginning of your prompt. When in _insert_ mode, you will see a `+` at the beginning of the prompt.  
- **[Change directories without using the `cd` command](./.bashrc/#L15):** Just type the name of the directory to move into it. 
- **[Bash completion is no longer case sensitive](./.inputrc/#L19):** No more wasted time pressing keys to get upper case letters.
- **[Neovim as a pager for man pages](./.bashrc/#L10):** Because man pages deserve better.

### Sway-specific:

- **[Caps Lock key is swapped with Esc key](./.config/sway/config/#L97):** If you are a vim user (or someone that just uses the crap out of the Esc key), you know how handy this is. If you don't want this, just change it in the input configuration in Sway's config file.
- **[Gapless single client](./.config/sway/config/#L337):** If there is only one client on a given workspace, gaps and borders will be disabled. As soon as another client is launched on the same workspace, gaps and borders will be activated.
- **[Mouse set for left handed people](./.config/sway/config/#L98):** If you happen to be part of the other 90% of the human population, just change the input configuration in Sway's config file. 
- **[Ridiculously fast key repeat rate](./.config/sway/config/#L102):** Like, really fast.
- **[Keyboard layout set to Latin American](./.config/sway/config/#L99):** Unless you need to type Spanish accents, you might want to take a look at Sway's config file and chage the keyboard layout to your preferred one. Us-International is set as a second option and can be toggled by pressing `Super`+`Space`. 

### Keybindings: 
- `Super`+`Shift+c`: reload Sway.
- `Super`+`Shift`+`e`: exit Wayland session.
- `Alt`+`Shift`+`x`: lock screen.
- `Super`+`Shift`+`minus`: hide/unhide scratchpad.
- `Super`+`PageUp`: switch to the next workspace. If there is no next workspace occupied, it will automatically create a new one.
- `Super`+`PageDown`: switch to the previous workspace. If there is no previously occupied workspace, it will automatically create a new one.
- `Super`+`x`: toggle Waybar on/off.
- `Super`+`Shift`+`b`: toggle window border on/off.
- `Super`+`(1,2,3,4,5,6,7,8,9,0)`: Switch to workspace 1-10.
- `Super`+`Shitft`+`(1,2,3,4,5,6,7,8,9,0)`: Move an application to workspace 1-10.
- `Super`+`Space`: Switch keyboard layout. Options are: Latin American (default) and US-International.

### Windows:
- `Super`+`q`: close.
- `Super`+`f`: fullscreen. 
- `Super`+`Escape`: toggle floating. Remember, `Caps Lock` now works as `Escape` and viceversa. 
- `Super`+`(h,j,k,l)`: change the selection of a window in a given direction.
- `Super`+`Alt`+`(h,j,k,l)`: swap focused window with any window in a given direction.
- `Super`+`Shift`+`(h,j,k,l)`: move window in a given direction.
- `Super`+`w`: tab windows.
- `Super`+`s`: stack windows.
- `Super`+`e`: split tabbed or stacked windows.
- `Alt`+`Tab`: switch focus between tiling and floating areas.

### Mouse:
- `Super`+`Click1`: move window.
- `Super`+`Click2`: resize window.

### Run:
- `Super`+`Return`: run a terminal.
- `Super`+`i`: run firefox.
- `Super`+`n`: run nautilus.
- `Super`+`d`: run wofi as an application launcher.
- `Super`+`Tab`: run wofi as a window switcher.
- `Super`+`Shift`+`q`: run wlogout. 

---

## Miscellaneous

### Custom terminal palette: Linoleum
Since none of the existing colour palettes matched my sensibilities, I set out to create the ultimate palette that would combine both a beautiful arrangement of colours and a pragmatic approach to legibility. The result of this is _Linoleum_. Its name comes from the contraction of **Lin**- as in Linux and -**oleum**, from the latin olĕum, as in oil painting, a technology that played a key role in the artistic vision deployed by artists since the Renaissance. It is also the name of the material used to make floor coverings.

<img src="https://user-images.githubusercontent.com/64110504/133869339-90cde755-eb30-4a55-9918-e27b2127cd64.png" width="90%" />

This is how it looks in `gnome-terminal` while running `neovim`:

<img src="https://user-images.githubusercontent.com/64110504/133869362-3cd3d333-899d-4ae2-8462-d67fdb244e06.png" width="60%" />

### Color Code:

| Palette Entry    | Color Code  |
| ---              | ---         |
| `Foreground`     |   #DEDEDE   |
| `Background`     |   #1B1B1B   |
| `Black`          |   #414868   |
| `Red`            |   #E27373   |
| `Green`          |   #A5C261   |
| `Yellow`         |   #FFBA7B   |
| `Blue`           |   #6DA0C0   |
| `Magenta`        |   #C79EC4   |
| `Cyan`           |   #8CD0D3   |
| `White`          |   #DEDEDE   |
| `Bright black`   |   #777777   |
| `Bright red`     |   #FFA1A1   |
| `Bright green`   |   #BDDEAB   |
| `Bright yellow`  |   #FFDCA0   |
| `Bright blue`    |   #B1D8F6   |
| `Bright magenta` |   #FBDAFF   |
| `Bright cyan`    |   #99EBEE   |
| `Bright white`   |   #FFFFFF   |





<p align="center"><img src="https://user-images.githubusercontent.com/64110504/117399092-f6a49d00-aebc-11eb-8b76-3ea4c12901b6.png" width="275px"></p>
<h1 align="center">Argos's Debian GNU/Linux Dot Files<sup>1</sup> </h1>  
<p align="center">A collection of my experiences with Linux in the form of dot files.</p><br><br>
   
## Table of Contents

- [Introduction](#introduction)
- [Unexpected features you get right out of the gate](#unexpected-features-you-get-right-out-of-the-gate)
- [Programs referenced by these configs](#programs-referenced-by-these-configs)
- [Handy keybindings](#handy-keybindings)

---

## Introduction

At the kernel of my computing milieu, there are two irreducible components: the [Debian GNU/Linux Operating System](https://www.debian.org/),<sup>2</sup>  as a solid foundation to build on, and the [Sway](https://swaywm.org/) Wayland compositor to manage what probably remains as both, the most common way of interacting with computers, and, simultaneously, one of its less examined aspects: the layout of the computing space.
 
   These dot files were started with a minimal Debian 10 Buster installation, so they should work with any Debian installation or Debian-based distribution. I use these dots on Debian, but I've made an effort to keep them as distribution agnostic as possible. I have deployed them succesfully on [Arch Linux](https://archlinux.org/) (don't take this as an endorsement) and on [Void Linux](https://voidlinux.org/) (you can take this as an endorsement).<sup>3</sup>
   
   \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_
   
1.  The layout for this README.md was heavely influenced by those of [Spencer Tipping](https://github.com/spencertipping/dotfiles) and [Dylan Araps](https://github.com/dylanaraps/pure-sh-bible). 

2. These dotfiles are currently being written on [Debian Sid](https://wiki.debian.org/DebianUnstable) :skull:. If you are aware of the risks and responsabilities that using Debian's unstable branch entail and still wish to go down the Sid route, make sure to replace your apt sources with the following lines:

       deb http://deb.debian.org/debian unstable main contrib non-free
       deb-src http://deb.debian.org/debian unstable main contrib non-free
         
      Then update your sources and upgrade to Sid:
         
       sudo apt update && sudo apt full-upgrade 
         
3.  They will work for the most part, but some adjustments are needed to make them work properly on these distributions. However, since you are already using either of these two distributions, I will assume that you will know how to adapt these dot files to your system.

 ---
 
![1](https://user-images.githubusercontent.com/64110504/119239423-20d59c00-bb06-11eb-9994-2f14c1b8249f.png)

## Unexpected features you get right out of the gate
- **Bash's vim mode:** When in _normal_ mode, you will see a `-` at the beginning of your prompt. When in _insert_ mode, you will see a `+` at the beginning of the prompt. 
- **Caps Lock key is swapped with Esc key:** If you are a vim user (or someone that just uses the crap out of the Esc key), you know how handy this is. If you don't want this, just change it in the input configuration in Sway's config file.
- **Mouse set for left handed people:** If you happen to be part of the other 90% of the human population, just change the input configuration in Sway's config file.  
- **Change directories without using the `cd` command:** Just type the name of the directory to move into it. 
- **Bash completion is no longer case sensitive:** No more wasted time pressing keys to get upper case letters.
- **Combined less and neovim as a pager for man pages:** Because man pages deserve better.
- **Keyboard layout set to Latin American:** Unless you need to type Spanish accents, you might want to take a look at Sway's config file and chage the keyboard layout to your preferred one. Us-International is set as a second option and can be toggled by pressing `Super+Space`. 
- **Gapless single client:** If there is only one client on a given workspace, gaps and borders will be disabled. As soon as another client is launched on the same workspace, gaps and borders will be activated.

## Programs referenced by these configs 
All of which are `apt install`able on Debian Sid:

| Program         | Descripton                                                                           |
| ---             | ---                                                                                  |
| `foot`          | Wayland native minimalist terminal emulator.                                         |
| `gammastep`     | Screen temperature manager.                                                          |
| `grimshot`      | Wayland native screeshoot tool.                                                      |
| `mako-notifier` | Wayland native notification daemon.                                                  |
| `nautilus`      | File manager.                                                                        |
| `neovim`        | Text editor.                                                                         |
| `swaybg`        | Wayland native wallpaper utility.                                                    |
| `swaylock`      | Wayland native screen locker.                                                        |
| `sway`          | Wayland compositor.                                                                  |
| `tmux`          | Persistent SSH shell sessions.                                                       |
| `vim-gtk`       | (Neo)Vim's clipboard integration.                                                    |
| `waybar`        | Sway's panel.                                                                        |
| `wdisplays`     | Wayland native graphical tool for configuring displays.                              |
| `wlogout`       | Wayland session menu.                                                                |
| `wofi`          | Wayland native application launcher, window switcher, commad executor and many more. |

## Handy keybindings 

### Sway:
- `Super+Shift+c`: reload Sway.
- `Super+Shift+e`: exit Wayland session.
- `Alt+Shift+x`: lock screen.
- `Super+Shit+minus`: hide/unhide scratchpad.
- `Super+PagUp`: switch to the next workspace. If there is no next workspace occupied, it will automatically create a new one.
- `Super+PageDown`: switch to the previous workspace. If there is no previously occupied workspace, it will automatically create a new one.
- `Super+x`: toggle Waybar on/off.
- `Super+Shift+b`: toggle window border on/off.
- `Super+(1,2,3,4,5,6,7,8,9,0)`: Switch to worspace 1-10.
- `Super+Shitft+(1,2,3,4,5,6,7,8,9,0)`: Move an application to workspace 1-10.
- `Super+Space`: Switch keyboard layout. Options are: Latin American (default) and US-International.

### Windows:
- `Super+q`: close.
- `Super+f`: fullscreen. 
- `Super+Escape`: toggle floating. Remember, `Caps Lock` now works as `Escape` and viceversa. 
- `Super+(h,j,k,l)`: change the selection of a window in a designated direction.
- `Super+(h,j,k,l)`: swap focused window with any window in a given direction.
- `Super+Shift+(h,j,k,l)`: move window in a designated direction.
- `Super+w`: tab windows.
- `Super+s`: stack windows.
- `Super+e`: split tabbed or stacked windows.
- `Alt+Tab`: switch focus between tiled and floating windows.

### Mouse:
- `Super+Click1`: move window.
- `Super+Click2`: resize window.

### Running things:
- `Super+Return`: run a terminal.
- `Super+i`: run firefox.
- `Super+n`: run nautilus.
- `Super+d`: run wofi as an application launcher.
- `Super+Tab`: run wofi as a window switcher.
- `Super+Shift+q`: run wlogout. 

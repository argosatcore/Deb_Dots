<h1 align="center"> AΛΣ · IXH · XAN </h1>

---

<img src=https://user-images.githubusercontent.com/64110504/161831556-1b248fb5-8bd2-4dcf-a618-8aaea4131198.png width="35%" align="left" />
<h1 align="left">Argos's Debian GNU/Linux Dot Files<sup>0</sup> </h1>  
<p align="left">A collection of my experiences with Linux in the form of dot files. These dotfiles were started with a minimal installation of Debian 10 Buster on 09/10/2020.</p>

 \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_
   
<sup>0.The layout for this README.md was heavily influenced by those of [Spencer Tipping](https://github.com/spencertipping/dotfiles) and [Dylan Araps](https://github.com/dylanaraps/pure-sh-bible).</sup>

&#x200B;


<h2 align="left">Table of Contents</h2>

- [Introduction](#introduction)
- [Bootstrap](#bootstrap)
- [Programs referenced by these configs](#programs-referenced-by-these-configs)
- [Unexpected features you get right out of the gate](#unexpected-features-you-get-right-out-of-the-gate)
- [Sway-specific](#sway-specific)

---

## Introduction

 The purpose of this repository is to contain the bare minimum of what is necessary to quickly bootstrap my current sensibilities on a Linux system. At its core, there are two assumptions: 
 
 0. The use of the [Debian GNU/Linux Operating System](https://www.debian.org/), either Debian _Stable_ or Debian [Sid](https://wiki.debian.org/DebianUnstable) :skull:.
 1. The implementation of the [Wayland protocol](https://wayland.freedesktop.org/) through the use of the [Sway](https://swaywm.org/) tiling Wayland compositor or through the [GNOME](https://www.gnome.org/) desktop environment. 
       
 ---
    
## Bootstrap
 
The script assumes you are on a Debian Stable or Debian Sid system and has not been tested on other distributions. Depending on your distribution, the packages listed in the script may not be available or have a different name. If the latter is the case, modify the script accordingly, otherwise, it is very likely to fail. 

1. Use`wget` to download and run the bootstrapping script called `debstrap.sh`, which is located inside the `Debstrap` directory within this repository.  
        
        wget https://raw.githubusercontent.com/argosatcore/Deb_Dots/main/Debstrap/debstrap.sh

2. Make it executable.

        chmod +x debstrap.sh
        
3. Deploy `debstrap.sh.`To customize your bootstrap installation, answer debstrap.sh's questions at your discretion. There are twelve questions total, which can be found at the final section of the script, titled "Debstrap Options".

        ./debstrap.sh

4. Profit:

| Sway | GNOME |
| ---  | ---   |   
| <img src="https://user-images.githubusercontent.com/64110504/146632072-aabfe18b-f28b-4a3d-85ee-8509fca82092.png" />| <img src="https://user-images.githubusercontent.com/64110504/145700568-8996890a-4ab5-4618-94b1-eaba17196b79.png" /> |

---

## Programs referenced by these configs 
All of which are `apt install`able on Debian _Stable_ -except for `swaylock`, which at the moment remains, unfortunately, exclusive to Sid-:

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
| `tmux`          | Terminal multiplexer.                                                                 | 
| `vim-gtk`       | (Neo)Vim's clipboard integration.                                                     | 
| `waybar`        | Wayland native panel.                                                                 | 
| `wdisplays`     | Wayland native graphical tool for configuring displays.                               | 
| `wlogout`       | Wayland session menu.                                                                 |
| `wofi`          | Wayland native highly configurable launcher.                                          |

---

## Unexpected features you get right out of the gate

| Feature | Sway | GNOME |    
| ---     | ---  | ---   |
| **[Bash's vim mode](./.bashrc/#L21):** When in _normal_ mode, you will see a `-` at the beginning of your prompt. When in _insert_ mode, you will see a `+` at the beginning of the prompt.  | Yes | Yes |
| **[Change directories without using the `cd` command](./.bashrc/#L18):** Just type the name of the directory to move into it. | Yes | Yes |
| **[Bash completion is no longer case sensitive](./.inputrc/#L19):** No more wasted time pressing keys to get upper case letters. | Yes | Yes |
| **[Neovim as a pager for man pages](./.config/environment.d/envvars.conf/#L5):** Because man pages deserve better. | Yes | Yes |
| **[Caps Lock key is swapped with Esc key](./.config/sway/config/#L97):** If you are a vim user (or someone that just uses the crap out of the Esc key), you know how handy this is. If you don't want this, just change it in the input configuration in Sway's config file. | Yes | Yes |
| **[Mouse set for left handed people](./.config/sway/config/#L98):** If you happen to be part of the other 90% of the human population, just change the input configuration in Sway's config file or in GNOME's mouse settings. | Yes | Yes |
| **[Ridiculously fast key repeat rate](./.config/sway/config/#L102):** Like, really fast. | Yes | Yes |
| **[Alternate Keyboard layout set to Latin American](./.config/sway/config/#L99):** It is set as a second option and can be toggled by pressing `Super`+`Space`. | Yes | Yes |
| **[Gapless single client](./.config/sway/config/#L344):** If there is only one client on a given workspace, gaps and borders will be disabled. As soon as another client is launched on the same workspace, gaps and borders will be activated. | Yes | No |

## Sway-specific:

### Sway Keybindings:

| Session | Windows | Mouse | Programs |
| ---     | ---     | ---   | ---      |
| `Super`+`Shift+c`: reload Sway. | `Super`+`q`: close. | `Super`+`Click1`: move window. | `Super`+`Return`: run a terminal. |
| `Super`+`Shift`+`e`: exit Wayland session. | `Super`+`f`: fullscreen. | `Super`+`Click2`: resize window. | `Super`+`i`: run firefox. |
| `Alt`+`Shift`+`x`: lock screen. | `Super`+`Escape`: toggle floating. Remember, `Caps Lock` now works as `Escape` and viceversa. | - | `Super`+`n`: run nautilus. |
| `Super`+`Shift`+`minus`: hide/unhide scratchpad. | `Super`+`(h,j,k,l)`: change the selection of a window in a given direction. | - | `Super`+`d`: run wofi as an application launcher. |
| `Super`+`PageUp`: switch to the next workspace. If there is no next workspace occupied, it will automatically create a new one. | `Super`+`Alt`+`(h,j,k,l)`: swap focused window with any window in a given direction. | - | `Super`+`Tab`: run wofi as a window switcher. |
| `Super`+`PageDown`: switch to the previous workspace. If there is no previously occupied workspace, it will automatically create a new one. | `Super`+`Shift`+`(h,j,k,l)`: move window in a given direction.| - | `Super`+`Shift`+`q`: run wlogout. |
| `Super`+`x`: toggle Waybar on/off. | `Super`+`w`: tab windows. | - | - |
| `Super`+`Shift`+`b`: toggle window border on/off. | `Super`+`s`: stack windows. | - | - |
| `Super`+`(1,2,3,4,5,6,7,8,9,0)`: Switch to workspace 1-10. | `Super`+`e`: split tabbed or stacked windows. | - | - |
| `Super`+`Shitft`+`(1,2,3,4,5,6,7,8,9,0)`: Move an application to workspace 1-10. | `Alt`+`Tab`: switch focus between tiling and floating areas. | - | - |
| `Super`+`Space`: Switch keyboard layout. Options are: Latin American (default) and US-International. | - | - | - |


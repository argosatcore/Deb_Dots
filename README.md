# Deb_Dots<sup>1</sup> 
⢀⣴⠾⠻⢶⣦⠀  
⣾⠁⢠⠒⠀⣿⡁⠀  
⢿⡄⠘⠷⠚⠋⠀  
⠈⠳⣄⠀

[![forthebadge](https://forthebadge.com/images/badges/powered-by-coffee.svg)](https://forthebadge.com)

---     

At the kernel of my computing milieu, there are two irreducible components: the [Debian GNU/Linux Operating System](https://www.debian.org/),<sup>2</sup>  as a solid foundation to build on, and the [Sway](https://swaywm.org/) Wayland compositor to manage what probably remains as both, the most common way of interacting with computers, and, simultaneously, one of its less examined aspects: the layout of the computing space.
 
   These dot files were started with a minimal Debian 10 Buster installation, so they should work with any Debian installation or Debian-based distribution. I use these dots on Debian, but I've made an effort to keep them as distribution agnostic as possible. I have deployed them succesfully on [Arch Linux](https://archlinux.org/) (don't take this as an endorsement) and on [Void Linux](https://voidlinux.org/) (you can take this as an endorsement).<sup>3</sup>

   If you find any of this useful, feel free to grab any part or all of it.
   
   \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_
   
1.  The layout for this README.md was heavely influenced by that of [Spencer Tipping](https://github.com/spencertipping/dotfiles). Also, he (along with some [contributors](https://github.com/spencertipping/ni/graphs/contributors)) created an amazing tool for data processing pipelines in bash called [**_`ni`_**](https://github.com/spencertipping/ni). You should definetively check it out.

2. These dotfiles are currently being written on [Debian Sid](https://wiki.debian.org/DebianUnstable) :skull:. If you wish to go down the Sid route, make sure to replace your apt sources with the following lines:

       deb http://deb.debian.org/debian unstable main contrib non-free
       deb-src http://deb.debian.org/debian unstable main contrib non-free
         
      Then update your sources and upgrade to Sid:
         
       sudo apt update && sudo apt full-upgrade 
         
3.  They will work for the most part, but some adjustments are needed to make them work properly on these distributions. However, since you are already using either of these two distributions, I will assume that you will know how to adapt these dot files to your system.

 ---
 
![2021-04-27T16:19:49,567910204-06:00](https://user-images.githubusercontent.com/64110504/116321898-37dbd500-a778-11eb-815a-b48656238847.png)

## Unexpected features you get right out of the gate
- **Bash's vim mode:** When in _normal_ mode, you will see a `-` at the beginning of your prompt. When in _insert_ mode, you will see a `+` at the beginning of the prompt. 
- **Caps Lock key is swapped with Esc key:** Caps Lock has way too much of a good position in they keyboard for the function it provides. If you are a vim user (or someone that just uses the crap out of the Esc key), you know how handy this is. If you don't want this, just change it in the input configuration in Sway's config file.
- **Mouse set for left handed people:** Because I'm a lefty. That's it. If you happen to be part of the other 90% of the human population, just change the input configuration in Sway's config file.  
- **Change directories without using the `cd` command:** Just type the name of the directory to move into it. 
- **Bash completion is no longer case sensitive:** No more wasted time pressing keys to get upper case letters.
- **Combined less and neovim as a pager for man pages:** Because man pages deserve better.
- **Keyboard layout set to Latin American:** Unless you need to type Spanish accents, you might want to take a look at Sway's config file and chage the keyboard layout to your preferred one. 
- **Gapless single client:** If there is only one client on a given workspace, gaps and borders will be disabled. As soon as another client is launched on the same workspace, gaps and borders will be activated.

## Stuff referenced by these configs
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

## (Some) keybindings

### Sway:
- `Super+Shift+c`: reload Sway.
- `Super+Shift+e`: exit Wayland session.
- `Alt+Shift+x`: lock screen.
- `Super+Shit+minus`: hide/unhide scratchpad.
- `Super+PagUp`: switch to next workspace.
- `Super+PageDown`: switch to previous workspace.
- `Super+x`: toggle Waybar on/off.
- `Super+Shift+b`: toggle window border on/off.

### Windows:
- `Super+q`: close.
- `Super+f`: fullscreen. 
- `Super+Shift+Space`: toggle floating. 
- `Super+(h,j,k,l)`: change the selection of a window in a designated direction.
- `Super+Shift+(h,j,k,l)`: move window in a designated direction.
- `Super+w`: tab windows.
- `Super+s`: stack windows.
- `Super+e`: spit tabbed or stacked windows.

### Mouse:
- `Super+click1`: move window.
- `Super+click2`: resize window.

### Running things:
- `Super+Return`: run a terminal.
- `Super+i`: run firefox.
- `Super+n`: run nautilus.
- `Super+d`: run wofi as an application launcher.
- `Super+Tab`: run wofi as a window switcher.
- `Super+Shift+q`: run wlogout. 

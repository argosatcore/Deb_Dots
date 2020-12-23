# Deb_Dots
⢀⣴⠾⠻⢶⣦⠀  
⣾⠁⢠⠒⠀⣿⡁  
⢿⡄⠘⠷⠚⠋⠀  
⠈⠳⣄⠀⠀⠀
   
     


At the kernel of my computing environment, there are two irreducible components: the [Debian GNU/ Linux Operating System](https://www.debian.org/), as a solid foundation to build on, and the [Binary Space Partition Window Manager (bspwm)](https://github.com/baskerville/bspwm), as one of the most extensible, flexible and, at the same time, minimal frameworks to manage the layout of my computing space.

  The design decisions implemented in these dot files, while at the time of writing this text have taken some distance from, were initially based on the work of [Protesilaos Stavrou](https://protesilaos.com/). His writings, as well as his videos on free and open source software, remain, in my opinion, an invaluable resource, both technically and philosophically, for those interested in examining that which, for better or worse, has become an inescapable aspect of contemporary life.
  
These dot files were started with a minimal Debian installation, but they should work with any Debian installation or Debian-based distribution. Also, even though I use these dots on Debian, I've made an effort to keep them as distribution agnostic as possible, meaning they are very likely to work on other distributions. As of now, I've succesfully been able to deploy them on [Arch Linux](https://archlinux.org/) (btw) and [Void Linux](https://voidlinux.org/). Feel free to use them as a starting point for your own dot files.

The layout for this README.md was heavely influenced by that of [Spencer Tipping](https://github.com/spencertipping/dotfiles).
 
 **bspwm Layout** | **Rofi Config**
:-------: | :-------:
![Captura de pantalla_2020-12-20_14-40-08](https://user-images.githubusercontent.com/64110504/102723982-b4920a80-42d1-11eb-82e5-f41e6cd6619f.png) | ![Captura de pantalla_2020-12-20_14-18-32](https://user-images.githubusercontent.com/64110504/102723968-9fb57700-42d1-11eb-95da-cdc61a88d3b9.png)
 **Shell Config** | **.Xdefaults Config**
![Captura de pantalla_2020-12-20_14-41-48](https://user-images.githubusercontent.com/64110504/102724008-d7242380-42d1-11eb-9b0d-145b00b0f997.png) | ![Captura de pantalla_2020-12-20_14-40-44](https://user-images.githubusercontent.com/64110504/102723996-c96e9e00-42d1-11eb-9319-7c51377a2416.png)

## Unexpected features you get right out of the gate:
- `Bash's vim mode`: When in _normal_ mode, you will see a "+" at the beginning of your prompt. When in _insert_ mode, you will see a "-" at the beginning of the prompt. 
- `Caps Lock key is swapped with Esc key`: Caps Lock has way too much of a good position for the function it provides. If you are a vim user (or someone that just uses the crap out of the Esc key), you know how handy this is. If you don't want this, just delete the ".speedswapper" file.
- `Mouse is set for left handed people`: Because I'm a lefty. That's it. If you happen to be part of the 90% of the rest of the population, just delete the  ".mouseconfig" file.  
- `Change directories without the need to type the "cd" command`: Just type the name of the directory to move into it. 
- `Bash completion is no longer case sensitive`: No more wasted time pressing keys to get capital letters.
## Stuff referenced by these configs
All of which are `apt install`able:

- `neovim`: text editor
- `rxvt-unicode`: terminal emulator
- `bspwm`: window manager
- `sxhkd`: keybinding daemon
- `rofi`: application launcher, window switcher, commad executor and many more
- `tint2`: panel
- `thunar`: file manager
- `dunst`: notification daemon
- `compton`: compositing for window transparency
- `tmux`: persistent SSH shell sessions
- `feh`: set the desktop background
- `i3lock`: screen locking


## (Some) Sxhkd keybindings

### bspwm
- `Super+Shift+r`: reload bspwm
- `Super+z`: reload sxhkd
- `Super+Shift+e`: exit bspwm session

### Workspaces
- `Ctrl+(left arrow key, right arrow key)`: move to the next or previous workspace 
- `Super+(1,2,3,4,5,6,7,8,9,0)`: go to a desginated workspace
- `Super+Shift+(1,2,3,4,5,6,7,8,9,0)`: move an active window to a desginated workspace
- `Super+Shift+x`: lock screen

### Windows
- `Super+q`: close
- `Super+Shift+q`: kill 
- `Super+f`: fullscreen 
- `Super+s`: float 
- `Super+t`: tile 
- `Super+Shift+t`: pseudotile 
- `Super+m`: monocle layout
- `Super+v`: hide 
- `Super+n`: unhide 
- `Super+r`: rotate windows clockwise
- `Super+Shift+r`: rotate windows counterclockwise
- `Super+(h,j,k,l)`: select an active window
- `Super+Shift+(h,j,k,l)`: move window in a designated direction

### Running things
- `Super+Space`: run a terminal
- `Super+Shift+Space`: run a terminal in a tmux session
- `Super+i`: run firefox
- `Super+a`: run thunar
- `Super+d`: run rofi as an application launcher
- `Super+Tab`: run rofi as a window switcher

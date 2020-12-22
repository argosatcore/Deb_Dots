# Deb_Dots
⢀⣴⠾⠻⢶⣦⠀  
⣾⠁⢠⠒⠀⣿⡁  
⢿⡄⠘⠷⠚⠋⠀  
⠈⠳⣄⠀⠀⠀
   
     


At the kernel of my computing environment, there are two irreducible components: the [Debian GNU/ Linux Operating System](https://www.debian.org/), as a solid foundation to build on, and the [Binary Space Partition Window Manager (BSPWM)](https://github.com/baskerville/bspwm), as one of the most extensible, flexible and, at the same time, minimal frameworks to manage the layout of my computing space.

  The design decisions implemented in these dot files, while at the time of writing this text have taken some distance from, were initially based on the work of [Protesilaos Stavrou](https://protesilaos.com/). His writings, as well as his videos on free and open source software, remain, in my opinion, an invaluable resource, both technically and philosophically, for those interested in examining that which, for better or worse, has become an inescapable aspect of contemporary life.
  
These dot files were started with a minimal Debian installation, but they should work with any Debian installation or Debian-based distribution. Feel free to use them as a starting point for your own dot files.
 
 **BSPWM Layout** | **Rofi Config**
:-------: | :-------:
![Captura de pantalla_2020-12-20_14-40-08](https://user-images.githubusercontent.com/64110504/102723982-b4920a80-42d1-11eb-82e5-f41e6cd6619f.png) | ![Captura de pantalla_2020-12-20_14-18-32](https://user-images.githubusercontent.com/64110504/102723968-9fb57700-42d1-11eb-95da-cdc61a88d3b9.png)
 **Shell Config** | **.Xdefaults Config**
![Captura de pantalla_2020-12-20_14-41-48](https://user-images.githubusercontent.com/64110504/102724008-d7242380-42d1-11eb-9b0d-145b00b0f997.png) | ![Captura de pantalla_2020-12-20_14-40-44](https://user-images.githubusercontent.com/64110504/102723996-c96e9e00-42d1-11eb-9319-7c51377a2416.png)

## Stuff referenced by these configs
All of which are `apt install`able:

- `neovim`: text editor
- `rxvt-unicode`: terminal emulator
- `bspwm`: window manager
- `sxhkd`: keybinfing daemon
- `rofi`: application launcher, window switcher, commad executor and many more
- `tint2`: panel
- `thunar`: file manager
- `dunst`: notification daemon
- `compton`: compositing for window transparency
- `tmux`: persistent SSH shell sessions
- `feh`: set the desktop background
- `i3lock`: screen locking


## (Some) Sxhkd keybindings

### BSPWM
- `Super+Shift-r`: reload bspwm
- `Super+z`: reload sxhkd

### Desktops
- `Ctrl+[left or right arrow key]`: change desktops on an horizontal layout.
- `Super+Shift[ionm,]`: go to specific desktops
- `Super+Shift+x`: lock screen
- `Super+d`: show openbox menu

### Windows
- `Super+q`: close a window
- `Super+f`: fullscreen
- `Super+s`: floating
- `Super+t`: tile
- `Super+t`: pseudotile

### Running things
- `Super+Space`: run a terminal
- `Super+Shift+Space`: run a terminal in a tmux session
- `Super+i`: run firefox
- `Super+a`: run thunar
- `Super+d`: run rofi

# Deb_Dots<sup>1</sup> 
⢀⣴⠾⠻⢶⣦⠀  
⣾⠁⢠⠒⠀⣿⡁  
⢿⡄⠘⠷⠚⠋⠀  
⠈⠳⣄⠀⠀⠀
   
---     

At the kernel of my computing milieu, there are two irreducible components: the [Debian GNU/Linux Operating System](https://www.debian.org/),<sup>2</sup>  as a solid foundation to build on, and the [Sway](https://swaywm.org/) window manager, as the best Wayland framework, at the moment, to manage what probably remains as both, the most common way of interacting with computers, and, simultaneously, one of its less examined aspects: the layout of the computing space.
 
   These dot files were started with a minimal Debian 10 Buster installation, so they should work with any Debian installation or Debian-based distribution. 
     
   It is worth mentioning that although I use these dots on Debian, I've made an effort to keep them as distribution agnostic as possible. I have managed to deploy them succesfully in other distributions, especifically on [Arch Linux](https://archlinux.org/) (_btw_) and [Void Linux](https://voidlinux.org/).<sup>3</sup>

   If you find any of this useful, feel free to grab any part or all of it.
   
   \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_
1.  The layout for this README.md was heavely influenced by that of [Spencer Tipping](https://github.com/spencertipping/dotfiles). Also, he (along with some [contributors](https://github.com/spencertipping/ni/graphs/contributors)) created an amazing tool for data processing pipelines in bash called [**_`ni`_**](https://github.com/spencertipping/ni). You should definetively check it out.

2. These dotfiles are currently being written on [Debian Sid](https://wiki.debian.org/DebianUnstable) :skull:. If you wish to go down the Sid route, make sure to replace your apt sources with the following lines:

         deb http://deb.debian.org/debian unstable main contrib non-free
         deb-src http://deb.debian.org/debian unstable main contrib non-free
         
3.  They will work for the most part, but adjustments are needed to make them work properly on these distributions. For example, one of them involves using an .xinit file instead of an .xsession file. However, since you are already using either of these two distributions, I will assume that you will know how to adapt these dot files to your system.


 ---

![2021-04-03T19:09:06,793634084-06:00](https://user-images.githubusercontent.com/64110504/113495753-af3b8300-94b0-11eb-962f-0d5cab43c9a2.png)

## Unexpected features you get right out of the gate
- **Bash's vim mode:** When in _normal_ mode, you will see a `-` at the beginning of your prompt. When in _insert_ mode, you will see a `+` at the beginning of the prompt. 
- **Caps Lock key is swapped with Esc key:** Caps Lock has way too much of a good position in they keyboard for the function it provides. If you are a vim user (or someone that just uses the crap out of the Esc key), you know how handy this is. If you don't want this, just delete the `.speedswapper` file and/or comment out the corresponding line in the `.xsessionrc file`.
- **Mouse set for left handed people:** Because I'm a lefty. That's it. If you happen to be part of the other 90% of the human population, just delete the  `.mouseconfig` file and/or comment out the corresponding line in the `.xsessionrc file`.  
- **Change directories without using the `cd` command:** Just type the name of the directory to move into it. 
- **Bash completion is no longer case sensitive:** No more wasted time pressing keys to get upper case letters.
- **Combined less and neovim as a pager for man pages:** Because man pages deserve better.
- **Keyboard layout set to Latin American:** Unless you need to type Spanish accents, you might want to take a look at the `.xsessionrc` file and chage the keyboard layout to your preferred one. Probably changing  `latam` for something like `us_intl` will do the job.
- **Gapless single client:** If there is only one client on a given workspace, gaps and borders will be disabled. As soon as another client is launched on the same workspace, gaps and borders will be activated.

## Stuff referenced by these configs
All of which are `apt install`able in Debian Sid:

- `neovim`: text editor.
- `vim-gtk`: (neo)vim's clipboard integration.
- `foot`: minimalist Wayland native terminal emulator.
- `sway`: wayland compositor.
- `waybar`: sway's panel.
- `wofi`: application launcher, window switcher, commad executor and many more.
- `nautilus`: file manager.
- `gammastep`: Screen temperature manager.
- `grimshot`: wayland native screeshooter.
- `tmux`: persistent SSH shell sessions.
- `swaybg`: sets the desktop background.
- `swaylock`: screen locker.
- `mako`: notification daemon.

## (Some) keybindings


### Sway:
- `Super+Shift+c`: reload Sway.
- `Super+Shift+e`: exit Wayland session.
- `Alt+Shift+x`: lock screen.
- `Super+Shit+minus`: hide/unhide scratchpad.
- `Super+PagUp`: switch to next workspace.
- `Super+PageDown`: switch to previous workspace.

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
- `Super+Shift+Space`: run a terminal in a tmux session.
- `Super+i`: run firefox.
- `Super+n`: run nautilus.
- `Super+d`: run wofi as an application launcher.
- `Super+Shift+q`: run rofi as a power menu. 

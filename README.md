# Deb_Dots<sup>1</sup> 
⢀⣴⠾⠻⢶⣦⠀  
⣾⠁⢠⠒⠀⣿⡁  
⢿⡄⠘⠷⠚⠋⠀  
⠈⠳⣄⠀⠀⠀
   
---     

At the kernel of my computing milieu, there are two irreducible components: the [Debian GNU/Linux Operating System](https://www.debian.org/),<sup>2</sup>  as a solid foundation to build on, and the [awesome](https://awesomewm.org/) window manager, as one of the most flexible and extensible frameworks to manage what probably is both, the most common way of interactaing with computers, and, simultaneously, one of its less examined aspects: the layout of the computing space.<sup>3</sup> 

In combination with awesome, I use my own variation of the [Awesome WM Copycats](https://github.com/lcpz/awesome-copycats), specifically of the powerarrow-dark theme. Its color scheme is based on the [Arc-Theme](https://github.com/horst3180/Arc-theme). As a side effect of using this, awesome is exposed to the [Lain](https://github.com/lcpz/lain) module, which grants it a whole bunch of useful features like a set of custom widgets for the wibar, new tiling capabilities and extra layouts, among other things.
 
   These dot files were started with a minimal Debian 10 Buster installation, so they should work with any Debian installation or Debian-based distribution. 
     
   It is worth mentioning that although I use these dots on Debian, I've made an effort to keep them as distribution agnostic as possible. I have managed to deploy them succesfully in other distributions, especifically on [Arch Linux](https://archlinux.org/) (_btw_) and [Void Linux](https://voidlinux.org/).<sup>4</sup>

   If you find any of this useful, feel free to grab any part or all of it.
   
   \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_
1.  The layout for this README.md was heavely influenced by that of [Spencer Tipping](https://github.com/spencertipping/dotfiles). Also, he (along with some [contributors](https://github.com/spencertipping/ni/graphs/contributors)) created an amazing tool for data processing pipelines in bash called [**_`ni`_**](https://github.com/spencertipping/ni). You should definetively check it out.

2. These dotfiles are currently being written on [Debian Sid](https://wiki.debian.org/DebianUnstable) :skull:.    

3. In the recent past, I used [bspwm](https://github.com/baskerville/bspwm) as my default window manager. I still regard it as one of the best tiling window managers out there, but I found in awesome some features that made the switch worthwhile. Some of these include, but are not limited to: the use of tags instead of workspaces (a word that, like the so called "productivity", I've come to deeply hate... but I digress), the extensibility provided by its use of the Lua programming language, the integration of components like widgets and a native status bar, and the combination of a predefined set of layouts with some manual control over them makes it the ideal hybrid wm. 
If you are interested in giving bspwm a try, you can take a look at my dotfiles. Also, a far more comprehensive and rigurous source on running bspwm on Debian is a book written by the greek philosopher, [Protesilaos Stavrou](https://protesilaos.com/), appropriately called _[Prot's Dots For Debian](https://protesilaos.com/pdfd/)_. His writings and videos on free and open source software may be of interest to those who wish to examine, both technically and philosophically, what, for better or for worse, has become an inescapable aspect of contemporary life. 

4.  They will work for the most part, but adjustments are needed to make them work properly on these distributions. For example, one of them involves using an .xinit file instead of an .xsession file. However, since you are already using either of these two distributions, I will assume that you will know how to adapt these dot files to your system.


 ---
 ## Current state of affairs:
 This image illustrates the current state of my dektop. It is the one that will use a "rolling" cadence in its updates, as I tend to make small modifications all the time. The images for the layouts down below won't be updated as often, as their purpose is to solely show the disposition of windows in awesome as opposed to its graphic design, hence the difference between the image below and the images used in the layouts. They will be changed only when breaking changes in the disposition of windows are introduced in my build of awesome.
 
![Screenshot from 2021-03-01 02-36-07](https://user-images.githubusercontent.com/64110504/109472500-d200f480-7a37-11eb-9b34-7044649022ce.png)
 
 ---
 
 ## Layouts:
 Awesome comes with even more than the ones shown here, these are just the ones that I have chosen for myself. Also, by using the [Lain](https://github.com/lcpz/lain/tree/33c0e0c2360a04fcc6f51bccb0ad2a7a9e9c07b3) module (an unofficial succesor to the Vain module), you get access to other layouts and features that are not included in the default version of awesome. 
 **Master & Stack ![tile](https://user-images.githubusercontent.com/64110504/109235140-b1fcd700-7792-11eb-9a2e-c82bf8532070.png)** |  **Master & Stack Left ![tileleft](https://user-images.githubusercontent.com/64110504/109235218-de185800-7792-11eb-9b7f-6f4612bfbadf.png)**
:-------: | :-------:
![Screenshot from 2021-02-23 19-39-51](https://user-images.githubusercontent.com/64110504/108935764-d9796580-7613-11eb-80bf-1c87f4a2914c.png) | ![Screenshot from 2021-02-23 19-39-57](https://user-images.githubusercontent.com/64110504/108936095-eeee8f80-7613-11eb-852b-c15e74690953.png)
**Tile Bottom ![tilebottom](https://user-images.githubusercontent.com/64110504/109235254-f2f4eb80-7792-11eb-97d7-c5769b43dcc0.png)** | **Tile Top ![tiletop](https://user-images.githubusercontent.com/64110504/109235289-056f2500-7793-11eb-8663-b1b77a8fccfa.png)**
![Screenshot from 2021-02-23 19-40-00](https://user-images.githubusercontent.com/64110504/108936354-ff066f00-7613-11eb-88ed-fa7d585402f5.png) | ![Screenshot from 2021-02-23 19-40-03](https://user-images.githubusercontent.com/64110504/108936642-12b1d580-7614-11eb-911f-7d03eb49ed56.png)
**Floating ![floating](https://user-images.githubusercontent.com/64110504/109235326-17e95e80-7793-11eb-94bd-ca5a759e1832.png)** | **Centered Master ![centerwork](https://user-images.githubusercontent.com/64110504/109235414-3fd8c200-7793-11eb-8619-84bba28091c4.png)**
![Screenshot from 2021-02-23 19-40-56](https://user-images.githubusercontent.com/64110504/108937011-2b21f000-7614-11eb-8c4b-19aa0fb35975.png) | ![Screenshot from 2021-02-23 19-42-01](https://user-images.githubusercontent.com/64110504/108937247-39700c00-7614-11eb-89f8-59d242d592bb.png)

## Unexpected features you get right out of the gate
- **Bash's vim mode:** When in _normal_ mode, you will see a `-` at the beginning of your prompt. When in _insert_ mode, you will see a `+` at the beginning of the prompt. 
- **Caps Lock key is swapped with Esc key:** Caps Lock has way too much of a good position in they keyboard for the function it provides. If you are a vim user (or someone that just uses the crap out of the Esc key), you know how handy this is. If you don't want this, just delete the `.speedswapper` file and/or comment out the corresponding line in the `.xsessionrc file`.
- **Mouse set for left handed people:** Because I'm a lefty. That's it. If you happen to be part of the other 90% of the human population, just delete the  `.mouseconfig` file and/or comment out the corresponding line in the `.xsessionrc file`.  
- **Change directories without using the `cd` command:** Just type the name of the directory to move into it. 
- **Bash completion is no longer case sensitive:** No more wasted time pressing keys to get upper case letters.
- **Combined less and neovim as a pager for man pages:** Because man pages deserve better.
- **Keyboard layout set to Latin American:** Unless you need to type Spanish accents, you might want to take a look at the `.xsessionrc` file and chage the keyboard layout to your preferred one. Probably changing  `latam` for something like `us_intl` will do the job.
- **Gapless single client:** If there is only one client on a given tag, gaps will be disabled. As soom as another client is launched on the same tag, gaps will be activated.
- **Discreet use of window title bars:** Title bars are mostly useless when using a tiling window manager, but they are very useful for moving windows when they are floating. Awesome is both, a tiling and a floating window manager. Taking this into account,title bars are removed if the windows are tiled, but as soon as they are switched to floating mode, a title bar will appear at the top for easy organization.

## Stuff referenced by these configs
All of which are `apt install`able:

- `neovim`: text editor.
- `rxvt-unicode`: terminal emulator.
- `awesome`: window manager.
- `awesome-extra`: additional modules for awesome.
- `rofi`: application launcher, window switcher, commad executor and many more.
- `nautilus`: file manager.
- `picom`: compositing for window transparency.
- `tmux`: persistent SSH shell sessions.
- `feh`: sets the desktop background.
- `redshift`: sets screen's temperature color according to time of day.


## (Some) keybindings

### List of keybindings:
- `Super+s`: display a list of all keybindings.

### Awesome:
- `Super+Ctrl+r`: reload awesome.
- `Super+Shift+q`: exit awesome session.
- `Alt+Ctrl+l`: lock screen.
- `Super+b`: hide/unhide panel.
- `Super+Space`: switch to next layout.
- `Super+Shit+Space`: switch to previous layout.

### Tags:
- `Super+(left arrow key, right arrow key)`: move to the previous or next tag. 
- `Alt+(left arrow key, right arrow key)`: move to the previous or next non empty tag. 
- `Super+(1,2,3,4,5,6,7,8,9,0)`: go to a desginated tag.
- `Super+Shift+(1,2,3,4,5,6,7,8,9,0)`: move an active window to a desginated tag.

### Windows:
- `Super+q`: close.
- `Super+f`: fullscreen. 
- `Super+Ctrl+Space`: toggle floating. 
- `Super+n`: minimize.
- `Super+Ctrl+n`: restore minimized.
- `Ctrl+Super+Return`: move to master.
- `Super+Shift+h`: increase the number of master windows.
- `Super+Shift+l`: decrease the number of master windows.
- `Super+Ctrl+h`: increase the number of columns.
- `Super+Ctrl+l`: decrease the number of columns.
- `Super+(h,j,k,l)`: change the selection of a window in a designated direction.
- `Super+Shift+(h,j,k,l)`: move window in a designated direction.

### Mouse:
- `Shift+click4`: float a tiled window and viceversa.
- `Super+click1`: move window.
- `Ctrl+click2`: resize window.

### Running things:
- `Super+Return`: run a terminal.
- `Super+Shift+Space`: run a terminal in a tmux session.
- `Super+i`: run firefox.
- `Super+a`: run nautilus.
- `Super+d`: run rofi as an application launcher.
- `Alt+Tab`: run rofi as a window switcher.
- `Super+e`: run rofi as a power menu. 
- `Super+Shitf+e`: run rofi as a wifi menu.

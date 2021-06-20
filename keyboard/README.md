In this build it is possible to change the mapping of the modifier keys between Windows and the Mac emulator in a keycode file. 
If enabled in the GUI: Keyboard/Mouse tab, the included BasiliskII_keycodes file will translate the modifier keys as shown below. 

The keycode function can also be enabled by editing the preferences file manually. Set:

    keycodes true
    keycodefile BasiliskII_keycodes

I solved the **Search=CapsLock** problem in X windows for the "pc105" keyboard model:

    nano /usr/share/X11/xkb/symbols/pc

Find and replace this line as so:

    key <LWIN> { [Caps_Lock] };

Originally <LWIN> was mapped to [Super_L]. Clear the xkb settings cache:

    sudo rm -rf /var/lib/xkb/*

Reboot your laptop.

Edit /etc/default/keyboard:

    XKBMODEL="pc105"
    XKBLAYOUT="br"
    XKBVARIANT="nodeadkeys"
    XKBOPTIONS=""
    BACKSPACE=""

The Chromebook's keys will then work as follows:

    Search_Key = Caps Lock
        L_CTRL = Control key
         L_ALT = Alt key (i3 windows manager intercepts this "mod" key; also works partially as Mac Command key)
         R_ALT = Mac Command key
        R_CTRL = Mac Option key
        
Mount the included "brazilian_layout" disk image and move the "Brazilian ABNT2" file over to your System Folder. You will be asked to install the file in System, allow installation. The Brazilian keyboard layout will be available as a choice in the Keyboard control panel.

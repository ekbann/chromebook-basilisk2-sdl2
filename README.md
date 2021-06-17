# chromebook-basilisk2-sdl2

Minimal Basilisk II installation using Debian netinst non-free firmware version on an Acer Chromebook 11 N7 (C731) with X.org.

Some preparation is required to install Linux. See here: http://ekbann.blogspot.com/2020/03/acer-chromebook-11-n7-c731-surgery.html

This script will automatically download and compile all the necessary source code to have a fully functional Basilisk II emulator running with SDL2 in X Windows. In order to have an extremely light Linux system the Debian 'netinst' version was chosen as the base for this project. As of this writing the following versions were used:

    Debian 10 "Buster" netinst non-free firmware version (firmware-10.9.0-amd64-netinst)
    SDL2 version 2.0.14
    Basilisk II version by kanjitalk755

A 200MB disk image is also included here with pre-installed Mac OS 7.6.1 and Prince of Persia 1 for a quick demonstration of sound and graphics at 640x480 and 256 colors.

Before we can run the script, a few words on getting our Chromebook up and running with Linux. The easiest way to install the system is to use an ethernet adapter to access the Internet for the additional packages. Since the Chromebook does not have a built-in ethernet port, I used Apple's USB to Ethernet dongle model A1277. Plug that in to your Chromebook and connect it to your router. Boot the Debian netinst USB installer. Install only "SSH Server" and "Standard System Utilities".

Once Linux is installed, boot into your freshly created Debian 'netinst' and login with the root user. Then run the following commands:

    sudo apt install git
    git clone https://github.com/ekbann/chromebook-basilisk2-sdl2
    cd chromebook-basilisk2-sdl2
    bash run.sh

In the first run, answer YES to update/upgrade the system, and install all the packages needed for our minimal installation. Go grab a cup of coffee and when its done, it will automatically reboot and greet you with a graphical login screen.

Login as root once again. The i3 windows manager will ask to create a config file, answer YES. Choose the ALT key as your i3 modifier key.

Open a terminal windows with ALT+ENTER and execute the commands below:

    cd chromebook-basilisk2-sdl2
    bash run.sh

This time around, answer NO to the update/upgrade step. Go grab another cup of coffee and wait for the script to end. Reboot so that the additional configuration takes effect.

    reboot

Login as root one last time, open a xterm, and run Basilisk II. Note that Pulse audio does not run as root so there will be no sound. Once we have a working BasiliskII running, move all the required files over to the normal user you created during the Debian netinst installation (e.g. sjobs):

    mv /root/HD200MB /home/sjobs/
    mv /root/Quadra800.ROM /home/sjobs/
    mv /root/.basilisk_ii_* /home/sjobs/
    cp /root/.Xresources /home/sjobs
    chown sjobs:sjobs /home/sjobs/*
    chown sjobs:sjobs /home/sjobs/.basilisk_ii_*
    chown sjobs:sjobs /home/sjobs/.Xresources

Logout from root (SHIFT+ALT+E) and log back in as your normal user. Go thru the normal i3 config creation and modifier key assignment (ALT). Now run BasiliskII directly without needing to open an xterm: press ALT+D to launch "dmenu" and type "BasiliskII" followed by ENTER.

Enjoy!
    
You can change the screen resolution by editing the .basilisk_ii_prefs and change the "screen" parameter. For some serious work, you can try the following for fullscreen maximum resolution and colors:

    screen dga/0/0
    displaycolordepth 32

Then go to Mac OS 7.6.1 Control Panel and under Monitors, select "Millions" of colors.

There is a folder called "keyboard" that has the default raw keycodes used by Basilisk II. Basically it converts the host OS scancodes into the emulated Basilisk II keycodes. This allows the ALT and WINDOWS keys to be assigned the COMMAND and OPTION keys respectively. There are many keycode sets depending on which video driver is being used, e.g. X11, Quartz, Linux framebuffer, Cocoa, or Windows. This is especially needed when using non-QWERTY keyboard layouts.

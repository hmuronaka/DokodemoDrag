DokodemoDrag
=====================

[日本語のREADME](./docs/README\_JP.md)

----

On a Mac, isn't it annoying to move the mouse cursor when moving or resizing a window?

DokodemoDrag makes it easy to move and resize the window, no matter where the mouse cursor is on the window.

![image01](https://github.com/hmuronaka/DokodemoDrag/blob/images/docs/images/image01.gif)

It is very easy to use, as shown below.

|Action|Operation|
|:---|:---|
|Move the window|Place the mouse cursor anywhere in the window and drag it with the mouse while holding down the Command key.|
|Resize the window|Place the mouse cursor anywhere in the Window and drag the mouse while holding down Command+Shift.|

# Requirements

macOS version 11.2 +

# How to install and start up for the first time 

1. [Download the zip file](https://github.com/hmuronaka/DokodemoDrag/releases/download/0.2/DokodemoDrag.app.zip) containing the app from this repository. 
2. Unzip the zip file and move DokodemoDrag.app to the Application folder.
3. Open Finder and right-click on Application to launch DokodemoDrag (the icon will appear in the menu bar when launched).
4. In MacOS, go to [System Preferences]=>[Security and Privacy]. Open the [Privacy] tab and select [Accessibility] to enable DokodemoDrag.app.
5. Click the icon on the menu bar to close the application.
6. Start the DokodemoDrag.app from the application again.

# How to Uninstall

Remove DokodemoDrag.app from Finder under Applications.

# Settings and Operations

The following settings and operations are available from the menu on the menu bar.

|Menu|Description|
|:--|:--|
|Enable / Disable|You can enable/disable the DokodeomoDrag window operation.|
|Launch on Login|If checked, DokodemoDrag.app will be automatically launched upon OS login (default is checked).|
|Quit|Quit DokodemoDrag.|

# Information used as reference in development

Much of the implementation of this app is based on [Rectangle](https://github.com/rxhanson/Rectangle), which allows you to place Mac windows from keyboard shortcuts.

# License
MIT License

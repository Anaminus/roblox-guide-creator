### This project is archived! Pull requests will be ignored. Dependencies on this project should be avoided. Please fork this project if you wish to continue development.
----

# Guide Creator #

A Roblox plugin for creating visual guidelines to use while building.

Guide Cycle Button:

This button cycles selected parts between 3 possible states: Part, Guide, and
Invisible (that is, Parts turn into Guides, Guides turn into Invisibles, and
Invisibles turn back into Parts).

A Guide is a SelectionBox that takes the place of the selected part. It
doesn't interfere with parts in the Workspace, so it can be used as a visual
guideline while building. The Guide's color is determined by the part's
BrickColor.

Guides are stored in a Model named "Guides" in the Game. This Model will be
visible in the Explorer panel when a guide has been created, so you can select
the guide from there when you want to change its state.

Invisible is basically an invisible guide. This can be useful if you don't
want to display the guide or have the part in the Workspace.

Part is just a normal part.


## Installation ##

1. Open Roblox Studio.
2. Go to `Tools > Open Plugins Folder` to find location of the plugins folder.
3. Move the GuideCreator folder to this location.


## Repository ##

The latest version of this plugin is available here:

https://github.com/Anaminus/roblox-guide-creator/downloads

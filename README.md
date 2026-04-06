# TI84-F5menu
A custom menu for the unused F5 key on the TI-84 Plus CE. 

# Installation 
**Only install if you are willing to use ArTIfiCE!**

I have a demo video for those who don't want to do the song and dance of installing it onto their calculator: 
<p align="center" width="100%">
<video src="https://github.com/user-attachments/assets/d2f8a3d6-6e50-4c29-a598-2f7e2a65bde4" width="80%" controls></video>
</p>

## Install requirements 
- F5MENU.8xp
- ArTIfiCE.8xv 
- ASMHOOK.8xp (program for convenience, not technically necessary)
- CabriJr app (most likely preinstalled, use .8ek file in dependencies folder otherwise) 
- TI Connect CE program (install [here](https://education.ti.com/en/products/computer-software/ti-connect-ce-sw), or find in the dependencies folder)
- Connector cable 

## Install instructions 
[key to press]; (menu item to select) 
1. Connect the calculator to the computer using the connector cable. Open the TI Connect CE app and go to the Calculator Explorer Workspace tab (on the left sidebar, the second icon that looks like a document).  
2. Drag in arTIfiCE.8xv and when prompted, choose to store it in Archive.
3. Drag in ASMHOOK.8xp and when prompted, choose to store it in Archive. 
4. Drag in F5MENU.8xp and when prompted, choose to store it in Archive. 
5. [apps] -> [2] -> [enter] -> (Open...) -> (* ARTIFICE) -> (ASMHOOK) to run ASMHOOK.8xp. 
6. [mode] to quit. 
7. [prgm] -> [1] -> (* ASMHOOK) to run ASMHOOK.8xp. This is a check - if the output is "Done", then the hook is installed successfully. If ERROR:Invalid appears, either ArTIfiCE or ASMHook failed to install properly. 
8. [prgm] -> [1] -> (* F5MENU) to install hook.
9. [prgm] -> [1] -> (* F5MENU) to uninstall hook. 
(every time the program runs from the [prgm] menu the hook will either install or uninstall itself.) 

# Full uninstall (including removal of dependencies) 
You can remove all relevant files (ArTIfiCE.8xv, ASMHOOK.8xp, F5MENU.8xp) through the TI Connect CE app if you don't want to reset all memory.

*Please make sure to uninstall the hook through running the program before you delete the program files.*

Reset RAM ([2nd] -> [+] -> [7] -> [1] -> [2]).

There are no other steps needed to uninstall. 

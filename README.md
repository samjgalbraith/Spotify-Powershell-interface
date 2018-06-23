# Spotify Desktop automatic pause - Windows
This pauses Spotify whenever your computer locks. It does this by setting up a scheduled task in Windows to trigger a Powershell script to run when your computer becomes locked.
Your computer may lock:
* Explicitly by using Windows + L
* Reaching threshold time for your screen saver settings with the option "On resume, display login screen" checked.

See https://www.thewindowsclub.com/lock-computer-inactivity-windows-10 for instructions to set your computer up to automatically lock on a timer.

## Setup
### I'm a coder, I know what I'm doing
In Powershell as Admin
```powershell
git clone https://github.com/samjgalbraith/Spotify-auto-pause.git
cd Spotify-auto-pause
.\Setup.ps1
```
### I'm not a coder
* Use the 'clone or download' option to download a zip file of the script. Once downloaded, unzip it into a good filesystem location for safekeeping and navigate into the directory in the windows file browser so that you're in the same folder as `Setup.ps1`
* From the file brower, select File -> Open Windows Powershell -> Open Windows Powershell as administrator. You may be asked to confirm.
* Once in Powershell execute the following command:
```powershell
.\Setup.ps1
```

## Removal
* In Powershell as administrator:
```powershell
.\Setup.ps1 -Remove
```
You may be asked to confirm the removal by Windows. Answer with Y if asked.

# Credits
This utility is based on the code by @noeFernandez to interact with Spotify in Windows. 
https://github.com/noeFernandez/Spotify-Powershell-interface
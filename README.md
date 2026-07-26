# WayOfTheSamuraiFPSUnlock
Allows WOTS 3 and 4 to play at 60/90/120 FPS.

  Way of the Samurai 3 and 4 (PC) - Framerate Patch
  60 / 90 / 120 fps gameplay, with cutscenes kept at 30 fps

WHAT IT DOES
------------
Orignal PC port is 30 fps. This patch converts to 60/90/120 fps.

Cutscenes are deliberately left at 30 fps. Their sequencing is tied to the render rate, so running them faster breaks them hardcore. 
30 keeps them paced correctly. If you can get it fixed -- please contribute!

REQUIREMENTS
------------
GOG build of Way of the Samurai 3 or 4. Steam build -MAY- work if de-encrytped.

The patcher should be safe to test, it checks all 18 patch sites byte-for-byte against your exe 
and refuses to write anything if they do not match.


INSTALL
-------
1. Copy Install.bat, patch.ps1 and "Switch Framerate.bat" into the
   game folder - the one containing WayOfTheSamurai3 or 4 .exe.
2. Run Install.bat.

It backs up your original exe to WayOfTheSamurai3.exe.orig, builds the
60/90/120 fps variants, and installs 60 fps. No admin rights needed.


SWITCHING
---------
Run "Switch Framerate.bat" and pick:

   [1]  30 fps   - original, completely unmodified
   [2]  60 fps   - recommended, play-tested
   [3]  90 fps   - EXPERIMENTAL, not play-tested
   [4]  120 fps  - EXPERIMENTAL, not play-tested

Close the game first, of course.

60 fps is the only build that has actually been played through.
90 and 120 are built the same way and verified to launch and apply
correctly, but I didn't play through them. Might still be some minigame, etc broken.

UNINSTALL
---------
Run "Switch Framerate.bat" and choose [1]. That restores the original.
You can then delete the .60fps_v9 / .90fps_v9 /
.120fps_v9 files.

STEAM VERSION
-------------
WOTS3 should work out of box for STEAM. WOTS4 requires a decrypted .exe due to
STEAM DRAM. STEAMLESS should work.

The engine's content rate stays at 30 ticks.

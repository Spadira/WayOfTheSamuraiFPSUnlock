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
Untested - this was developed against the GOG build only.

Just run Install.bat and see. If the Steam exe happens to be the same
build, it will work. If it differs at all, the patcher stops and tells
you, without modifying anything.

Be aware the Steam release may be wrapped in SteamStub DRM, which
encrypts the executable's code section on disk. May work if decrypted.


Summary
-----------------
170 bytes changed across 18 sites. Three small code snips are placed 
at the end of the .text section, so the file layout and section sizes are untouched.

  * frame gate (0x403510) - each frame sets the frame interval to
    1/30 when the engine is in event mode, otherwise 1/<target>.
    Event mode is the engine's own state: [[0x94dadc]+0x70] == 2 or 3,
    the same field 27 call sites in the script/scene code gate on.
  * script Wait (0x56845c) - wait counts are authored for 30 fps, so
    they are scaled by target/30 during gameplay and left alone in
    cutscenes.
  * animation sound-key window (0x42e319) - the window is one authored
    frame wide, which spans two rendered frames at 60 fps and makes
    every animation sound fire twice. Now its derived from the frame
    interval, so should be correct at any rate.
  * motion blend length (0x430f2c, 0x431945) - doubled.
  * SetFrameRate (0x4034d1) - startup default.

The engine's content rate stays at 30 ticks.

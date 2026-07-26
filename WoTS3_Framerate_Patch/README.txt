================================================================
  Way of the Samurai 3 (PC) - Framerate Patch
  60 / 90 / 120 fps gameplay, with cutscenes kept at 30 fps
================================================================

WHAT IT DOES
------------
Orignal PC port is 30 fps. This patch converts to 60/90/120 fps.

Cutscenes are deliberately left at 30 fps. Their sequencing is tied to the render rate, so running them faster breaks them hardcore. 
30 keeps them paced correctly. If you can get it fixed -- please contribute!


WHICH VERSIONS WORK
-------------------
Both PC releases are supported. The patcher works out which one it is
sitting next to and applies the matching addresses.

  GOG    WayOfTheSamurai3.exe
         size   : 5,697,536 bytes
         SHA256 : ED1552D19EF3FAA7959510EEB22D3A69B9B4A180A5C00923238FDA7EF3E00301

  Steam  WayOfTheSamurai3.exe
         size   : 5,806,592 bytes
         SHA256 : F16D96E61E53BAD5DF5EC38E18AE415C80A0B054A0041C8B17A8C1FDFB23B28E


Other builds are not supported, but trying is safe: the patcher checks
every patch site byte-for-byte against your exe and refuses to write
anything if they do not match.


INSTALL
-------
1. Copy Install.bat, patch.ps1 and "Switch Framerate.bat" into the
   game folder - the one containing WayOfTheSamurai3.exe.
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
Run "Switch Framerate.bat" and choose [1]. That restores the original
exe exactly. You can then delete the .60fps_v9 / .90fps_v9 /
.120fps_v9 files and the patch files if you want.

On Steam you can also just use "Verify integrity of game files".


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

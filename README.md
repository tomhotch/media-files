# media-files
Utilities for managing media files

Most cameras name their files by using a number that always increases, so
no two files ever have the same name.

My Flip Video camera when used with the FlipShare software does not behave
this nicely.  I think files get renamed when copied, and the camera somehow
re-uses lower numbers in the file names.  I stopped using the FlipShare SW
and I need some utilities to help me manage the files to ensure I have one
and only one copy of each file with a unique name.

I keep a copy of all video files in one directory on shared network drive.
Call this my 'library'

A possible workflow
- Copy all the files from the camera to a staging directory
- Check the staging files vs. the library.
  - Are any of the files already in the library?
  - How can I tell?  Do the file sizes match?  How about the date taken?
- Rename the files to avoid any duplicates in the library
- Copy the new files to the libary
- It's now OK to remove files from the staging directory and the camera

First Experiment
- Read the file names and sizes from a source dir and destination dir
- Report if:
  1. Any files in src do not exist in dest
  2. Any files in src match a file name in dest, but have different sizes

Example Directory Paths
- Filp Camera: F:\DCIM\100VIDEO
- Staging Directory: T:\My_Videos\from-flip-camera
- Library Directory: T:\My_Videos\FlipShare Data\Videos
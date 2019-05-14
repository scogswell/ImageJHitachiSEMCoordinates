# ImageJ Hitachi SEM Coordinates
Makes a table of X/Y coordinates for a directory of images taken with Hitachi PC-SEM software on an SU-70 Electron Microscope

Images taken with the PC-SEM software on the Hitachi SU-70 (possibly other microscopes, I have no others to test) store the
motorized stage's position in the sidecar .txt file that accompanies each tiff image file. This is an ImageJ/FIJI macro
which recurses a directory of SU-70 images and makes a results table of all the x/y coordinates.  The results table can be 
saved as a csv file from ImageJ/FIJI and imported into Excel or other programs.  

Why would you want this?  If you put a sample in multiple times but can't get the placement 100% the same every time, you can
extract coordinates of features you'd imaged previously, and then do a coordinate transform to calculate where the 
features should be.   Also sometimes you want the coordinates to use in other pieces of equipment and this provides an easy
way to get the coordinates out.  

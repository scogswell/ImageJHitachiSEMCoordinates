// Makes a table of all the coordinates from Hitachi SU-70 tiff files in a directory.
// Needs the sidecar .txt file for each .tif file to exist in the same directory as the tiff (default).  
// This works for my SU-70, hopefully PC-SEM didn't change the format over the years. 
//
// Steven Cogswell, P.Eng.
// UNB Microscopy and Microanalysis Facility
// April 2019. 
// 

setBatchMode(true); 
showMessage("Extract SU-70 Coordinates", "This Macro makes a report of all the Hitachi SU-70 stage coordinates from files in a directory");
run("Clear Results"); 
// Some of this is adapted from http://rsbweb.nih.gov/ij/macros/ListFilesRecursively.txt  
dir = getDirectory("Choose a Directory");
count = 1;
listFiles(dir); 
updateResults(); 
// End of macro. 

function listFiles(dir) {
     list = getFileList(dir);
     for (i=0; i<list.length; i++) {
        showProgress(i/list.length);  
        if (endsWith(list[i], "/"))
           listFiles(""+dir+list[i]);    // Recusive through all subdirectories
        else
           //print((count++) + ": " + dir + list[i]);
           
		if(endsWith(list[i],".tif")) {    // Only open tiff files
			tiffFile = list[i];
			checkTif = indexOf(tiffFile,".tif");
			hitachiFile = substring(tiffFile,0,checkTif)+".txt";  // Hitachi file ending in .txt
			hitachiPath = dir+hitachiFile; 
			//print("For Image "+tiffFile+" Hitachi file is "+hitachiFile+" in "+hitachiPath);
			getHitachiXY(hitachiPath, tiffFile);   // Determine microscope coordinates from SU-70 file 
		}
     }
  }
		

// Function to extract Stage X and Y coordinate for a file, and put result into a table
// path is the file we're going to open (directory + file ending in .txt)
// file is the corresponding tiff name, just used for the table
//
function getHitachiXY(path, file) {
	//print("Using "+path+" to get coordinates");
	exists=File.exists(path);   // Check if hitachi file exists or not
	if (exists==1) {
		// All is ok, we can continue
		//print("Hitachi info file ",hitachiFile," exists"); 
	} else {
		// Couldn't find the hitachi info file.   
		//showMessage("No calibration file","Couldn't find Hitachi info file "+hitachiFile); 
		// Make an entry in the table that we couldn't find the sidecar .txt file. 
		row = nResults; 
		setResult("Filename", row, file);
		setResult("X", row, "Couldn't find .txt");
		setResult("Y", row, "Couldn't find .txt");
		return;  
	}

	// Find the calibration in the file
	targetX = "StagePositionX=";   // This is in um in the Hitachi file, it seems
	targetY = "StagePositionY=";   // This is in um in the Hitachi file, it seems
	lines=split(File.openAsString(path),"\n");   // Opens entire .txt file into a string array, ugh but what ImageJ does. 
	hitachiXinUM="Couldn't find StagePositionX";  // If we don't find the real coordinates, these end up in the table as a helpful note
	hitachiYinUM="Couldn't find StagePositionY";
	for (i=1; i<lines.length; i++) {
		
		if (startsWith(lines[i],targetX)) {  // If this matches the target for X coordinate
			//print(lines[i]); 
			hitachiX=substring(lines[i],lengthOf(targetX));
			if (isNaN(parseFloat(hitachiX))) {
				showMessage("Error parsing coordinate","Error parsing the X coordinate ",hitachiX);
				exit();
			}
			hitachiXinUM=parseFloat(hitachiX)/1000000;   // Convert from um to mm in scale
			//print("X is  ",hitachiXinUM," mm"); 
		}
		
		if (startsWith(lines[i],targetY)) {  // If this matches the target for Y coordinate
			//print(lines[i]); 
			hitachiY=substring(lines[i],lengthOf(targetY));
			if (isNaN(parseFloat(hitachiY))) {
				showMessage("Error parsing coordinate","Error parsing the Y coordinate ",hitachiY);
				exit();
			}
			hitachiYinUM=parseFloat(hitachiY)/1000000;   // Convert from um to mm in scale
			//print("Y is  ",hitachiYinUM," mm"); 
		}
	}
	// Update the results table with found coordinates 
	row = nResults; 
	setResult("Filename", row, file);
	setResult("X", row, hitachiXinUM);
	setResult("Y", row, hitachiYinUM);
}

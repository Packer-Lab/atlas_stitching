// Batch processing of stitching atlas images
// 
// --- stitchAllFolders ---
// use the stitchAllFolders if you want to stitch multiple subfolder that contain xml files
// main_folder = the folder that contain multiple subfolders of xml files
// overlap = 1 to compute overlap or 0 to disable
// inverty = 1 to invert Y coordinates or 0 otherwise
// -- stitch -- if you want to stitch a specific folder containing .xml file
// input_folder the folder that contains the xml file

main_folder = "F:/Data/ilazarte/2021-02-14/slice2/";
overlap = 1; inverty = 1;
stitchAllFolders(main_folder, overlap, inverty);

function stitchAllFolders(main_folder, overlap, inverty) {
	subfolders = getFileList(main_folder);
	
	for (i = 0; i < subfolders.length; i++) {
		print(main_folder + subfolders[i]);
		stitch(main_folder + subfolders[i], overlap, inverty);
	}
	run("Close All");
	print("Batch processing done")
}

function stitch(input_folder, overlap = 1, inverty = 1){
	overlap_options = newArray(" ","compute_overlap");
	inverty_options = newArray(" ","invert_y");
	file_list = getFileList(input_folder);
	print(file_list[0]);
	for (i = 0; i < file_list.length; i++) {
		print(file_list[i]);
		if(endsWith(file_list[i], ".xml")){
			fname = file_list[i];
			file = input_folder + file_list[i];
			run("Grid/Collection stitching",
			"type=[Positions from file]" + 
			" order=[Defined by image metadata] browse=" +
			file + " multi_series_file=" + file + 
			" fusion_method=[Linear Blending]" +
			" regression_threshold=0.30 max/avg_displacement_threshold=2.50" +
			" absolute_displacement_threshold=3.50" + overlap_options[overlap] +
			"increase_overlap=0" + inverty_options[inverty] +
			"computation_parameters=[Save memory (but be slower)]" +
			" image_output=[Fuse and display]");
		}
	}
	filename = replace(fname,".xml","");
	saveAs("Tiff", input_folder + filename + "-s");
	print("Stitched" + filename);
	run("Close All");
	}


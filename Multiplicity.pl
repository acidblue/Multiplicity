
#!/usr/bin/perl
use 5.006;
use strict;
use warnings;
use Cwd;


# THIS PROGRAM SHOULD WORK FOR BOTH WIN AND LINUX
# HAS BEEN TESTED ON UBUNTU 10.04 AND WINXP

#Variables
my @stars;         # Stars for banner
my $sd; 	       #Source Directory
my $sf;            #Source File-Name
my $nc;            #Number of Copies
my $dd;            #Destinaion Directory
my $count;         #Count for while Loop
my $dir = getcwd;  #Get the current working directory and put it in $dir


					
#Banner
print "\n";
@stars = ("*") x 21;
print "@stars\n";
print ("*\t\t\t\t\t*\n");
print ("* \tMultiple File Copy Program\t*\n");
print ("* \tby Acidblue 2011\t\t*\n");
@stars = ("*") x 21;
print "@stars\n";
#End Banner


#Declare File List Function
sub list_files{
opendir(SD, $sd);
while (my $file = readdir(SD)){
	print "$file\n" if $file !~ /^\./ ;    # Comment out after the 'if' if you want to list everything in the current directory
}
}
#End function



#Declare source dir function
sub source_dir{
print "$dir <--Current Directory\n";
print("\nType a directory path for the source file:\n");

$sd=<STDIN>;			                   #user inputs directory path
chomp $sd;

#Check if directory path is correct
if (opendir(SD, $sd)) {		               #If path is correct then procede
	chdir $sd;
	list_files(); 			              #Call Function to list files

	print "You are now in directory:", cwd, "\n";
	print (" \nPlease type a source file name from the above list: \n");
	$sf=<STDIN>; 			       #User inputs file to copy
	chomp($sf) 			          #Remove \n character
}
else { 				              #If path is not correct print error messg and restart function
	print("******No such directory, please check the path and try again******\n");
	source_dir();
}

#Check if file name is correct
if (open(SF, $sf)) { 		                #If file name is correct then procede to copy
	print ("How many copies would like to make?\n");
	$nc=<STDIN>; 			               #User inputs # of copies to make
}
else { 				                      #If file name is not correct then...
	print("******Cannot find file, please check file name and re-submitt******\n");
	source_dir(); 			              # Re-run function to get file name
}
}
#end function


#Declare destination dir function
sub des_dir{
print("Type a directory path to save the copies to:\n");                # Input diretory path you want to save the copies to

$dd=<STDIN>;
chomp $dd;
if (opendir(DD, $dd)){							                        #Open destination directory
	print "Your files have been saved to directory:", $dd, "\n";
}
else {
	print("No such directory, please re-start and try again\n");        #Re-run function if path is incorrect
	des_dir();
}

}
#End function


#Run functions
source_dir();
des_dir();

#Initiate count for loop
$count=0;

#Magic happens here in a 'while loop'
while ($count < $nc){
	chdir $sd; 			        #Change directory to soucre dir in order to read file for copying
	open SF, $sf;
	binmode(SF);		        #Makes sure non-text files like image files, pdf's and the like get copied correctly
	chdir $dd; 			        #Chage directory to destination folder in order to send copied files
	open (DF,">($count)$sf");	#Opens Destination File Handler to write to new file and use the current value of '$count' to add to file name
	binmode(DF);
	print (DF <SF>); 		    #Copies Source file to Destination file
	$count++;
}
#End loop


chdir $dd;
#List files copied to destination folder
opendir(DD, $dd);
while (my $file = readdir(DD)) {
	print "$file\n" if $file !~ /^\./ ;  #Uncomment after 'if' to leave out files with "." and ".." other wise as is, it will list everthing in folder 
}

print "\nSuccess!\n";
print "Check above list for your files, they will be listed as '(x)filename.ext'\n";

#Close File and Dir handlers
closedir(DD);
closedir(SD);
close(SD);
close(SF);





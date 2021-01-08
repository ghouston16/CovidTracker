#!/bin/bash
# Menu Script - Prints options 
# Reads user input - while loop checks input is within range
# Case/switch statement executes relevant script or exits application
echo
echo "Welcome to Covid Track and Trace "
echo
echo "Main Menu - Please Select an Option: 
1) Add a new Customer
2) Remove an existing Customer
3) Search for a Customer
4) E-mail a Customer
0) Exit Application 
"
while [[ ! "$option" = [0-4] ]]; do # Validation: while loop requires a number 0-4
echo
echo "Please choose from the options above (0-4): "
read option 
done

case $option  in
	[1] )
	clear 
	./addContact.sh;; # Option 1 runs add Contact script 
	[2] )
	clear
	 ./remove.sh;; 	# Option 2 runs Remove Contact script 
	[3] )
	clear 
	./Search.sh;;	# Option 3 runs Search Contact script
	[4] )
	clear
	 ./mail.sh;;	# Option 4 runs Mail Contact script
	[0] ) 			# Option 5 exits application
	echo
	echo "Exiting application"
	echo
	exit 1
	;;
esac

#!/bin/bash
# This script allows users to search for and delete contacts from contact.txt
echo
echo "Covid-19 Track and Trace -- Remove a Contact "
echo
echo "Contacts List: "
awk -F ';' '{print " " $1 ",", $NF}' contact.txt #Prints selected fields from Contacts
echo
while [[ "$search" = "" ]]; do # While loop checks input string not blank
  echo "Please enter Name, E-mail or Mobile Number of the Contact you wish to Delete: "
  read search
  echo
done
  # If statement checks that user input the number 0
if [ "$search" != "0" ]; then
echo 
num_matches=`grep -c -i "$search" contact.txt`
  echo "Search Results:  "
  echo
  echo " $num_matches Matches Found"
  echo
  grep -i -n "$search" contact.txt | awk -F ';' '{print " "  $1",", $2",", "Email:",  $NF}'  
  echo
# If there is more that one match user is shown a numbered list and asked to input ID of contact
# Decision control switch statement allows user to confirm/reject contact delete
  if [ "$num_matches" -gt 1 ]; then
	num_contacts=`grep -c "@" contact.txt`
	while [[ ! "$contactNo" = [0-"$num_contacts"] ]]; do
   	  echo "Please enter the Contact ID of the contact you wish to delete?: " 
 	  read contactNo
	  echo 
  	done
	clear
	echo    
     	echo "Contact Selected: "
     	sed -n "${contactNo}"p  ./contact.txt #prints out line number of contact based on user input for user approval
	echo
        # Prevents blank input
 	echo -n "Are you sure you want to delete this Contact? [yes or no]: " 
 	read word
	echo
	if [ "$contactNo" -eq 0 ]; # If user input for Contact ID is 0 return to menu
  	then
		clear
	 	echo
		" Return to Menu..."
		echo
        	./menu.sh
  	fi
  elif [ "$num_matches" -eq 1 ]; then # Only one match no need to input Contact ID
	echo -n "Are you sure you want to delete this Contact? [yes or no]: "  # Confirm switch statement
        read word
  else # No matches - new search
	echo " No Matches Found - Try another Search "
   	echo
  fi
elif [ "$search" ==  "0" ] # Exit Code for user - return to menu
then
	clear
        echo
	echo " User Return to Menu"
	echo
        ./menu.sh
else
  echo
  num_matches=0
  echo " Invalid Search - Please Try Again"
  echo
fi
# If statement checks for matches have been found control if user is prompted to confirm delete
if [ "$num_matches" -gt 0 ]; then
  case $word in
	[yY] | [yY][Ee][Ss] ) # Delete confirmed
        clear
	echo 
	echo " User Agreed"
  	  if [ "$num_matches" -eq 1 ]; then  # Reverse grep writes remaining contacts to temp file then to contact.txt
        	grep -i -v "$search" contact.txt>tmpfile && mv tmpfile contact.txt
	  elif [ "$num_matches" -gt 1 ]
	  then
		echo
        	sed -i "${contactNo}"d  ./contact.txt # Deletes line from contact.txt based on user input
          fi
          echo
          echo  " Contact Removed"
          echo  
   	  echo " Updated Contact List: "
          awk -F ';' '{print " " $1 ",", "Email:", $NF}' contact.txt
          echo
     	  ;;
        [nN] | [nN][Oo] ) # User rejects delete returns to menu
	  clear
	  echo
	  echo " User Declined Delete"
      	  echo
          ;;
        [0] ) # User chooses menu
          echo
       	  clear
      	  echo " Return to Menu"
     	  echo
          ./menu.sh
          ;;
        * ) # Invalid try again
          clear
	  echo
          echo -n  " Invalid Input "
          echo
       	;;
  esac
echo
fi
echo
echo " Would you like to:
 1) Return to Main Menu
 2) Remove Another Contact
 3) Exit Application"
echo
# While loop ensures a valid option is enter
while [[ ! "$option" = [1-3] ]]; do
 echo "Please choose one option: "
 read option
 echo 
done
case $option in
        [1] )
          clear
   	  echo
       	  ./menu.sh
      	  ;;
        [2] )
      	  clear
      	  echo
       	  ./remove.sh
       	  ;;
        [3] ) 
          clear
	  echo
	  echo "Exiting Application"
	  echo
          exit 1
          ;;
 esac

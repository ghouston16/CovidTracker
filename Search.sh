#!/bin/bash
# Takes in Search term from user and compares to contact.txt file for matches
echo
echo "Covid-19 Contact Track and Trace -- Contact Search"
echo
echo "Contacts List: "
awk -F ';' '{print " " $1 ",", $NF}' contact.txt #Prints selected fields from Contacts
echo
while [[ "$search" = "" ]]; do 
echo "Please enter the Name or Email of the contact you want to View (Enter the 0 key at anytime to Exit to Menu): " # Reads input from user and stores as search
read search
echo
done
if [ "$search" != 0 ] ; then   #if statement checks that search is not blank or 0
  echo 
  num_matches=`grep -c -i "$search" contact.txt`
  echo "Search Results:  "
  echo
  echo " $num_matches Matches Found"
  echo
  grep -i -n "$search" contact.txt | awk -F ';' '{print " "  $1",", $2",", "Email:",  $NF}'  
  echo
  if [ "$num_matches" -gt 1 ]; then
      	num_contacts=`grep -c "@" contact.txt`
 	while [[ ! "$contactNo" = [0-"$num_contacts"] ]]; do 
        echo "Please enter the Contact ID of the contact you wish to View?: " 
        read contactNo
	echo
	done
        if (( "$contactNo" >= 1  && "$contactNo" <= "$num_contacts" ))  ; then #input validation user must input valid number
                        echo 
                        echo "Contact Selected: "
                        sed -n "${contactNo}"p  ./contact.txt #prints out line number of contact based on user input for user approval
                        echo
        elif [ "$contactNo" == 0 ] # If user input for Contact ID is 0 return to menu
        then
            		clear
                        echo
                        " Return to Menu..."
                        echo
                        ./menu.sh
       	fi
  elif [ "$num_matches" -eq 1 ] # Else if only one match is found
  then 
	echo "Search Results: "
 	grep -i "$search" contact.txt # grep used to output the search result/contact
	echo 
  else # Where no matches are found user is prompted to start try again and  new search starts
   	echo
	echo " No Matches Found - Please try another Search "
  	echo
  fi
elif [ "$search" == "0" ] # Entering 0 at search will bring user back to menu
then
	clear
	echo
	echo " User Return to Menu"
	echo
        ./menu.sh
else # Any other input is invaild
 	echo
	num_matches=0
  	echo "Invalid Search - Please Try Again"
  	echo
fi
echo
 # Case statement offering new search reads input fromuser used for case statement
while [[ "$answer" = "" ]]; do
echo "Would you like to search for another Contact? [Yes or No]: "
        read answer
	echo
	done
        case $answer in
        	[yY] | [yY][Ee][Ss] ) # This will redirect to another Search
        	clear
		echo
		echo "User Agreed"
		echo
        	./Search.sh
        	;;
        	[nN] | [nN][Oo] )  #Back to Menu
        	clear
		echo
        	echo "User Declined -  Return to Menu"
        	echo
        	./menu.sh
		;;
		[0] ) #Return to Menu option
		clear
		echo
        	echo "Return to Menu"
		echo
        	./menu.sh
        	;;
		* ) #any other input is invalid Return to menu
		clear
		echo  "Invalid Input - Return to Menu"
         	echo
                ./menu.sh
                 ;;
       esac

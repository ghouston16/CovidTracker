##!/bin/bash
# This script allows user to search for contacts and send an email to the contact
echo
echo "Covid-19 Contact Track and Trace -- Contact Mailer"
echo
# Outputs Names and Emails of all contacts
echo "Contacts List: "
awk -F ';' '{print " " $1 ",", $NF}' contact.txt
echo
# Prompts user to input Search Term
while [[ "$search" = "" ]]; do
echo  "Please enter the Name or Email of the contact you want to Email (Return to Menu enter 0): "
read search
echo
done
# Checks search Number 0 and outputs any matches from contacts  
if [ "$search" != 0 ]  ; then
  num_matches=`grep -c -i "$search" contact.txt`
  echo "Search Results:  "
  echo
  echo " $num_matches Matches Found"
  echo
  grep -i -n "$search" contact.txt | awk -F ';' '{print " "  $1",", $2",", "Email:",  $NF}'  
  echo
# Checks number of matches - more than 1 match will output numbered list and prompt user to choose
  if [ "$num_matches" -gt 1 ]; then 
	clear
	echo
	num_contacts=`grep -c -i "$email" contact.txt`
	echo "Search Results: "
	echo
	echo " Number of Matches Found: $num_matches"
	echo
	grep -i -n "$search" contact.txt | awk -F ';' '{print " " $1",", $NF}'
 	echo
# While loop ensures a vaild Contact Id is entered
	while [[ !  "$contactNo" = [0-"$num_contacts"] ]]; do
        echo "Please enter the Contact ID of the Contact you wish to email: "
        read contactNo
	echo
	done
        if ((  "$contactNo" >= 1 && "$contactNo" <= "$num_contacts" )); then 
                clear
		echo 
# Selected contact is printed to terminal and written to emaillist file
                echo "Contact Details: "
                sed -n "${contactNo}"p contact.txt>emaillist.txt
		cat emaillist.txt
                echo
# Entering 0 Returns user to menu
        elif [ "$contactNo" -eq 0 ]
        then
		clear
		echo
		echo " User Return to Menu "
        	./menu.sh
        fi
# If only one match is found they are printed and added to emaillist without approval
  elif [ "$num_matches" -eq 1 ] 
  then 	
	clear
	echo
        echo "Search Result: "
        grep -i -n "$search" contact.txt>emaillist.txt
	cat emaillist.txt
	echo
  else
	clear
	echo
   	echo " No Matches Found - Please try another Search "
   	echo
	./mail.sh	
  fi
# If user enters 0 Return to Menu 
elif [ "$search" ==  "0" ] 
then
        echo
	clear
	echo " User return to Menu"
	echo
        ./menu.sh
fi
# If more than 0 matches are found user is asked to confirm they want to email this customer
# While loop stops empty searches & case statement deals with responses
if [ "$num_matches" -gt 0 ]; then
  while [[ "$answer" = "" ]]; do
  echo -n "Would you like to send an email to this Contact? [yes or no]: "
  read answer
  echo
  done
  case $answer in
        [yY] | [yY][Ee][Ss] ) # Leads to email being sent
		# Email address extracted from email list
        	emailaddr=`grep -i "$search" emaillist.txt | awk '{print $NF}'`
		echo
		echo "User Agreed"
       	 	echo 
		while [[ "$subject" = "" ]]; do # While loop prevents empty subject line
        	  echo "Enter Email Subject ( crtl + z  to exit ) "
        	  read subject
        	  echo
		done
		while [[ "$message" = "" ]]; do # Prevents sending blank emails
        	echo "Type your Message and Enter ( ctrl + Z to exit ): "
        	read message
		echo
		done
		# Users message piped to mail command and sent to email of contact with subject line  
        	echo $message | mail  $emailaddr -s "$subject" 
		clear
		echo
        	echo "Email Subject: $subject" 
        	echo "Sent To: $emailaddr"
        	echo
        	;;   
        [nN] | [nN][Oo] ) 
		clear
        	echo
        	echo "User Declined to Email"
        	echo 
        	;;   
        [0] ) # User returns to menu
		clear
		echo
        	echo "Return to Menu"
        	echo
        	./menu.sh
        	;;
        * ) # Any other input is invalid and script restarts
		clear
		echo
        	echo "Invalid Input - Please try Again "
		echo
      	;;
  esac
fi
# Menu options for user 
echo "Would you like to:
 1) Return to Main Menu
 2) Send Another Email
 3) Exit Application "
echo
# While loop ensures a vaild input
while [[ ! "$input" = [1-3] ]]; do
echo "Please choose from above options: "  
read input
echo
done
# Switch statement allows user to choose next action
case $input in
        [1] ) # Return to menu
		clear
		echo
		echo " User Return to Menu "
        	echo
        	./menu.sh
        	;;
        [2] ) # Mail another Contact
		clear
		echo
        	echo  "New Mail Selected"
		echo
		./mail.sh
        	;; 
	[3] ) # Exit Application
		clear
		echo
		echo "Exiting Application"
		echo
		exit 1
		;;
        * ) # Any other input return to menu
	  	clear
		echo
        	echo "Invaild Input - Return to Menu"
        	echo
		./menu.sh
        	;;
esac

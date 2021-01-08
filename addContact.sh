#!/bin/bash
# This script takes values input by the user and if condition are met adds them to contact.txt 
echo " Covid-19 Track & Trace -- Add Contact "
echo 
echo "Follow the prompts below to add a Contact or Enter 0 at any time to Return to Main Menu:"
echo
# Series of while loops to take in contact details
# Each string is vaildated until suitable input given
# 0  returns user to menu at any stage
name=""
# Ensures letters are entered 
while [[ ! "$name" = *[a-z]* ]]; do 
echo "Please enter Full Name: " 
read name 
if [ "$name" = "0" ]; then # User enter 0 at any time to return to menu
	clear
	echo
	echo " User Returned to Menu "
        echo
        ./menu.sh
fi 
done
echo
# Loop functions same as the name input
address=""
while [[ ! "$address" = *[a-z]* ]] ; do
echo "Please enter Contact Address: "
read address
if [ "$address" = "0" ]; then
        clear
	echo
        echo " User Returned to Menu "
        echo
        ./menu.sh
fi 
done
echo 
# Validation loop requires numbers or symbols
phone=""
while [[ ! "$phone" =~ ^[0-9]+$ ]]; do
echo "Please enter phone number: "
read phone
if [ "$phone" = "0" ]; then
       	clear
	echo
        echo " User Returned to Menu "
        echo
        ./menu.sh
fi 
done
echo
# Validation loop requires @ symbol for email (could be improved needs a (.))
email=""
while [[ ! "$email" = *[@]* ]]; do
echo "Please enter Contact E-Mail: "
read email
  if [ "$email" = "0" ]; then
	clear
	echo
        echo " User Returned to Menu "
        echo
        ./menu.sh
  fi 
echo
# If statement checks that email address if not taken
contact_taken=`grep -c -i "$email" contact.txt`
  if [ "$contact_taken" -gt 0 ]; then 
                echo " A Contact with that email address already exists in our records... "
                echo
  fi
done
echo
#  If email is not taken user is shown details and asked to confirm before saving
if [ "$contact_taken" -eq 0 ]; then
  # Details output to terminal for user approval
  echo 
  echo newContact  = "Name: $name, Address:  $address, Phone:  $phone, E-mail:  $email"

# Confirm Add Contact by User input & details are appended to contact.txt
# Case statement Y/N allows user to accept or reject the details
# 0  key returns to menu
  echo 
  echo -n "Are you sure you want to add these details to Contact List? [(Y)es or (N)o]:  "
  read word

  case $word in
	[yY] | [yY][Ee][Ss] ) # Confirms inputs from the loops
	clear
	echo
        echo "User Agreed - Details added to Contact List"
	echo "$name; $address; $phone; $email">>contact.txt # Appends formatted Contact details to file
	echo
	echo "Contacts List: "
	awk -F ';' '{print " " $1 ",", $NF}' contact.txt # Limited details contact list
	echo
        ;;
        [nN] | [nN][Oo] ) # rejects input & return to menu
        clear
	echo
        echo "User Declined to Add Contact"
        echo
        ;;
	0 ) # Exit code
	echo
	clear
	echo "User Chose Return to Menu"
	./menu
	echo 
	;;
        * ) # Any other input - try again. Script runs again.
	echo 
	clear
	echo "Invalid Input - Please try Again"
        echo 
	./addContact.sh
        ;;
  esac
fi
echo "Would you like to:
1) Return to Main Menu
2) Add another Contact
3) Exit Application"
while [[ ! "$option" =  [1-3] ]]; do
echo
echo "Please choose one option:"	
read option
done

# Case statement based on user input for next action
case $option in
	[1] ) # Return to Menu
 	clear
	echo
	./menu.sh
	;;
	[2] ) # Add Another Contact
	clear
	echo
	./addContact.sh
	;;
	[3] ) # Exit
	clear
	echo
	echo " Exiting Application"
	echo
	exit 1
	;;
	* ) 
	clear
	echo
	echo " Invaild Input - Return to Menu"
	echo
	./menu.sh
	;;
esac

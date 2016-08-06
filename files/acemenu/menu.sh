#!/bin/bash

# adapted from
#
#    http://tldp.org/LDP/abs/html/testbranch.html#CASECMD
#    Example 11-30. Creating menus using select
#
# license
#
#    GNU Free Documentation License
#
# Requirements:
#
#    menuitems.txt
#
#    A text file called menuitems.txt should be place in the same directory as this file.
#    Place a single menu description on each line.
#
#    PATH entry
#
#    Path setting in ~/.bashrc or ~/.profile depending on the os. For Ubuntu that would be
#    ~/.bashrc. 
#
# Usage:
#
#    Start a terminal session and enter:
#
#        menu

PS3='Choose your favorite vegetable: ' # Sets the prompt string.
                                       # Otherwise it defaults to #? .

#MENUITEMS='"beans" "carrots" "potatoes" "onions" "rutabagas"'
MENUITEMS=""
while IFS=$'
' read -r line || [[ -n "$line" ]]; do
   MENUITEMS="$MENUITEMS $line"
done < "menuitems.txt"
#echo $ITEMS
echo

select vegetable in $MENUITEMS
do
  cat $vegetable.txt
  echo
  echo "Your favorite veggie is $vegetable."
  echo "Yuck!"
  echo
  break  # What happens if there is no 'break' here?
done

exit

# Exercise:
# --------
#  Fix this script to accept user input not specified in
#+ the "select" statement.
#  For example, if the user inputs "peas,"
#+ the script would respond "Sorry. That is not on the menu."

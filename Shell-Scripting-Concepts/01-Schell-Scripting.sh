#!bin/bash


# What is Shell Scripting ?
# Shell scripting is a practice of writing a series of commands in a file that can be executed by the shell. 
#It allows you to automate tasks, manage system operations, and perform various functions without manual intervention.


echo "Senerio 1::: Every Where You need To Update The Content | Difficult " 

echo "Nirhal:: Hello Nikhil, This is Nirhal From XYZ Company !"
echo "Nikhil:: Hello Nirhal, Nice to Meet you ! "
echo "Nirhal:: Are you intrested in XYZ Company "
echo "Nikhil:: Yes, I am willing to work" 


echo "Senerio 2::: If you Define Variable And Assign Once Place Inside File | Moderate "

PERSON1=Nirhal 
PERSON2=Nikhil
echo "$PERSON1:: Hello $PERSON2, This is $PERSON1 From XYZ Company !"
echo "$PERSON2:: Hello $PERSON1, Nice to Meet you ! "
echo "$PERSON1:: Are you intrested in XYZ Company "
echo "$PERSON2:: Yes, I am willing to work" 


echo "Senerio 3::: Define Variable And Assign with $ it Automatically Assign And pass parameters while Run the code | Easy "

PERSON1=$1 
PERSON2=$2
echo "$PERSON1:: Hello $PERSON2, This is $PERSON1 From XYZ Company !"
echo "$PERSON2:: Hello $PERSON1, Nice to Meet you ! "
echo "$PERSON1:: Are you intrested in XYZ Company "
echo "$PERSON2:: Yes, I am willing to work"


echo " Senerio 4 ::: Secret Files where you define while executing "

echo " Please share your username :: "
read USERNAME 
echo " Username : $USERNAME"

echo " Please enter password :: "
read -s PASSWORD
echo " Password Matched and Successfully Logged In "


echo " Senerio 5 ::: To show The Date "

TIMESTAMP=$(date)
echo " To show the latest Date and Time Details : $TIMESTAMP "


echo " Special Variables" 
echo "=================="

echo " All Arg passed to script : $@"
echo "Number of variables passed to script: $#"
echo "Script name : $0"
echo "present directory : $PWD"
echo "who is running : $USER"
echo "Home directory of current user : $HOME"
echo "PID of the script: $$"
echo "All arg passed to script: $*"

echo " Conditions "

Num=100
Num2=50

if [ $Num2 -gt $Num ]; then
   echo " Bigger Number"
elif [ $Num2 -lt $Num ]; then
   echo "smaller Number"
else 
   echo "equal Numer"
fi


# Practice Code To Create Shell Script With User Input Commands 
echo " Enter the name of the script you want to create: "
read script_name
echo " Enter the commands you want to include in the script (type 'END' to finish): "
commands=""
while true; do
    read command
    if [ "$command" == "END" ]; then
        break
    fi
    commands+="$command"$'\n'
done
echo "$commands" > "$script_name.sh"
echo "Shell script '$script_name.sh' created successfully!"


# To Delete Unwanted Files Using Shell Script
echo " Please enter the file name you want to delete : "
read file_name
if [ -f "$file_name" ]; then
    rm "$file_name"
    echo "File '$file_name' deleted successfully."
else
    echo "File '$file_name' does not exist."
fi


# To delete lot of files in command promt untile user want to stop the process

echo " Please enter the file name you want to delete : "

file_name=""

while true;do
read file_name
 if [ "$file_name" == "scripts.sh" ]; then
        echo "You cannot delete the file 'scripts.sh'. Please enter a different file name."
        break;
    elif [ -f "$file_name" ]; then
        rm "$file_name"
        echo "File '$file_name' deleted successfully!"
    else
        echo "File '$file_name' does not exist."
        echo "Please enter a valid file name to delete: "
    fi
done




# To delete multiple files from the list of files

echo " Please enter the file names you want to delete (separated by space): "
vim "file_name.txt"

while IFS= read -r file_name; do
    if [ -f "$file_name" ]; then
        rm "$file_name"
        echo "File '$file_name' deleted successfully!"
    else
        echo "File '$file_name' does not exist."
    fi
done < "file_name.txt"



Senario 2 :


echo " Please enter the file name you want to delete : "

file_names=""

while true;do
read file_name

    if [ "$file_name" == "scripts.sh" ]; then
        break
    fi

    file_names+="$file_name"$'\n'
  
done

  echo "$file_names" >> "filenames.txt"

while IFS= read -r file_name; do
    if [ -f "$file_name" ]; then
        rm "$file_name"
        echo "file '$file_name' deleted successfully!"
    else
        echo "file '$file_name' does not exist."
        file_names+="$file_name"$'\n'
    fi
done < "filenames.txt"


// For Loop Practice

for i in {1..5}
do
  echo "Iteration $i"
done

// Function Practice

greet() {
  echo "Hello, $1!"
}
greet "Roja"



// To Check Disk Usage and Alert if it Exceeds Threshold

#!/bin/bash
threshold=80
usage=$(df / | grep / | awk '{print $90}' | sed 's/%//') # This command gets the disk usage percentage for the root filesystem
 # The command `df /` shows the disk usage for the root filesystem, `grep /` filters the output to get the line containing the root filesystem, `awk '{print $90}'` extracts the percentage value (you may need to adjust this if your `df` output format is different), and `sed 's/%//'` removes the percentage sign from the value.

if [ $usage -gt $threshold ]; then
  echo "Warning: Disk usage is above $threshold%!"
else
  echo "Disk usage is safe."
fi
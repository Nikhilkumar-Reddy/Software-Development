#!bin/bash

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

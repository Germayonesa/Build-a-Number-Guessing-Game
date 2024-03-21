#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo -e "\n~~~ Guess number GAME ~~~\n"
NUMBER=$(($RANDOM%1000))
echo "$NUMBER"
GUESS=0
let TOTAL=0
echo -e "\nEnter your username:"
read NAME
IS_THERE=$($PSQL "SELECT username FROM customers WHERE username = '$NAME' ") 
     if [[ -z $IS_THERE  ]]
      then 
       echo -e "\nWelcome, $NAME! It looks like this is your first time here."
       INTRO_NAME=$($PSQL "INSERT INTO customers(username,games_played,best_game) VALUES('$NAME',1,0)")    
     else 
       N_GUESS=$($PSQL "SELECT games_played FROM customers WHERE username = '$NAME' ")
       L_GUESS=$($PSQL "SELECT best_game FROM customers WHERE username = '$NAME' ")
       GAMES=$N_GUESS 
       GAMES ++ 
       UPDATE_GAME=$($PSQL "UPDATE customers SET games_played = $GAMES WHERE username = '$NAME' ")
       echo -e "\nWelcome back, $NAME! You have played $N_GUESS games, and your best game took $L_GUESS guesses."  
      fi
echo -e "\nGuess the secret number between 1 and 1000:"      
 while  [[ $GUESS -eq 0 ]]
 do
  read USER_NUMBER
  let TOTAL++
  if [[  $USER_NUMBER =~ ^[0-9]+$ ]]
  then
   if [[ ($USER_NUMBER -ne $NUMBER) && ($NUMBER > $USER_NUMBER) ]]
    then
     echo -e "\nIt's higher than that, guess again:"
    fi
   if [[ ($USER_NUMBER -ne $NUMBER) && ($NUMBER < $USER_NUMBER) ]]
    then
     echo -e "\nIt's lower than that, guess again:"
    fi
   if  [[ $USER_NUMBER == $NUMBER ]]
    then 
     echo -e "\nYou guessed it in $TOTAL tries. The secret number was $NUMBER. Nice job!"
     GUESS=1
     if [[ $L_GUESS -eq 0 ]]
      then
       UPDATE_BEST=$($PSQL "UPDATE customers SET best_game = $TOTAL WHERE username = '$NAME' ")
      fi
     if [[ $L_GUESS -gt $TOTAL ]]
      then
        UPDATE_BEST=$($PSQL "UPDATE customers SET best_game = $TOTAL WHERE username = '$NAME' ")
      fi 
    fi
  else  
   echo -e "\nThat is not an integer, guess again:"
  fi 
 done 

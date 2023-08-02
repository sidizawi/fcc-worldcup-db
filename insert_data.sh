#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WGOALS OGOALS
do
  if [[ $YEAR != 'year' ]]
  then
    # get winner
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

    # if not found
    if [[ -z $WINNER_ID ]]
    then
      # insert winner
      INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      
      if [[ $INSERT_WINNER == 'INSERT 0 1' ]]
      then
        echo Inserted into teams, $WINNER
      fi

      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi


    # get opponent
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    # if not found
    if [[ -z $OPPONENT_ID ]]
    then
      # insert opponent
      INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")

      if [[ $INSERT_OPPONENT == 'INSERT 0 1' ]]
      then
        echo Inserted into teams, $OPPONENT
      fi

      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi

    # insert game
    INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, winner_goals, opponent_id, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $WGOALS, $OPPONENT_ID, $OGOALS)")

    if [[ $INSERT_GAME == 'INSERT 0 1' ]]
    then
      echo Inserted into game, $YEAR $ROUND $WINNER_ID $WGOALS $OPPONENT_ID $OGOALS
    fi

  fi
done

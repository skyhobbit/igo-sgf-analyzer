#!/bin/zsh

# Declare associative arrays to count the number of wins and losses
declare -A WON_b
declare -A WON_w
declare -A LOSE_b
declare -A LOSE_w
declare -A GAMES

# Process SGF files
for SGF in $(ls -1 *.sgf); do
  echo $SGF
  
  # Extract the values of PW, PB, and RE
  PW=$(grep 'PW\[' "$SGF" | perl -ne '/PW\[(.+?)\]/ && print $1')
  PB=$(grep 'PB\[' "$SGF" | perl -ne '/PB\[(.+?)\]/ && print $1')
  RE=$(grep 'RE\[' "$SGF" | perl -ne '/RE\[(.+?)\]/ && print $1')

  # Extract the first two characters of RE
  RE=${RE:0:2}

  # Register the number of games in the GAMES array
  GAMES["$PW"]=$((GAMES["$PW"] + 1))
  GAMES["$PB"]=$((GAMES["$PB"] + 1))

  # Determine the winner and count the wins and losses using associative arrays
  if [ "$RE" = "B+" ]; then
    WON_b["$PB"]=$((WON_b["$PB"] + 1))
    LOSE_w["$PW"]=$((LOSE_w["$PW"] + 1))
  elif [ "$RE" = "W+" ]; then
    WON_w["$PW"]=$((WON_w["$PW"] + 1))
    LOSE_b["$PB"]=$((LOSE_b["$PB"] + 1))
  else
    continue
  fi
done

# Output the winner and the number of wins and losses
for player in ${(ok)GAMES}; do
  # Set the number of wins and losses to 0 if they don't exist
  wins_b=${WON_b[$player]:-0}
  losses_b=${LOSE_b[$player]:-0}
  wins_w=${WON_w[$player]:-0}
  losses_w=${LOSE_w[$player]:-0}
  games=${GAMES[$player]}

  # Skip if the number of games is less than 50
  if [ "$games" -lt 50 ]; then
    continue
  fi

  # Calculate the win rates for black and white
  total_b=$((wins_b + losses_b))
  if [ "$total_b" -gt 0 ]; then
    win_rate_b=$(printf "%.2f" "$(echo "scale=4; ($wins_b / $total_b) * 100" | bc)")
  else
    win_rate_b="0.00"
  fi
  total_w=$((wins_w + losses_w))
  if [ "$total_w" -gt 0 ]; then
    win_rate_w=$(printf "%.2f" "$(echo "scale=4; ($wins_w / $total_w) * 100" | bc)")
  else
    win_rate_w="0.00"
  fi

  # Calculate the difference in win rates
  win_rate_diff=$(printf "%.2f" "$(echo "scale=4; $win_rate_b - $win_rate_w" | bc)")

  # Display the results
  printf "%-20s Black: %3d wins %3d losses %6s%%  White: %3d wins %3d losses %6s%% Rate Diff: %6s%%\n" "$player" "$wins_b" "$losses_b" "$win_rate_b" "$wins_w" "$losses_w" "$win_rate_w" "$win_rate_diff"
done

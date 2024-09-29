#!/bin/zsh

# 対象ディレクトリ
TARGET_DIR="./"

# 勝利数と敗北数をカウントするための連想配列を宣言
declare -A WON_b
declare -A WON_w
declare -A LOSE_b
declare -A LOSE_w
declare -A GAMES

# SGFファイルを処理
for YEAR in $(ls -d ${TARGET_DIR}); do
  for SGF in $(ls -1 ${YEAR}/*.sgf); do
    echo $SGF
    
    # PW, PB, RE の値を抽出
    PW=$(grep 'PW\[' "$SGF" | perl -ne '/PW\[(.+?)\]/ && print $1')
    PB=$(grep 'PB\[' "$SGF" | perl -ne '/PB\[(.+?)\]/ && print $1')
    RE=$(grep 'RE\[' "$SGF" | perl -ne '/RE\[(.+?)\]/ && print $1')
    
    # REの先頭2文字を抽出
    RE=${RE:0:2}

    # 試合数を GAMES 配列に登録
    GAMES["$PW"]=$((GAMES["$PW"] + 1))
    GAMES["$PB"]=$((GAMES["$PB"] + 1))

    # 勝者を判定し、連想配列で勝利数と敗北数をカウント
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
done

# 勝者と勝利数、敗北数を出力
echo "勝利数の結果:"
for player in ${(ok)GAMES}; do
  # 勝利数と敗北数がない場合は0にする
  wins_b=${WON_b[$player]:-0}
  losses_b=${LOSE_b[$player]:-0}
  wins_w=${WON_w[$player]:-0}
  losses_w=${LOSE_w[$player]:-0}
  games=${GAMES[$player]}

  # 試合数が10試合未満の場合はスキップ
  if [ "$games" -lt 40 ]; then
    continue
  fi

  # 黒番と白番の勝率を計算
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

  # 勝率の差を計算
  win_rate_diff=$(printf "%.2f" "$(echo "scale=4; $win_rate_b - $win_rate_w" | bc)")

  # 結果を表示
  printf "%-20s 黒番: %3d 勝 %3d 敗 %6s%%  白番: %3d 勝 %3d 敗 %6s%% 勝率差: %6s%%\n" "$player" "$wins_b" "$losses_b" "$win_rate_b" "$wins_w" "$losses_w" "$win_rate_w" "$win_rate_diff"
done

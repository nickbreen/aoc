#!/bin/bash

declare -i safe_levels_count=0 total_levels_count=0

function all_safe()
{
  local -i min=$1 max=$2
  local -i -a deltas=(${@:3})
  for delta in ${deltas[@]}
  do
    if ((delta < min || max < delta))
    then
      return 1
    fi
  done
}

function deltas_are_safe {
  all_safe 1 3 $@ || all_safe -3 -1 $@
}

while read -a levels
do
  total_levels_count+=1
  declare -a deltas
  for ((i=1; i<${#levels[@]}; i++))
  do
    deltas[$i-1]=$((${levels[$i]} - ${levels[$i-1]}))
  done

  if deltas_are_safe ${deltas[@]}
  then
    safe_levels_count+=1
  fi
  unset deltas
done

echo $safe_levels_count/$total_levels_count
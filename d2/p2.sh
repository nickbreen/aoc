#!/bin/bash

declare -i safe_levels_count=0

while read -a levels
do
  for ((i=0; i<${#levels[@]}; i++))
  do
    declare -a some_levels=(${levels[@]})
    unset some_levels[$i]
    echo ${some_levels[@]}
  done | bash ./p1.sh || safe_levels_count+=1
done

echo $safe_levels_count
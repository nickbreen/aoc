#!/bin/bash

declare -ai a1  
declare -Ai c2

while read n1 n2
do
  a1+=($n1)
  let c2[$n2]++
done

declare -i n=0

for ((i=0; i<${#a1[@]}; i++))
do
  let n+=${a1[$i]}*${c2[${a1[$i]}]=0}
done
echo $n


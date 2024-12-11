#!/bin/bash

declare -ai a1 a2 s1 s2 

while read n1 n2
do
  a1+=($n1)
  a2+=($n2)
done

#printf "a1 [%d]\n" ${a1[@]}
#printf "a2 [%d]\n" ${a2[@]}

IFS=$'\n' s1=($(sort <<< "${a1[*]}"))
IFS=$'\n' s2=($(sort <<< "${a2[*]}"))

#printf "s1 [%d]\n" ${s1[@]}
#printf "s2 [%d]\n" ${s2[@]}
echo ${s1[@]}
echo ${s2[@]}

declare -i n=0

for ((i=0; i<${#s1[@]}; i++))
do
 if [ ${s1[$i]} -gt ${s2[$i]} ]
 then
  let n+=${s1[$i]}-${s2[$i]}
 elif [ ${s1[$i]} -lt ${s2[$i]} ]
 then
  let n+=${s2[$i]}-${s1[$i]}
 fi
done
echo $n


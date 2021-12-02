#!/usr/bin/env bash

declare -a depths
read -a depths -d'\0'
declare -a depth_windows

for i in "${!depths[@]}"; do
  let i0=i+0
  let i1=i+1
  let i2=i+2
  test ${depths[$i2]-} || break
  test ${depths[$i1]-} || break
  let depth_windows[$i]=depths[$i0]+depths[$i1]+depths[$i2]
done

echo ${depth_windows[@]} | tr ' ' '\n'

# then pipe into count_increases

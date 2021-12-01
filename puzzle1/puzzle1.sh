#!/usr/bin/env bash

read current_depth  # initial measurement

echo "$current_depth (N/A - no previous measurement)" >&2

while read depth
do
  if [ $depth -gt $current_depth ]
  then
    echo "$depth (increased)"
    let increased_count++
  else
    echo "$depth (decreased)"
  fi
  current_depth=$depth
done >&2

echo ${increased_count-0}

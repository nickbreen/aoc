#!/usr/bin/env bash

./fish.awk -vdays=80 test.fish.txt
./fish.awk -vdays=80 data.fish.txt

./fish.awk -vdays=256 test.fish.txt
./fish.awk -vdays=256 data.fish.txt

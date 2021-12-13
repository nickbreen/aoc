#!/usr/bin/env bash

./fold.awk -vpart=1 test.fold.txt data.fold.txt

./fold.awk -vpart=2 test.fold.txt data.fold.txt
#!/usr/bin/env bash

./low_points.awk test.lava.txt
./low_points.awk data.lava.txt

./basins.awk test.lava.txt
./basins.awk data.lava.txt
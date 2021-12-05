#!/usr/bin/env bash

./vents.awk test.vents.txt
./vents.awk data.vents.txt

./vents_diag.awk test.vents.txt
./vents_diag.awk data.vents.txt

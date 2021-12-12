#!/usr/bin/env bash

./paths_to_dot.awk tiny.paths.txt test.paths.txt large.paths.txt data.paths.txt | dot -Tsvg -O

./paths1.awk tiny.paths.txt test.paths.txt large.paths.txt data.path.txt
./paths2.awk tiny.paths.txt test.paths.txt large.paths.txt data.path.txt



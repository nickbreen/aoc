#!/usr/bin/env bash

./paths_to_dot.awk tiny.paths.txt | dot -Tsvg > tiny.paths.svg

./paths.awk tiny.paths.txt test.paths.txt large.paths.txt data.path.txt



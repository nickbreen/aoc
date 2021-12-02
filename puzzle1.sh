#!/usr/bin/env bash

# Part 1
./count_increases.awk < test.depths.txt
./count_increases.awk < data.depths.txt

# Part 2
./moving_sum.awk < test.depths.txt | ./count_increases.awk
./moving_sum.awk < data.depths.txt | ./count_increases.awk
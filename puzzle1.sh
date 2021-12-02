#!/usr/bin/env bash

./count_increases.awk < test.depths.txt
./count_increases.awk < data.depths.txt

./moving_sum.awk < test.depths.txt | ./count_increases.awk
./moving_sum.awk < data.depths.txt | ./count_increases.awk
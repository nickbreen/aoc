#!/usr/bin/env bash

./count_increases.awk < test.txt
./count_increases.awk < data.txt

./moving_sum.awk < test.txt | ./count_increases.awk
./moving_sum.awk < data.txt | ./count_increases.awk
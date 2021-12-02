#!/usr/bin/env bash

./count_increases.awk < test.txt
./count_increases.awk < data.txt

./moving_sum.awk -vwindow_size=3 < test.txt | ./count_increases.awk
./moving_sum.awk -vwindow_size=3 < data.txt | ./count_increases.awk
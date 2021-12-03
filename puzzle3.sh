#!/usr/bin/env bash

set -euo pipefail

# Part 1

./gamma_epsilon.awk test.diag.txt
./gamma_epsilon.awk data.diag.txt

# Part 2

read diag < test.diag.txt
test_round_input=test.diag.txt
for i in $(seq 0 ${#diag})
do
  new_filter=$(./filter.awk $test_round_input)
  filter=${filter+${filter:0:$i}}${new_filter:$i:1}
  echo filter=${filter}
  grep ^${filter} $test_round_input > test.diag.o2.$i.txt || break
  test_round_input=test.diag.o2.$i.txt
done
o2_generator_rating=$(<$test_round_input)
echo oxygen generator rating $o2_generator_rating $((2#$o2_generator_rating))

unset filter
test_round_input=test.diag.txt
for i in $(seq 0 ${#diag})
do
  new_filter=$(./filter.awk $test_round_input | tr 01 10)
  filter=${filter+${filter:0:$i}}${new_filter:$i:1}
  echo filter=${filter}
  grep ^${filter} $test_round_input > test.diag.co2.$i.txt || break
  test_round_input=test.diag.co2.$i.txt
done
co2_scrubber_rating=$(<$test_round_input)
echo CO2 scrubber rating $co2_scrubber_rating $((2#$co2_scrubber_rating))

bc <<< "ibase=2;obase=A;$co2_scrubber_rating * $o2_generator_rating"

read diag < data.diag.txt
test_round_input=data.diag.txt
for i in $(seq 0 ${#diag})
do
  new_filter=$(./filter.awk $test_round_input)
  filter=${filter+${filter:0:$i}}${new_filter:$i:1}
  echo filter=${filter}
  grep ^${filter} $test_round_input > test.diag.o2.$i.txt || break
  test_round_input=test.diag.o2.$i.txt
done
o2_generator_rating=$(<$test_round_input)
echo oxygen generator rating $o2_generator_rating $((2#$o2_generator_rating))

unset filter
test_round_input=data.diag.txt
for i in $(seq 0 ${#diag})
do
  new_filter=$(./filter.awk $test_round_input | tr 01 10)
  filter=${filter+${filter:0:$i}}${new_filter:$i:1}
  echo filter=${filter}
  grep ^${filter} $test_round_input > test.diag.co2.$i.txt || break
  test_round_input=test.diag.co2.$i.txt
done
co2_scrubber_rating=$(<$test_round_input)
echo CO2 scrubber rating $co2_scrubber_rating $((2#$co2_scrubber_rating))

bc <<< "ibase=2;obase=A;$co2_scrubber_rating * $o2_generator_rating"
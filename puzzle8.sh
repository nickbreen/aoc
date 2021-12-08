#!/usr/bin/env bash

./digits1.awk <<< "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"
./digits1.awk test.digits.txt
./digits1.awk data.digits.txt

./digits2.awk <<< "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"
./digits2.awk test.digits.txt
./digits2.awk data.digits.txt


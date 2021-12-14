#!/usr/bin/env bash

./poly.awk -vrounds=10 test.poly.txt data.poly.txt

./poly2.awk -vrounds=40 test.poly.txt data.poly.txt

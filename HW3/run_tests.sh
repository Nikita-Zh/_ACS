#!/bin/bash

for i in {1..10}
do
  echo "test $i"
  python ./main.py Tests/Input/test"$i".txt Tests/Output/test"$i".txt
done
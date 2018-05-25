#!/bin/bash

declare -a myarray

# Load file into array.
readarray myarray < ./test

# Explicitly report array content.
let i=0
while (( ${#myarray[@]} > i )); do
    printf "${myarray[i++]}\n"
done
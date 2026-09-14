# Parameterised ALU

## Functionality
An ALU that does basic operations with bit number parameterized
Arithmetic: Add, Subtract, Multiply Divide
Logic, AND, OR, XOR, NOT

## How to compile
> make test
Tests the ALU as 8 bits
> make clean
Cleans the waveform file

This repo uses preprocessor directives to allow different bit number to be compiled each time.
Example: To make and test an 8 bit ALU
make test N=8
If N is not specified N=8 by default

## Testbench 
Testbench currently only works with 8 bits, work in progress.

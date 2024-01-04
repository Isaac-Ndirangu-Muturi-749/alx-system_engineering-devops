#!/usr/bin/env ruby

# Check if there is exactly one command-line argument
if ARGV.length != 1
    puts "Usage: #{$PROGRAM_NAME} <string>"
    exit 1
  end

  # Extract the argument
  input_string = ARGV[0]

  # Define the regular expression pattern
  pattern = /School/

  # Check if the input string matches the pattern
  if input_string =~ pattern
    puts "#{input_string}$"
  else
    puts "$"
  end

#!/usr/bin/env ruby
# Ruby script to match the word "School" using regular expressions

# Check if an argument is provided
if ARGV.empty?
  puts "Usage: #{$PROGRAM_NAME} <input_string>"
  exit 1
end

# Get the input string from the command line argument
input_string = ARGV.join(' ')

# Define the regular expression
regex = /School/

# Check for matches in the input string
matches = input_string.scan(regex)

# Display the matches
puts matches.join('$')

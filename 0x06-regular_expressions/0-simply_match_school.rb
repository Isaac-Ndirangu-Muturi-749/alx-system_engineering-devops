#!/usr/bin/env ruby
# Ruby script to match the word "School" using regular expressions

# Get the input string from the command line argument
first_argument_string = ARGV[0]

# Define the regular expression
regex = /School/

# Check for matches in the first argument
matches = first_argument_string.scan(regex)

# Display the matches
puts matches.join

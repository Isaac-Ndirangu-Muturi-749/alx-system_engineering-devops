#!/usr/bin/env ruby

# Define the regular expression
regex = /School/

# Check for matches from the first command line argument
matches = ARGV[0].scan(regex)

# Display the matches
puts matches.join

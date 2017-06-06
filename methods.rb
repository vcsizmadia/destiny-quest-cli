puts '... methods.rb'.light_black

# @version 20170430
def hp(string)
  puts ''
  puts ('*' * (string.length + 4)).light_black
  puts "* #{string} *".light_black
  puts ('*' * (string.length + 4)).light_black
end

# @version 20170531
def pad(string, length)
  "%-#{length}.#{length}s" % string
end

# @note Unfortuantely, this does not work with the 'colorize' gem.
# @version 20170521
def stylize(string)
  # Bold
  # string.gsub(' _', " \e[1m").gsub('_ ', "\e[22m ")

  # Underline
  string.gsub(' _', " \e[4m").gsub('_ ', "\e[24m ").gsub('_.', "\e[24m.")
end

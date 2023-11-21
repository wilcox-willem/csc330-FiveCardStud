# ARGS variable contains the command line arguments in order,
# in this case it is the file we want to read
f = open(ARGS[1],"r")

# Read in ALL of the hand into a single string
allhands = read(f, String)
close(f)

# Print out the hands
println(allhands)

# Create a card token array by splitting the allhands string
cards = split(allhands,[',','\n'], keepempty=false)

println("there are " * string(length(cards)) * " tokens")

# Print out the tokens after stripping the spaces
for i in 1:length(cards)
  println(strip(cards[i]))
end

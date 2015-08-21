#!

treemix -i FileName.txt.gz -m x -o migx

> source("/Users/ProJoey/Downloads/treemix-1.12/src/plotting_funcs.R")



> plot_tree("result9")

> plot_resid("result9", "poporder")


threepop -i FileName.txt.gz > FileName.3pop

foupop -i FileName.txt.gz > FileName.4pop


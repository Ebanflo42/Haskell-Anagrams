# Haskell-Anagrams
A Haskell program that finds the anagrams of a string (taken as input) in a text file

The file is called "words.txt" and I haven't included it in the repository because its the list of every word in the English language found on most computers; mine was in `/usr/share/dict/`.

The program begins by filtering out every word that isn't composed completely of lowercase letters. Then every word in the list, and the user input, is converted to an integer array with the entry at a given index representing the number of occurences of the corresponding character. Any strings that have the same integer array will be a permutation of each other. This principle could easily be extended to check for permutations of arbitrary strings by using lists instead of arrays to represent the number of occurencees of different characters.

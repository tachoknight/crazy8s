# Crazy Eights

## tl;dr
The game [Crazy Eights](https://en.wikipedia.org/wiki/Crazy_Eights) implemented in Swift (Swift 4 compatible).

## Rationale
My daughter taught me the game [Crazy Eights](https://en.wikipedia.org/wiki/Crazy_Eights) while we were on vacation and it seemed like it was easy enough to implement as a way to learn how to do cross Linux/macOS Swift development, where the macOS verison was still using 2.2 syntax, while Linux uses a Swift 3 preview build. I also wanted to write a self-playing game. 

### macOS
The project was originally written on macOS so it includes the usual XCode-specific files. 
### Linux
For building in Linux all you have to do is run
`swiftc -DDEBUG card.swift extensions.swift main.swift player.swift`
to produce an executable. `-DDEBUG` is necessary to see any output in this version.

## Playing
In `main.swift` there are three constants, `PLAYERS`, `DECKS`, and `CARDCOUNT` that determine the number of players in the game, the number of decks of cards, and how many cards the players hold (my daughter insisted this be changeable as her rules seemd to be at odds with the `official' Wikipedia version). For a 'quick' game, setting these values to reasonable numbers (four players, eight cards per hand, one deck) results in a quick-ish game that you can use to test any tweaks to the game algorithm. For yucks I upped the number of players to 15,000 with 5,000 decks of cards; "shuffling" the cards takes the longest amount of time, it turns out, than playing the game itself.

## Files
### `main.swift`
The main file of the game, where the number of players, cards-in-hand, and decks are determined. The game itself is played in this file.
### `card.swift`
This file contains enums for setting up the deck (and learning Swift enums was one of the reasons why I started the project, as they seem to be similar and even more powerful to the Java Enum), as well as the `Card` structure, and a function to create an array of cards (`createDeck()`).
### `extensions.swift`
This is one of the things I love most about Swift (and Objective-C) is the ability to add methods to a class without dealing with inheritance. These extensions are used for in-place 'shiffling', as well as extending `Dictionary` to allow for using the `Card` struct as a key.
### `player.swift`
This is where the 'brains' of the game are. The player decides which card to play (and where the rules of the game are essentially implemented), in the function `canPlayOn(deckCard:orSuit:)`. It doesn't have much 'strategy' insofar as it plays the game according to the rules. Feel free to try your own strategies here.

import Foundation

//
// For Linux:
// swiftc -DDEBUG card.swift extensions.swift main.swift player.swift
//

var c8Game = Crazy8Game(playerCount: 4)
c8Game.playGame()

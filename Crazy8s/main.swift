import Foundation

//
// For Linux:
// swiftc -DDEBUG game.swift card.swift extensions.swift main.swift player.swift
//


func showOutput(_ text: String) {
    let timeDelay = DispatchTime.now() + .seconds(60)
    DispatchQueue.main.asyncAfter(deadline: timeDelay) {
        print(text)
    }
}

var c8Game = Crazy8Game(playerCount: 10)
c8Game.playGame()

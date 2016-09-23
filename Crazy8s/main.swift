import Foundation
import Dispatch

//
// For Linux:
// swiftc -DDEBUG game.swift card.swift extensions.swift main.swift player.swift
//

let backgroundQueue = DispatchQueue(label: "game.queue",
                                    attributes: .concurrent)

let serialQueue = DispatchQueue(label: "log.queue")

// http://ericasadun.com/2016/03/08/swift-queue-fun/
public struct Queue<T>: ExpressibleByArrayLiteral {
    /// backing array store
    public private(set) var elements: Array<T> = []
    
    /// introduce a new element to the queue in O(1) time
    public mutating func push(_ value: T) {
        serialQueue.sync {
            elements.append(value)
        }
    }
    
    /// remove the front of the queue in O(`count` time
    public mutating func pop() -> T? {
        var retValue: T? = nil
        
        serialQueue.sync {
            if isEmpty == false {
                retValue = elements.removeFirst()
            }
        }
        
        return retValue
    }
    
    /// test whether the queue is empty
    public var isEmpty: Bool { return elements.isEmpty }
    
    /// queue size, computed property
    public var count: Int {
        var count: Int = 0
        
        serialQueue.sync {
            count = elements.count
        }
        return count
    }
    
    /// offer `ArrayLiteralConvertible` support
    public init(arrayLiteral elements: T...) {
        serialQueue.sync {
            self.elements = elements
        }
    }
}

var gameQueue = Queue<String>()

func showOutput(_ text: String) {
    //backgroundQueue.async {
    gameQueue.push(text)
    //}
}

/*
 func showOutput(_ text: String) {
 let timeDelay = DispatchTime.now() + .seconds(60)
 /*
 DispatchQueue.main.asyncAfter(deadline: timeDelay) {
 print(text)
 }
 */
 /*
 backgroundQueue.async {
 print(text)
 }
 */
 serialQueue.sync {
 print(text)
 }
 }
 */

#if os(Linux)
    srand(UInt32(time(nil)))
#endif

var simutaneousGames = 50
for num in 0 ..< simutaneousGames {
    print("Starting game \(num)")
    backgroundQueue.async {
        #if os(Linux)
            let numOfPlayers = Int(random() % 1000)
        #else
            let numOfPlayers = Int(arc4random_uniform(1000) + 1)
        #endif
        var c8Game = Crazy8Game(playerCount: numOfPlayers, gameNumber: (num + 1))
        c8Game.playGame()
    }
}

var logLine: String = ""
var allGamesDone = false
var gameDoneCount = 0
repeat {

    guard let logLine = gameQueue.pop() as Optional else {
        continue
    }
    if (logLine.contains("ZZZZZ")) {
        gameDoneCount += 1
        if gameDoneCount == simutaneousGames {
            allGamesDone = true
        }
    }
    
    print(logLine)
    sleep(1)
} while allGamesDone == false

//sleep(60*5)

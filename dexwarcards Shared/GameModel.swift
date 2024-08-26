import Foundation

class GameModel {
    var deck: [Card] = []
    var player: Player
    var computer: Player
    var currentPlayer: PlayerType = .player
    var mathModel: MathModel
    var gameIsOver: Bool = false

    enum PlayerType {
        case player, computer
    }

    init() {
        self.player = Player(identifier: "Human")
        self.computer = Player(identifier: "Computer")
        self.mathModel = MathModel(exponentForStrength: 2.0, multiplierForAgility: 3, bonusForIntelligence: 5, penaltyForDefense: 2)
        loadDeck()
        shuffleDeck()
        dealInitialHands()
    }

    private func loadDeck() {
        // Ensure your path and plist structure correctly matches your project setup
        if let path = Bundle.main.path(forResource: "CardAttributes", ofType: "plist"),
           let array = NSArray(contentsOfFile: path) as? [[String: Any]] {
            for dict in array {
                if let identifier = dict["identifier"] as? String,
                   let monsterName = dict["monsterName"] as? String,
                   let strength = dict["strength"] as? Int,
                   let agility = dict["agility"] as? Int,
                   let intelligence = dict["intelligence"] as? Int,
                   let defense = dict["defense"] as? Int {
                    let card = Card(identifier: identifier, monsterName: monsterName, strength: strength, agility: agility, intelligence: intelligence, defense: defense)
                    deck.append(card)
                }
            }
        }
    }

    func shuffleDeck() {
        deck.shuffle()
    }

    func dealInitialHands() {
        for _ in 0..<5 {
            if !deck.isEmpty {
                player.hand.append(deck.removeFirst())
                computer.hand.append(deck.removeFirst())
            }
        }
    }

    func resetGame() {
        deck += player.hand + computer.hand
        player.hand.removeAll()
        computer.hand.removeAll()
        shuffleDeck()
        dealInitialHands()
        gameIsOver = false
        currentPlayer = .player
    }
}

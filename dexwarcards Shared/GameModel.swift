import Foundation

class GameModel {
    // MARK: Properties
    var deck: [Card]
    var playerHand: [Card]
    var computerHand: [Card]
    var currentPlayer: PlayerType
    var mathModel: MathModel
    var gameIsOver: Bool
    
    // MARK: Enums
    enum PlayerType {
        case player
        case computer
    }
    
    // MARK: Initializer
    init() {
        self.deck = []
        self.playerHand = []
        self.computerHand = []
        self.currentPlayer = .player
        self.mathModel = MathModel(exponentForStrength: 2.0, multiplierForAgility: 3, bonusForIntelligence: 5, penaltyForDefense: 2)
        self.gameIsOver = false
        
        initializeDeck()
        dealInitialHands()
    }
    
    // MARK: Game Setup
    private func initializeDeck() {
        // Placeholder for creating cards with unique identifiers and attributes
        // Normally, you would have a function to generate these based on your asset files or data
        for id in 1...52 {
            let card = Card(identifier: "Card\(id)", imageName: "CardImage\(id)", strength: Int.random(in: 1...10), agility: Int.random(in: 1...10), intelligence: Int.random(in: 1...10), defense: Int.random(in: 1...10))
            deck.append(card)
        }
        deck.shuffle()
    }
    
    private func dealInitialHands() {
        for _ in 1...5 {
            playerHand.append(deck.removeFirst())
            computerHand.append(deck.removeFirst())
        }
    }
    
    // MARK: Gameplay Mechanics
    func playCard(from player: PlayerType, card: Card) -> Bool {
        guard let cardIndex = (player == .player ? playerHand.firstIndex(of: card) : computerHand.firstIndex(of: card)) else { return false }
        
        let opponentCard = drawComputerCard() // Simulates computer drawing a card
        resolveRound(playerCard: card, computerCard: opponentCard)
        checkGameOver()
        
        return true
    }
    
    private func drawComputerCard() -> Card {
        let cardIndex = Int.random(in: 0..<computerHand.count)
        return computerHand.remove(at: cardIndex)
    }
    
    private func resolveRound(playerCard: Card, computerCard: Card) {
        let playerPower = playerCard.calculatePower(with: mathModel)
        let computerPower = computerCard.calculatePower(with: mathModel)
        
        if playerPower > computerPower {
            playerHand += [playerCard, computerCard]
            currentPlayer = .player
        } else {
            computerHand += [playerCard, computerCard]
            currentPlayer = .computer
        }
    }
    
    private func checkGameOver() {
        if playerHand.isEmpty || computerHand.isEmpty {
            gameIsOver = true
        }
    }
}

extension GameModel {
    func resetGame() {
        deck += playerHand + computerHand
        playerHand.removeAll()
        computerHand.removeAll()
        gameIsOver = false
        initializeDeck()
        dealInitialHands()
    }
}

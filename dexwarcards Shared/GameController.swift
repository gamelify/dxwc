import Foundation

class GameController {
    // MARK: Properties
    var player: Player
    var computer: Player
    var deck: [Card]
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
        // Initialize players
        player = Player(identifier: "Human")
        computer = Player(identifier: "Computer")
        
        // Setup the deck
        deck = []
        for id in 1...52 {
            let card = Card(identifier: "Card\(id)", imageName: "CardImage\(id)", strength: Int.random(in: 1...10), agility: Int.random(in: 1...10), intelligence: Int.random(in: 1...10), defense: Int.random(in: 1...10))
            deck.append(card)
        }
        deck.shuffle()
        
        // Define the math model
        mathModel = MathModel(exponentForStrength: 2.0, multiplierForAgility: 3, bonusForIntelligence: 5, penaltyForDefense: 2)

        // Game state initialization
        currentPlayer = .player
        gameIsOver = false

        // Deal initial hands
        dealInitialHands() // Moved to after all properties are initialized
    }
    
    // MARK: Game Setup
    private func dealInitialHands() {
        for _ in 0..<5 {
            player.drawCard(from: &deck)
            computer.drawCard(from: &deck)
        }
    }
    
    // MARK: Game Logic
    func startGame() {
        while !gameIsOver {
            let activePlayer = currentPlayer == .player ? player : computer
            let passivePlayer = currentPlayer == .computer ? player : computer
            
            if currentPlayer == .player {
                // Human player turn logic here
                print("Player's turn to play.")
            } else {
                // Computer AI logic to select and play a card
                if let cardToPlay = computer.calculateBestMove(opponentCard: player.hand.first!, mathModel: mathModel) {
                    playCard(player: computer, card: cardToPlay)
                }
            }
            
            // Check game over condition
            checkGameOver()
        }
    }
    
    func playCard(player: Player, card: Card) {
        guard let index = player.hand.firstIndex(of: card) else { return }
        let cardPlayed = player.playCard(at: index)!
        
        let opponent = player === self.player ? computer : self.player
        let opponentCard = opponent.playCard(at: 0)! // Simplification: opponent plays the first card
        
        // Resolve round
        resolveRound(playerCard: cardPlayed, computerCard: opponentCard)
        
        // Switch turns
        currentPlayer = currentPlayer == .player ? .computer : .player
    }
    
    private func resolveRound(playerCard: Card, computerCard: Card) {
        let playerPower = playerCard.calculatePower(with: mathModel)
        let computerPower = computerCard.calculatePower(with: mathModel)
        
        if playerPower > computerPower {
            player.hand.append(contentsOf: [playerCard, computerCard])
            print("Player wins the round!")
        } else {
            computer.hand.append(contentsOf: [playerCard, computerCard])
            print("Computer wins the round!")
        }
    }
    
    private func checkGameOver() {
        if player.hand.isEmpty || computer.hand.isEmpty {
            gameIsOver = true
            print("Game Over!")
        }
    }
    
    // MARK: Utility Functions
    func resetGame() {
        deck += player.hand + computer.hand
        player.hand.removeAll()
        computer.hand.removeAll()
        deck.shuffle()
        dealInitialHands()
        gameIsOver = false
        currentPlayer = .player
    }
}

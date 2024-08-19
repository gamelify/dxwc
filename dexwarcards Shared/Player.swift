import Foundation

class Player {
    // MARK: Properties
    var hand: [Card]
    var identifier: String
    
    // MARK: Initializer
    init(identifier: String) {
        self.hand = []
        self.identifier = identifier
    }
    
    // MARK: Methods
    func drawCard(from deck: inout [Card]) -> Bool {
        guard !deck.isEmpty else { return false }
        let card = deck.removeFirst()
        hand.append(card)
        return true
    }
    
    func playCard(at index: Int) -> Card? {
        guard index >= 0 && index < hand.count else { return nil }
        return hand.remove(at: index)
    }
    
    func calculateBestMove(opponentCard: Card, mathModel: MathModel) -> Card? {
        // The strategy here is simple: find the card in hand that maximizes the player's chance to win against the opponentCard
        // This is a basic strategy and can be expanded based on more complex game rules and player AI
        let possibleMoves = hand.map { ($0, $0.calculatePower(with: mathModel)) }
        let opponentPower = opponentCard.calculatePower(with: mathModel)
        
        // Return the card with the closest higher power than the opponent's, if available
        let bestMove = possibleMoves.filter { $0.1 > opponentPower }
                                    .min(by: { $0.1 < $1.1 })
        return bestMove?.0
    }
    
    // Debugging and information
    func printHand() {
        print("Player \(identifier)'s hand:")
        hand.forEach { print("\($0.description)") }
    }
}


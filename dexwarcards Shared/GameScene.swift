import SpriteKit

class GameScene: SKScene {
    fileprivate var gameController: GameController!

    // MARK: - Scene Initialization
    class func newGameScene() -> GameScene {
        let scene = GameScene(size: CGSize(width: 1024, height: 768))
        scene.scaleMode = .aspectFill
        return scene
    }

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        gameController = GameController()
        displayCards()
    }

    // MARK: - Display Cards
    func displayCards() {
        removeAllChildren() // Clear the scene first
        let baseX = 100
        let cardSpacing = 120 // Space between cards
        for (index, card) in gameController.model.player.hand.enumerated() {
            let cardNode = SKSpriteNode(imageNamed: card.imageName)
            cardNode.name = "\(index)"
            cardNode.position = CGPoint(x: baseX + index * cardSpacing, y: 150) // Adjust position calculation as needed
            cardNode.setScale(0.5) // Scale down the card image
            addChild(cardNode)
        }
    }

    // MARK: - Interaction Handling
    func handleCardSelection(at position: CGPoint) {
        let nodes = self.nodes(at: position)
        for node in nodes {
            if let name = node.name, name.starts(with: "card"), let index = Int(name.dropFirst(4)), let card = gameController.model.player.hand[safe: index] {
                if let opponentCard = gameController.model.computer.hand.first {
                    gameController.resolveTurn(cardPlayed: card, opponentCard: opponentCard)
                    updateScene()
                }
                break
            }
        }
    }

    func updateScene() {
        displayCards() // Re-display cards with updated hand
    }

    // Platform-specific interaction handling
    #if os(iOS) || os(tvOS)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        handleCardSelection(at: touch.location(in: self))
    }

    #elseif os(OSX)
    override func mouseDown(with event: NSEvent) {
        handleCardSelection(at: event.location(in: self))
    }
    #endif
}

import SpriteKit

class GameScene: SKScene {
    // MARK: Properties
    fileprivate var label: SKLabelNode?
    fileprivate var gameController: GameController!
    
    // MARK: Scene Creation
    class func newGameScene() -> GameScene {
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        scene.scaleMode = .aspectFill
        return scene
    }
    
    func setUpScene() {
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }

        // Initialize the game controller
        gameController = GameController()
        displayCards()
    }
    
    override func didMove(to view: SKView) {
        self.setUpScene()
    }
    
    // MARK: Gameplay Helpers
    func displayCards() {
        for (index, card) in gameController.player.hand.enumerated() {
            let cardNode = SKSpriteNode(imageNamed: card.imageName)
            cardNode.name = "card\(index)"
            cardNode.position = CGPoint(x: 100 + index * 50, y: 100) // Adjust position calculation as needed
            cardNode.setScale(0.5) // Scale down card image
            addChild(cardNode)
        }
    }
    
    // MARK: Interaction Handling
    func handleCardSelection(at position: CGPoint) {
        let nodes = self.nodes(at: position)
        for node in nodes {
            if let name = node.name, name.starts(with: "card"), let index = Int(name.dropFirst(4)) {
                let selectedCard = gameController.player.playCard(at: index)
                gameController.playCard(player: gameController.player, card: selectedCard!)
                updateScene()
                break
            }
        }
    }
    
    func updateScene() {
        self.removeAllChildren()
        displayCards()  // Redisplay cards with updated hand
    }
}

// Platform-specific interaction handling
#if os(iOS) || os(tvOS)
extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        handleCardSelection(at: touch.location(in: self))
    }
}

#elseif os(OSX)
extension GameScene {
    override func mouseDown(with event: NSEvent) {
        handleCardSelection(at: event.location(in: self))
    }
}
#endif

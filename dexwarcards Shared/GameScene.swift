import SpriteKit

class GameScene: SKScene {
    fileprivate var gameController: GameController!
    fileprivate var selectedCardNode: SKSpriteNode?
    private var cardDetailsLabel: SKLabelNode!

    // MARK: - Scene Initialization
    class func newGameScene() -> GameScene {
        let scene = GameScene(size: CGSize(width: 1024, height: 768))
        scene.scaleMode = .aspectFill
        return scene
    }

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        gameController = GameController()
        setupUI()
        displayCards()
    }

    func setupUI() {
        cardDetailsLabel = SKLabelNode(fontNamed: "Chalkduster")
        cardDetailsLabel.fontSize = 20
        cardDetailsLabel.fontColor = .white
        cardDetailsLabel.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 30) // Positioned at the bottom of the screen
        cardDetailsLabel.text = "Select a card to see details"
        addChild(cardDetailsLabel)
    }

    func displayCards() {
        removeAllChildren() // Clear the scene first
        addChild(cardDetailsLabel) // Add the details label back after clearing the scene
        let baseX = 100
        let cardSpacing = 120
        for (index, card) in gameController.model.player.hand.enumerated() {
            let cardNode = SKSpriteNode(imageNamed: card.imageName)
            cardNode.name = "card\(index)"
            cardNode.position = CGPoint(x: baseX + index * cardSpacing, y: 150)
            cardNode.setScale(0.5)
            addChild(cardNode)
        }
    }

    // MARK: - Interaction Handling
    #if os(iOS) || os(tvOS)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let position = touch.location(in: self)
        selectCard(at: position)
    }
    #elseif os(OSX)
    override func mouseDown(with event: NSEvent) {
        let position = event.location(in: self)
        selectCard(at: position)
    }
    #endif

    func selectCard(at position: CGPoint) {
        let nodes = self.nodes(at: position)
        for node in nodes where node.name?.starts(with: "card") == true {
            if let cardNode = node as? SKSpriteNode, selectedCardNode != cardNode {
                // Animate the previously selected node back to its original size
                selectedCardNode?.run(SKAction.scale(to: 0.5, duration: 0.2))
                
                // Update the new selected node and animate
                selectedCardNode = cardNode
                selectedCardNode?.run(SKAction.scale(to: 0.65, duration: 0.2))
                
                // Update the card details label
                if let indexStr = node.name?.dropFirst(4), let index = Int(indexStr) {
                    let card = gameController.model.player.hand[index]
                    cardDetailsLabel.text = "\(card.monsterName): Str \(card.strength), Agi \(card.agility), Int \(card.intelligence), Def \(card.defense)"
                }
            }
        }
    }
}


// Ensure the safe subscript extension is only declared once in your project
extension Array {
    subscript(safely index: Int) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}


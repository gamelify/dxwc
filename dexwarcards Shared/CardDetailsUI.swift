//
//  CardDetailsUI.swift
//  dexwarcards
//
//  Created by Fatih Turker on 24.09.2024.
//


import SpriteKit

class CardDetailsUI: SKNode {
    private var label: SKLabelNode!

    override init() {
        super.init()
        setupLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLabel() {
        label = SKLabelNode(fontNamed: "Chalkduster")
        label.fontSize = 20
        label.fontColor = SKColor.white
        label.position = CGPoint(x: 0, y: 0)  // Adjust as needed
        addChild(label)
    }

    func updateDetails(with card: Card) {
        label.text = "\(card.monsterName): Str \(card.strength), Agi \(card.agility), Int \(card.intelligence), Def \(card.defense)"
        animateDetailsEntry()
    }

    private func animateDetailsEntry() {
        let moveAction = SKAction.moveBy(x: 0, y: 20, duration: 0.5)
        let fadeAction = SKAction.fadeIn(withDuration: 0.5)
        label.run(SKAction.group([moveAction, fadeAction]))
    }
}

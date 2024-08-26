import Foundation

struct Card: Equatable {
    // MARK: Properties
    let identifier: String   // Unique identifier for each card
    let monsterName: String  // Name of the monster on the card
    let strength: Int        // Raw power of the card
    let agility: Int         // Speed or reflex attribute
    let intelligence: Int    // Strategic thinking or magic power
    let defense: Int         // Resistance or endurance
    
    // MARK: Initializer
    init(identifier: String, monsterName: String, strength: Int, agility: Int, intelligence: Int, defense: Int) {
        self.identifier = identifier
        self.monsterName = monsterName
        self.strength = strength
        self.agility = agility
        self.intelligence = intelligence
        self.defense = defense
    }
    
    // MARK: Computed Property for imageName
    var imageName: String {
        return "\(identifier)"
    }
    
    // MARK: Equatable Conformance
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    // MARK: Battle Calculations
    func calculatePower(with mathModel: MathModel) -> Int {
        let effectiveStrength = Int(pow(Double(strength), mathModel.exponentForStrength))
        let effectiveAgility = agility * mathModel.multiplierForAgility
        let effectiveIntelligence = intelligence + mathModel.bonusForIntelligence
        let effectiveDefense = defense - mathModel.penaltyForDefense
        return effectiveStrength + effectiveAgility + effectiveIntelligence + effectiveDefense
    }
}

struct MathModel {
    let exponentForStrength: Double
    let multiplierForAgility: Int
    let bonusForIntelligence: Int
    let penaltyForDefense: Int
}

extension Card: CustomStringConvertible {
    var description: String {
        return "\(monsterName) (\(identifier)): Strength \(strength), Agility \(agility), Intelligence \(intelligence), Defense \(defense)"
    }
}

import Foundation

class GameController {
    var model: GameModel

    init() {
        self.model = GameModel()
    }

    func startGame() {
        while !model.gameIsOver {
            playTurn()
        }
    }

    private func playTurn() {
        if model.currentPlayer == .player {
            print("Player's turn to play.")
            if let card = model.player.hand.first, let opponentCard = model.computer.hand.first {
                resolveTurn(cardPlayed: card, opponentCard: opponentCard)
            }
        } else {
            if let card = model.computer.calculateBestMove(opponentCard: model.player.hand.first!, mathModel: model.mathModel), let opponentCard = model.player.hand.first {
                resolveTurn(cardPlayed: card, opponentCard: opponentCard)
            }
        }
    }

    func resolveTurn(cardPlayed: Card, opponentCard: Card) {
        let playerPower = cardPlayed.calculatePower(with: model.mathModel)
        let opponentPower = opponentCard.calculatePower(with: model.mathModel)

        if playerPower > opponentPower {
            model.player.hand.append(contentsOf: [cardPlayed, opponentCard])
            print("Player wins the round!")
        } else {
            model.computer.hand.append(contentsOf: [cardPlayed, opponentCard])
            print("Computer wins the round!")
        }

        model.currentPlayer = (model.currentPlayer == .player) ? .computer : .player
        checkGameOver()
    }

    private func checkGameOver() {
        if model.player.hand.isEmpty || model.computer.hand.isEmpty {
            model.gameIsOver = true
            print("Game Over! \(model.currentPlayer == .player ? "Player" : "Computer") wins!")
        }
    }
}

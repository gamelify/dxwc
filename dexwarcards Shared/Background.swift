import SpriteKit
import CoreGraphics

class Background: SKSpriteNode {
    init(size: CGSize) {
        super.init(texture: nil, color: .clear, size: size)
        self.texture = createGradientTexture(size: size, colors: [SKColor.blue, SKColor.purple])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createGradientTexture(size: CGSize, colors: [SKColor]) -> SKTexture? {
        // Create a generic RGB color space
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let cgColors = colors.map { $0.cgColor } as CFArray

        // Create a Core Graphics gradient
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: cgColors, locations: nil) else { return nil }

        // Create a bitmap-based graphics context
        guard let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { return nil }

        // Draw the gradient in the context
        let startPoint = CGPoint(x: 0, y: 0)
        let endPoint = CGPoint(x: size.width, y: size.height)
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])

        // Capture the image from the context
        guard let cgImage = context.makeImage() else { return nil }

        // Create a texture from the CGImage
        return SKTexture(cgImage: cgImage)
    }
}



import SpriteKit
import SwiftUI
import GameplayKit

struct PhysicsCategory {
    static let None: UInt32 = 0
    static let Dog: UInt32 = 0b1
    static let Tree: UInt32 = 0b10
    static let Bone: UInt32 = 0b100
    static let Background: UInt32 = 0b1000
    static let Scorer: UInt32 = 0b10000
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var dog: SKSpriteNode?
    let background = SKSpriteNode(texture: SKTexture(image: UIImage(#imageLiteral(resourceName: "background.jpg"))))
    let scoreLabel = SKLabelNode(fontNamed: "Helvetica")
    var gameDelegate: GameStateListener?
    var score = 0
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            dog!.position.x = touchLocation.x
        }
    }
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        scene?.backgroundColor = UIColor(#colorLiteral(red: 0.3000923097, green: 0.7708374858, blue: 1, alpha: 1))
        physicsWorld.gravity.dy = 0
        self.scoreLabel.fontColor = SKColor.black
        self.scoreLabel.text = "0"
        self.scoreLabel.fontSize = 50
        self.scoreLabel.position = CGPoint(x: 9*Bounds.width/10 + 10, y: 4*Bounds.height/5)
        self.addBackground()
        self.addDog()
        self.addChild(self.scoreLabel)
        self.view?.isUserInteractionEnabled = false
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
            self.startTrees(image: #imageLiteral(resourceName: "tree_1.png"), size: CGSize(width: 25, height: 50), delay: TimeInterval(Double.random(in: 1...4)))
            self.startTrees(image: #imageLiteral(resourceName: "tree_2.png"), size: CGSize(width: 50, height: 100), delay: TimeInterval(Double.random(in: 1...4)))
            self.startTrees(image: #imageLiteral(resourceName: "tree_3.png"), size: CGSize(width: 25, height: 50), delay: TimeInterval(Double.random(in: 1...4)))
            self.startBones(image: #imageLiteral(resourceName: "bone.png"), size: CGSize(width: 25, height: 25), delay: 5)
            self.view?.isUserInteractionEnabled = true
        }
    }
    
    func addDog() {
        dog = SKSpriteNode(texture: SKTexture(image: getCroppedImage(#imageLiteral(resourceName: "dog_image.jpg"))))
        dog!.size = CGSize(width: 100, height: 100)
        dog!.position = CGPoint(x: Bounds.width/2, y: 75)
        dog!.physicsBody = SKPhysicsBody(rectangleOf: dog!.frame.size)
        dog!.physicsBody!.categoryBitMask = PhysicsCategory.Dog
        dog!.physicsBody!.collisionBitMask = PhysicsCategory.Tree
        dog!.physicsBody!.contactTestBitMask = PhysicsCategory.Bone
        dog!.physicsBody!.contactTestBitMask = PhysicsCategory.Scorer
        dog!.physicsBody!.usesPreciseCollisionDetection = true
        self.addChild(dog!)
    }
    
    func addBackground() {
        background.position = CGPoint(x: Bounds.height, y: Bounds.width)
        background.size = CGSize(width: Bounds.width*3, height: Bounds.height*3)
        background.zPosition = -20
        addChild(background)
    }
    
    func getCroppedImage(_ image: UIImage) -> UIImage {
        let imgLayer = CALayer()
        let img = UIImageView(image: image)
        imgLayer.frame = img.bounds
        imgLayer.contents = img.image?.cgImage;
        imgLayer.masksToBounds = true;
        
        imgLayer.cornerRadius = img.frame.size.width/2
        
        UIGraphicsBeginImageContext(img.bounds.size)
        imgLayer.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return roundedImage!;
    }
    
    func createTree(image: UIImage, size: CGSize) {
        let tree = SKSpriteNode()
        tree.texture = SKTexture(image: image) 
        tree.size = CGSize(width: size.width, height: size.height) 
        tree.position.x = CGFloat(Int.random(in: 0 ... Int(Bounds.width)))
        tree.position.y = Bounds.height
        tree.zPosition = -10
        
        tree.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: tree.frame.size.width/2, height: tree.frame.size.height)) 
        tree.physicsBody!.categoryBitMask = PhysicsCategory.Tree 
        tree.physicsBody!.contactTestBitMask = PhysicsCategory.Dog 
        tree.physicsBody!.collisionBitMask = PhysicsCategory.Tree 
        tree.physicsBody?.isDynamic = false
        
        let moveDown = SKAction.moveBy(x: 0, y: -Bounds.height, duration: 2)
        let moveSequence = SKAction.sequence([moveDown, SKAction.removeFromParent()])
        tree.run(moveSequence)
        
        createScorer()
        self.addChild(tree)
        
    }
    
    func createBone(image: UIImage, size: CGSize) {
        let bone = SKSpriteNode()
        bone.texture = SKTexture(image: image)
        bone.size = CGSize(width: size.width, height: size.height)
        bone.position.x = CGFloat(Int.random(in: 0 ... Int(Bounds.width)))
        bone.position.y = Bounds.height
        
        bone.physicsBody = SKPhysicsBody(rectangleOf: bone.frame.size)
        bone.physicsBody?.categoryBitMask = PhysicsCategory.Bone
        bone.physicsBody?.contactTestBitMask = PhysicsCategory.Dog
        bone.physicsBody?.collisionBitMask = PhysicsCategory.Bone
        bone.physicsBody?.isDynamic = false
        
        let moveDown = SKAction.moveBy(x: 0, y: -Bounds.height, duration: 2)
        let moveSequence = SKAction.sequence([moveDown, SKAction.removeFromParent()])
        bone.physicsBody?.usesPreciseCollisionDetection = true
        bone.run(moveSequence)
        
        self.addChild(bone)
    }
    
    func createScorer() {
        let scorer = SKSpriteNode()
        scorer.size = CGSize(width: Bounds.width, height: 2.5)
        scorer.position = CGPoint(x: Bounds.width/2, y: Bounds.height)
        scorer.color = UIColor.clear // change to a different color to see
        scorer.physicsBody = SKPhysicsBody(rectangleOf: scorer.frame.size)
        scorer.physicsBody!.categoryBitMask = PhysicsCategory.Scorer 
        scorer.physicsBody!.contactTestBitMask = PhysicsCategory.Dog 
        scorer.physicsBody!.collisionBitMask = PhysicsCategory.Scorer 
        scorer.physicsBody?.isDynamic = false
        
        let moveDown = SKAction.moveBy(x: 0, y: -Bounds.height, duration: 2)
        let sequence = SKAction.sequence([moveDown, SKAction.removeFromParent()]) 
        scorer.run(sequence)
        self.addChild(scorer)
    }
    
    func startTrees(image: UIImage, size: CGSize, delay: TimeInterval) {
        let create = SKAction.run { [unowned self] in 
            self.createTree(image: image, size: size) 
        }
        let wait = SKAction.wait(forDuration: delay)
        let sequence = SKAction.sequence([create, wait])
        let repeatForever = SKAction.repeatForever(sequence)
        
        self.run(repeatForever)
    }
    
    func startBones(image: UIImage, size: CGSize, delay: TimeInterval) {
        let create = SKAction.run { [unowned self] in
            self.createBone(image: image, size: size)
        }
        
        let wait = SKAction.wait(forDuration: delay)
        let sequence = SKAction.sequence([create, wait])
        let repeatForever = SKAction.repeatForever(sequence)
        
        self.run(repeatForever)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let sprite = contact.bodyA.categoryBitMask == PhysicsCategory.Dog ? contact.bodyB : contact.bodyA
        print(sprite.categoryBitMask)
        if sprite.categoryBitMask == PhysicsCategory.Tree {
            score = 0
            self.view?.isPaused = true
            self.view?.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                self.gameDelegate?.gameOver()
                
            }
            
        } else if sprite.categoryBitMask == PhysicsCategory.Bone {
            // enable power-up
            score += 10
            sprite.node?.removeFromParent()
            
        } else if sprite.categoryBitMask == PhysicsCategory.Scorer {
            score += 1
        }
        
        scoreLabel.text = String(score)
    }
}



import SpriteKit
import SwiftUI

public protocol GameStateListener {
    func gameOver()
}


public struct GameView: View, GameStateListener {
    @State private var gameStart = false
    @State private var disableButton = false
    @State private var second = 3
    @State private var text = "Start the game!"
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var gameDelegate: GameStateListener?
    
    public var scene: SKScene {
        let scene = GameScene()
        scene.gameDelegate = self
        scene.size = CGSize(width: Bounds.width, height: Bounds.height)
        scene.scaleMode = .fill
        scene.backgroundColor = .white
        return scene
    }
    
    public init() {}
    
    public func gameOver() {
        gameStart = false
        
        text = "Oh No! You Lost!"
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
            self.second = 3
            text = "Start the game!"
            disableButton = false
        }
    }
    
    public var body: some View {
        VStack {
            ZStack {
                Color(.white)
                if !gameStart {
                    Button(action: {
                        disableButton = true
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
                            text = "\(second)"
                            second -= 1
                            if second == -1 {
                                gameStart = true
                                t.invalidate()
                            }
                        }
                    }, label: {
                        ButtonLabelView(text: text, size: 35, icon: nil, width: 300, height: 75)
                    })
                    .disabled(disableButton)
                    .transition(AnyTransition.scale.animation(Animation.easeInOut(duration: 1.5)))
                }
                
                if gameStart {
                    SpriteView(scene: scene)
                        .frame(width: Bounds.width, height: Bounds.height)
                        .edgesIgnoringSafeArea(.all)
                        .transition(AnyTransition.scale.animation(Animation.easeInOut(duration: 1.5)))
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            mode.wrappedValue.dismiss()
        }) {
            Image(systemName: "xmark.circle")
        })
    }
}

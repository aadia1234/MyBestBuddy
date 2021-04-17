

import SwiftUI
import AVFoundation

public struct HomeView: View {
    
    let dogImage = #imageLiteral(resourceName: "dog_image.jpg")
    let gradient = Gradient(colors: [.blue, .red])
    @State var showQuiz = false
    
    public init(){}
    
    public var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    Image(uiImage: dogImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                    
                    LabelView(text: "Welcome to My Best Buddy", size: 20, icon: nil, width: 275, height: 50)
                    
                    LabelView(text: "Click the sounds to get your dog's attention!", size: 10, icon: nil, width: 240, height: 30)
                }
                Spacer()
            }
            
            HStack {
                SoundView(fileName: "doorbell_sound", text: "Doorbell", icon: "exclamationmark.circle.fill")
                SoundView(fileName: "ducks_quacking", text: "Ducks Quacking", icon: "speaker.3.fill")
                SoundView(fileName: "birds_chirping", text: "Birds Chirping", icon: "speaker.zzz.fill")
            }
            .padding(.top, 25)
            
            Spacer()
            
            HStack {
                NavigationLink(destination: GameView()) {
                    ButtonLabelView(text: "Play a fun game!", size: 10, icon: nil, width: 185, height: 40)
                        .padding(.bottom, 65)
                }
                
                NavigationLink(destination: QuizView()) {
                    ButtonLabelView(text: "Find out what dog is best for you!", size: 10, icon: nil, width: 185, height: 40)
                        .padding(.bottom, 65)
                }
            }
            
        }
        .background(LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom))
        .edgesIgnoringSafeArea(.all)
    }
}

struct SoundView: View {
    private let soundFileName: String
    private let text: String
    private let iconName: String
    @State private var clicked: Bool = false
    @State private var audioPlayer: AVAudioPlayer?
    
    
    public init(fileName soundFileName: String, text: String, icon iconName: String) {
        self.soundFileName = soundFileName
        self.text = text
        self.iconName = iconName
    }
    
    public var body: some View {
        
        Button(action: {
            self.playSound(soundFileName)
        }, label: {
            ButtonLabelView(text: text, size: 10, icon: iconName, width: 150, height: .infinity)
        })
        
    }
    
    func playSound(_ soundFileName: String) {
        if let audioURL = Bundle.main.url(forResource: soundFileName, withExtension: "mp3") {
            do {
                try self.audioPlayer = AVAudioPlayer(contentsOf: audioURL) /// make the audio player
                self.audioPlayer?.play() /// start playing
                
            } catch {
                print("Couldn't play audio. Error: \(error)")
            }
            
        } else {
            print("No audio file found")
        }
    }
}

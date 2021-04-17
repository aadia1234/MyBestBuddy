

import SwiftUI

public struct QuizView: View {
    let gradient = Gradient(colors: [.green, .yellow])
    
    @State private var quizStart = false
    @State var questionNumber = 1
    @State var answers: [Any] = [] // [Dog.Size.small, false, Dog.Trait.protective]
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    public init() {}
    
    // Change View layout to let the user choose options for all three questions and then submit
    public var body: some View {
        VStack {
            
            Spacer()
            
            HStack {
                
                Spacer()
                
                VStack {
                    
                    ZStack {
                        if !quizStart {
                            Button(action: {
                                self.quizStart = true
                            }, label: {
                                ButtonLabelView(text: "Start!", size: 50, icon: nil, width: 250, height: 125)
                                
                            })
                            .transition(AnyTransition.scale.animation(Animation.easeInOut(duration: 1).delay(0.0)))
                            
                        } else if quizStart && questionNumber-1 < questions.count {
                            self.displayQuestion()
                                .animation(Animation.easeInOut(duration: 1).delay(0.0))
                                .transition(AnyTransition.scale.animation(Animation.easeInOut(duration: 1).delay(0.5)))
                            
                            
                        } else if questionNumber-1 == questions.count {
                            self.displayDog()
                                .transition(AnyTransition.scale.animation(Animation.easeInOut(duration: 2).delay(0.0)))
                        }
                    }
                }
                Spacer()
            }
            Spacer()
        }
        .background(LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom))
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            mode.wrappedValue.dismiss()
        }){
            Image(systemName: "xmark.circle")
        })
    }
    
    func displayQuestion() -> some View {
        Group {
            let question = questions[questionNumber-1]
            VStack {
                LabelView(text: question.title, size: 30, icon: nil, width: 500, height: 62.5)
                    .padding(.top, 50)
                    .padding(.bottom, 50)
                
                HStack {
                    ForEach(question.choices.keys.sorted(by: >), id: \.self) { option in
                        Button(action: {
                            questionNumber += 1
                            answers.append(question.choices[option] ?? Array(question.choices.values)[0])
                        }, label: {
                            ButtonLabelView(text: option, size: 25, icon: nil, width: 150, height: 62.5)
                        })
                    }
                }
                
                LabelView(text: "\(questionNumber) / \(questions.count)", size: 15, icon: nil, width: 60, height: 27.5)
                    .padding(.top, 50)
                    .padding(.bottom, 50)
            }
        }
    }
    
    func displayDog() -> some View {
        Group {
            let dog = findBestDog()
            
            VStack {
                LabelView(text: "The dog breed that would best suit you is ...", size: 20, icon: nil, width: 450, height: 50)
                    .padding(.top, 10)
                
                Image(uiImage: dog.image!)
                    .resizable()
                    .frame(width: 175, height: 175)
                    .clipShape(RoundedRectangle(cornerRadius: 22.5))
                    .padding(.top, 12.5)
                
                LabelView(text: "A \(dog.name!)!", size: 20, icon: nil, width: 250, height: 50)
                    .padding(.top, 10)
                
                Button(action: {
                    questionNumber = 1
                    answers.removeAll()
                    self.quizStart = false
                    
                    
                }, label: {
                    ButtonLabelView(text: "Restart", size: 15, icon: nil, width: 100, height: 37.5)
                        .padding(.top, 10)
                    
                })
                .padding(.bottom, 30)
                
                Spacer()
            }
        }
    }
    
    func findBestDog() -> Dog {
        let preferredDog = Dog(answers[0], answers[1], answers[2])
        var suggestedDog: Dog?
        for dog in dogs {
            if (Dog.compareDogs(preferredDog, dog)) {
                suggestedDog = dog
            }
        }
        return suggestedDog!
    }
}

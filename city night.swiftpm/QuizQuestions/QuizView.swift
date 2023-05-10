import SwiftUI

struct QuizView: View {
    
    @Binding var strikes: Int
    var timerDuration: Int
    var moreDuration: Int
    
    @Binding var is_player_falling: Bool
    
    @State var qIndex: Int = 0
    
    @State var countdowns: [DispatchWorkItem?] = [nil, nil, nil, nil]
    @State var flashes: [Int] = [0, 0, 0, 0]
    
    var quizquestions = [
        QuizQuestion(question: "How many O are there in this question?", options: [QuizOption(optionname: "1"), QuizOption(optionname: "2"), QuizOption(optionname: "3"), QuizOption(optionname: "4")], correctAnswer: 1),
        
        QuizQuestion(question: "What is the color of a mirror?", options: [QuizOption(optionname: "White"), QuizOption(optionname: "Gray"), QuizOption(optionname: "Clear"), QuizOption(optionname: "Silver")], correctAnswer: 2),
        
        QuizQuestion(question: "How many sides does a triangle have?", options: [QuizOption(optionname: "0"), QuizOption(optionname: "1"), QuizOption(optionname: "2"), QuizOption(optionname: "3")], correctAnswer: 3),
        
        QuizQuestion(question: "How many months have 31 days?", options: [QuizOption(optionname: "5"), QuizOption(optionname: "6"), QuizOption(optionname: "7"), QuizOption(optionname: "8")], correctAnswer: 2),
        
        QuizQuestion(question: "Which mammal can fly?", options: [QuizOption(optionname: "Bat"), QuizOption(optionname: "Mouse"), QuizOption(optionname: "Squirrel"), QuizOption(optionname: "Penguin")], correctAnswer: 0),
        
        QuizQuestion(question: "Which direction does the sun rise in?", options: [QuizOption(optionname: "North"), QuizOption(optionname: "East"), QuizOption(optionname: "West"), QuizOption(optionname: "South")], correctAnswer: 1),
        
        QuizQuestion(question: "What is H2O?", options: [QuizOption(optionname: "Air"), QuizOption(optionname: "Fire"), QuizOption(optionname: "Earth"), QuizOption(optionname: "Water")], correctAnswer: 3),
        
        QuizQuestion(question: "How many legs does a spider have?", options: [QuizOption(optionname: "4"), QuizOption(optionname: "6"), QuizOption(optionname: "8"), QuizOption(optionname: "10")], correctAnswer: 2),
        
        QuizQuestion(question: "What is the opposite of up?", options: [QuizOption(optionname: "Down"), QuizOption(optionname: "Left"), QuizOption(optionname: "Right"), QuizOption(optionname: "Sideways")], correctAnswer: 0),
        
        QuizQuestion(question: "How many letters are in the English alphabet?", options: [QuizOption(optionname: "20"), QuizOption(optionname: "25"), QuizOption(optionname: "26"), QuizOption(optionname: "30")], correctAnswer: 2),
        
        QuizQuestion(question: "What is the square root of 64?", options: [QuizOption(optionname: "4"), QuizOption(optionname: "6"), QuizOption(optionname: "8"), QuizOption(optionname: "10")], correctAnswer: 2),
        
        QuizQuestion(question: "Which planet is closest to the sun?", options: [QuizOption(optionname: "Mars"), QuizOption(optionname: "Venus"), QuizOption(optionname: "Mercury"), QuizOption(optionname: "Saturn")], correctAnswer: 2),
        
        QuizQuestion(question: "What is the largest organ in the human body?", options: [QuizOption(optionname: "Liver"), QuizOption(optionname: "Heart"), QuizOption(optionname: "Lungs"), QuizOption(optionname: "Skin")], correctAnswer: 3),
        
        QuizQuestion(question: "What is the name of the currency used in Japan?", options: [QuizOption(optionname: "Dollar"), QuizOption(optionname: "Yuan"), QuizOption(optionname: "Yen"), QuizOption(optionname: "Euro")], correctAnswer: 2),
        
        
        QuizQuestion(question: "What is the symbol for potassium?", options: [QuizOption(optionname: "P"), QuizOption(optionname: "K"), QuizOption(optionname: "O"), QuizOption(optionname: "Ca")], correctAnswer: 1),
        
        
    ]


    
    var body: some View {
        
            // quiz question
            ZStack {
                Color(.white)
                
                VStack (alignment: .center, spacing: 30){
                    
                    ForEach (qIndex..<min(qIndex + 4, quizquestions.count), id: \.self) { i in
                        
                        if (i == qIndex) {
                            QuizQuestionView(qIndex: $qIndex, strikes: $strikes, question: quizquestions[i], questionnum: i + 1, enabled: true) 
                                .foregroundColor(i == qIndex ? (flashes[3] == 1 ? .red : .black) : .black)
                            
                        }else {
                            QuizQuestionView(qIndex: $qIndex, strikes: $strikes, question: quizquestions[i], questionnum: i + 1, enabled: false) 
                                .foregroundColor(.gray)
                            
                        }
                        
                    }
                    Spacer()
                    
                }
                .padding([.top, .bottom], 30)
                .onChange(of: qIndex) { newValue in
                    countdowns[3]!.cancel()
                    flashes[3] = 0
                    
                    countdowns[3] = DispatchWorkItem(block: {
                        flashes[3] = 1
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(moreDuration)) {
                            if flashes[3] == 1 {
                                
                                qIndex = qIndex + 1
                                flashes[3] = 0
                                strikes += 1
                            }
                        }
                    })
                    
                    
                    if (!is_player_falling ) {
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(timerDuration), execute: countdowns[3]!)
                    }
                }
                .onAppear {
                    
                    countdowns[3] = DispatchWorkItem(block: {
                        flashes[3] = 1
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(moreDuration)) {
                            if flashes[3] == 1 {
                                
                                qIndex = qIndex + 1
                                flashes[3] = 0
                                strikes += 1
                            }
                            
                        }
                    })
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(timerDuration), execute: countdowns[3]!)
                }
            }
            
            
            
            
        
    }
}

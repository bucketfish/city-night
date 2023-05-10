import SwiftUI

struct MathQuestionsView: View { // view for the entire math question segment of the challenges
    
    @Binding var strikes: Int
    @Binding var is_player_falling: Bool
    
    var timerDuration: Int
    var moreDuration: Int
    
    @State var mathQuestions: [MathQuestion] = []
    
    @State var mathQnFilledIn1 = false
    @State var mathQnFilledIn2 = false
    @State var mathQnFilledIn3 = false
    
    var math1timer: Timer?
    var math2timer: Timer?
    var math3timer: Timer?
    
    @State var flashes: [Int] = [0, 0, 0, 0]
    
    @State var mathQnOffsets = [CGSize(width: 0, height: 0), CGSize(width: 0, height: 0), CGSize(width: 0, height: 0)]
    @State var mathQnOpacity: [CGFloat] = [1, 1, 1]
    
    @State var countdowns: [DispatchWorkItem?] = [nil, nil, nil, nil]
    
    @State var mathAnswers = [DraggableAnswer(answer: "1"), DraggableAnswer(answer: "2"), DraggableAnswer(answer: "3"),  DraggableAnswer(answer: "4"),  DraggableAnswer(answer: "5"), DraggableAnswer(answer: "6")]


    
    @State var mathAnswerOffsets = [0, 400, 800, 600, 200, 1000]
    
    @State var mathAnswersList = [0, 7, 8, 9]
    
    
    let mathScrollSpeed: Int = 70

    



    
    var body: some View {
        HStack {
            
            VStack (alignment: .leading, spacing: 30){
                
                // show math questions 
                ForEach(0..<mathQuestions.count, id: \.self) {i in
                    MathQuestionView(mathQuestions: $mathQuestions, index: i, filled_in: i == 0 ? $mathQnFilledIn1 : (i == 1 ? $mathQnFilledIn2 : $mathQnFilledIn3), strikes: $strikes)
                        .foregroundColor(flashes[i] == 1 ? .red : .white)
                        .offset(x: mathQnOffsets[i].width, y: mathQnOffsets[i].height)
                        .opacity(mathQnOpacity[i])
                        

                        // keep track of the strikes & countdowns
                        .onChange(of: i == 0 ? mathQnFilledIn1 : (i == 1 ? mathQnFilledIn2 : mathQnFilledIn3)) {newValue in 
                            
                            mathQnFilledIn1 = false
                            mathQnFilledIn2 = false
                            mathQnFilledIn3 = false
                            
                            // if the answer has been filled in, cancel penalty strike timer
                            countdowns[i]!.cancel()
                            flashes[i] = 0
                            
                            // reset the countdown and set a new dispatchworkitem
                            countdowns[i] = newCountdownTimer(index: i)
                            
                            // stop showing the question & show a new one instead
                            withAnimation(.easeInOut(duration: 0.2)) {
                                mathQnOpacity[i] = 0
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                mathQuestions[i] = generateMathQuestion()
                                
                                flashes[i] = 0
                                
                                if (!is_player_falling) {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(timerDuration), execute: countdowns[i]!)
                                }
                                
                                withAnimation(Animation.easeInOut(duration: 0.2)) {
                                    mathQnOpacity[i] = 1
                                }
                            }
                            
                        }
                    
                        .onAppear {
                            countdowns[i] = newCountdownTimer(index: i)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + Double(timerDuration), execute: countdowns[i]!)
                            
                        }
                }
                
            }
            .frame(minWidth: 100, idealWidth: 500, maxWidth: 800, minHeight: 100, idealHeight: 400, maxHeight: 600, alignment: .center)
            .onAppear {
                
                // start the timer to move the math questions around a little bit
                _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                    
                    let distance: CGFloat = 25
                    let ydistance: CGFloat = 15
                    
                    withAnimation(.linear(duration: 0.5)) {
                        mathQnOffsets[0].width = CGFloat.random(in: -distance...distance)
                        mathQnOffsets[0].height = CGFloat.random(in: -ydistance...ydistance)
                        
                        mathQnOffsets[1].width = CGFloat.random(in: -distance...distance)
                        mathQnOffsets[1].height = CGFloat.random(in: -ydistance...ydistance)
                        
                        mathQnOffsets[2].width = CGFloat.random(in: -distance...distance)
                        mathQnOffsets[2].height = CGFloat.random(in: -ydistance...ydistance)
                        
                    }
                    
                    if (is_player_falling) {
                        // stop when moving on to next scene
                        timer.invalidate()
                    }
                }
            }
            
            
            // show the draggable math answers in a list
            VStack {
                ForEach (0..<$mathAnswers.count, id :\.self) { i in
                    DraggableText(index: i, list: $mathAnswers)
                        .offset(x: CGFloat(mathAnswerOffsets[i] + 500)) // each one has a custom offset
                    
                }
            }
            .frame(minWidth: 500, idealWidth: 900, maxWidth: 1000, minHeight: 100, idealHeight: 350, maxHeight: 600, alignment: .center)

            
            .onAppear {
                
                // schedule the offsets of each math answer to move!
                _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                    
                    if (!is_player_falling) {
                        withAnimation(.linear(duration: 0.5)) {
                            for i in 0..<mathAnswerOffsets.count {
                                mathAnswerOffsets[i] -= mathScrollSpeed
                            }
                        }
                        
                        // check that none of them exceed the position & reset them if so
                        for i in 0..<mathAnswerOffsets.count {
                            if (mathAnswerOffsets[i] < -1200) {
                                mathAnswerOffsets[i] = 0
                                mathAnswers[i].exists = true
                                
                                if mathAnswersList.count == 0 {
                                    mathAnswersList = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
                                }
                                
                                let randomIndex = Int.random(in:0..<mathAnswersList.count)
                                mathAnswers[i].answer = String(mathAnswersList[randomIndex])
                                mathAnswersList.remove(at: randomIndex)
                            }
                        }
                        
                    }
                    else {
                        timer.invalidate()
                    }
                }
                
            }
            
        }
        .onAppear {
            // generate some math questions at the start
            mathQuestions.append(generateMathQuestion())
            mathQuestions.append(generateMathQuestion())
            mathQuestions.append(generateMathQuestion())
        }
    }
    
    
    func generateMathQuestion() -> MathQuestion { // returns mathQuestion
        
        let equation = Int.random(in: 0...1)
        
        var returnAns = MathQuestion(list: $mathAnswers, question: "1 + 1 = ", answer: 2)
        
        let answer = Int.random(in:0...9)
        
        if (equation == 0) { // addition
            
            let num1 = Int.random(in: 0...answer)
            let num2 = answer - num1
            
            let questionString = "\(num1) + \(num2) = "
            
            returnAns =  MathQuestion(list: $mathAnswers, question: questionString, answer: answer)
            
        } 
        else {
            
            let num1 = Int.random(in: 0..<5)
            let num2 = answer + num1
            
            let questionString = "\(num2) - \(num1) = "
            
            returnAns =  MathQuestion(list: $mathAnswers, question: questionString, answer: answer)
            
        }  
        return returnAns
    }
    
    
    func newCountdownTimer(index: Int) -> DispatchWorkItem {
        return DispatchWorkItem(block: {
            flashes[index] = 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(moreDuration)) {
                if (flashes[index] == 1 ) {
                    mathQuestions[index] = generateMathQuestion()
                    flashes[index] = 0
                    strikes += 1
                }
            }
        })
    }
}

import SwiftUI

struct QuizQuestionView: View {
    @Binding var qIndex: Int
    @Binding var strikes: Int
    @State var question: QuizQuestion
    @State var questionnum: Int
    @State var enabled: Bool
    
    
    var body: some View {
        
        VStack (spacing: 15){
            
            Text("Q\(String(questionnum)). \(question.question)")
                .strikethrough(question.filledIn)
                .multilineTextAlignment(.leading)
                .font(.title2)

            
            HStack (spacing: 25){
                Image(systemName: "checkmark.circle")
                    .opacity(0)
                    .font(.title2)
                
                // options and selection
                ForEach (question.options.indices, id: \.self) { j in
                    
                    HStack {
                        
                        Text("\(question.options[j].optionname)")
                            .font(.title2)
                            .fixedSize(horizontal: false, vertical: true)

                            
                        // each option
                        Image(systemName: question.options[j].checked ? "checkmark.square" : "square")
                            .font(.title2)
                            .onTapGesture {
                                if (!question.filledIn && enabled) {
                                    question.filledIn = true
                                    question.options[j].checked = true
                                    
                                    withAnimation {
                                        qIndex += 1
                                    }
                                    
                                    if (j == question.correctAnswer) {
                                        question.rightAnswer = true
                                        
                                    }
                                    else {
                                        strikes += 1
                                    }
                                }
                            }
                        
                    }
                    

                }
                
                // checkmark (or cross)
                Image(systemName: question.rightAnswer ? "checkmark.circle" : "x.circle")
                    .foregroundColor(question.rightAnswer ? .green : .red)
                    .font(.title2)
                    .opacity(question.filledIn ? 1 : 0)
                

            }
        }
        .opacity(enabled ? 1 : 0.5)
    }
}

import SwiftUI


// singular math question with question text & droppable area
struct MathQuestionView: View {
    @Binding var mathQuestions: [MathQuestion]
    @State var index: Int
    
    @Binding var filled_in: Bool
    
    @State var filled_in_temp = false
    
    @Binding var strikes: Int
    
    var body: some View {
        
        HStack {
            Text(mathQuestions[index].question) 
                .font(.largeTitle)
            DroppableArea(mathQuestions: $mathQuestions, questionIndex: index, filled_in: $filled_in_temp, strikes: $strikes)
                .onChange(of: filled_in_temp, perform: { value in
                    filled_in = true
                    filled_in_temp = false
                })
        }
    }
}


// drag handler
struct DraggableText: View  {
    @State var index: Int
    @Binding var list: [DraggableAnswer]
    
    var body: some View {
        Text(list[index].answer)
            .font(.largeTitle)
            .padding([.leading, .trailing], 25)
            .padding([.top, .bottom], 15)
            .contentShape(Rectangle())
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.white, lineWidth: 1)
            )
            .opacity(list[index].exists ? 1 : 0)
            .onDrag { NSItemProvider(object: String(index) as NSString) } // send information on drag!
    }
}


// drop handler
struct DroppableArea: View {
    
    @State var text: String = "    "
    @State private var active = false
    
    @Binding var mathQuestions: [MathQuestion]
    @State var questionIndex: Int
    
    @Binding var filled_in: Bool
    @State var is_correct: Bool = false
    
    @State var show_ans: Bool = false
    
    @Binding var strikes: Int
    
    
    var body: some View {
    
        HStack {
            // show what is dropped
            Text(text)
                .font(.largeTitle)
                .padding(30)
            
                .contentShape(Rectangle())
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.white, lineWidth: 1)
                )
            
                // on drop!
                .onDrop(of: ["public.text"], isTargeted: nil, perform: { itemProvider, _ in
                    // load up the data
                    if let item = itemProvider.first {
                        item.loadItem(forTypeIdentifier: "public.text", options: nil) { (text, err) in

                            if let data = text as? Data {
                                
                                // assign the data to the area

                                let index = Int( String(decoding: data, as: UTF8.self) ) ?? 0
                                self.text = mathQuestions[questionIndex].list[index].answer
                                
                                mathQuestions[questionIndex].list[index].exists = false
                                filled_in = true
                                
                                // check if answer is correct!
                                is_correct = Int(mathQuestions[questionIndex].list[index].answer) == mathQuestions[questionIndex].answer
                                
                                if (!is_correct) {
                                    strikes += 1
                                }
                                
                            }
                        }
                    }
                    return true
                })
            
            
            // show the checkmark or cross after answer is put in
            Image(systemName: is_correct ? "checkmark.circle" : "x.circle")
                .foregroundColor(is_correct ? .green : .red)
                .opacity(show_ans ? 1 : 0)
                .font(.largeTitle)
                .padding(.leading, 5)
            
            
        }.onChange(of: filled_in, perform: { value in
            // show the answer depending on whether the question has been answered or not
            if value {
                show_ans = true
            }
            else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    show_ans = false
                } 
            }
            
            
            // clear the answer once the new question shows
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                text = "    "
            }
            
        })
    }
}



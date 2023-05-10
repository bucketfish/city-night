import SwiftUI


struct MathQuestionInfo {
    var questiontext: String
    var answer: Int
}

struct DraggableAnswer {
    var answer: String
    var exists: Bool = true
}



struct MathQuestion {
    @Binding var list: [DraggableAnswer]
    
    @State var question: String
    @State var answer: Int
    
    @State var is_correct: Bool = false
    @State var filled_in: Bool = false
    
    
}

extension MathQuestion: Hashable {
    static func == (q1: MathQuestion, q2: MathQuestion) -> Bool {
        return q1.question == q2.question && q1.answer == q2.answer
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(question)
        hasher.combine(answer)
    }
}

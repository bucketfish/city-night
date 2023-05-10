import SwiftUI


struct QuizQuestion: Hashable{
    var question: String
    var options: [QuizOption]
    var correctAnswer: Int
    var filledIn: Bool = false
    var rightAnswer: Bool = false
}

struct QuizOption: Equatable, Hashable {
    var optionname: String
    var checked: Bool = false
}

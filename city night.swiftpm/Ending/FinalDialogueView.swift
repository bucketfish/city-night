import SwiftUI

struct FinalDialogueView: View {
    @Binding var app_state: AppState
    
    var dialogue = [
        DialogueLine(text: "Wow, it cleared up! Look at that rainbow!", person: 1),
        
        DialogueLine(text: "It's like a sign that things will get better.", person: 0),
        
        DialogueLine(text: "Definitely. And you know what?", person: 1),
        DialogueLine(text: "You're doing great. You're juggling so many things — that's something to be proud of.", person: 1),
        
        DialogueLine(text: "Thank you. It's easy to forget that sometimes.", person: 0),
        
        DialogueLine(text: "Of course. Anytime. And hey, want to grab some hot chocolate and enjoy the rainbow?", person: 1),
        
        DialogueLine(text: "That sounds perfect. Let's go!", person: 0)
        
    ]
    
    @State var dIndex = -6

    
    var body: some View {
        
        ZStack {
            Color.clear // to have a contentshape for tapping
            
            // show the dialogue
            VStack (spacing: 30){
                ForEach(max(dIndex, 0)..<min(dialogue.count, dIndex + 6), id: \.self) {i in
                    
                    HStack {
                        Typewriter(text: dialogue[i].text, time: 0.5, align: dialogue[i].person == 0 ? .leading : .trailing)
                            .foregroundColor(dialogue[i].person == 0 ? .white : Color(red: 243 / 255, green: 217 / 255, blue: 126 / 255))
                            .font(.title2)
                            .multilineTextAlignment(dialogue[i].person == 0 ? .leading : .trailing)
                            .frame(minWidth: 100, idealWidth: 300, maxWidth: 400, alignment: dialogue[i].person == 0 ? .leading : .trailing)

                    }
                    .frame(minWidth: 900, idealWidth: 1500, maxWidth: 1600, alignment: dialogue[i].person == 0 ? .leading : .trailing)
                }
            }
            .frame(minWidth: 900, idealWidth: 1500, maxWidth: 1600)
            .padding([.leading, .trailing], 5)
            .offset(y: 200)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            // advance dialogue on tap
            if (dIndex + 5 < dialogue.count) {
                dIndex += 1
            }
            
            if (dIndex + 5 == dialogue.count){
                app_state = .closing
            }
        }
        
    }
    
}

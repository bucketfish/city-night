import SwiftUI

struct ClosingView: View {
    
    var body: some View {
        
        ZStack {
            Color(red: 62 / 255, green: 92 / 255, blue: 118 / 255)

            VStack (alignment: .center, spacing: 30){
                
                Image("yellowumbrella")
                    .rotationEffect(.degrees(20), anchor: .center)

                Typewriter(text: "What if instead of trying to do everything perfectly, we focused on doing things with kindness and intention?")
                    .foregroundColor(.white)
                
                Typewriter(text: "What if we measured success not just by what we accomplish, but by how we treat ourselves and others?", after: 3)
                    .foregroundColor(.white)

                
                Typewriter(text: "It's okay to take a break.", after: 6, time: 2)
                    .foregroundColor(.white)

                
                Typewriter(text: "The end.",  after: 8, time: 1, is_bold: true)
                    .foregroundColor(Color(red: 144 / 255, green: 194 / 255, blue: 231 / 255))

            }
            .padding(50)
        }
    }
}

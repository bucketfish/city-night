import SwiftUI

struct OpeningView: View {
    @Binding var app_state: AppState
    
    var body: some View {
        ZStack {
            Color(red: 62 / 255, green: 92 / 255, blue: 118 / 255)
            
            VStack (spacing: 30){
                
                VStack (spacing: 5){
                    Text("City Night.")
                        .font(.largeTitle)
                        .foregroundColor(Color(red: 144 / 255, green: 194 / 255, blue: 231 / 255))
                    
                    Text("Please play this experience in fullscreen on a mac // Sound on!")
                        .font(.subheadline)
                        .italic()
                }
                
                Image("umbrella")
                    .rotationEffect(.degrees(20), anchor: .center)
                Typewriter(text: "In the ebb and flow of a life's journey, we encounter all kinds of weather: the sun, the rain, the storms.")
                    .foregroundColor(.white)
                
                Typewriter(text: "It's easy to get caught up in the hustle, in the chaos of life. It's difficult to slow down.", after: 3)
                    .foregroundColor(.white)
                
                Typewriter(text: "The skies are always changing and the challenges are plenty.", after: 6)
                    .foregroundColor(.white)
                
                Button {
                    app_state = .game
                } label: {
                    Typewriter(text: "Let's walk into the rain.",  after: 9, time: 2, is_bold: true)
                        .foregroundColor(Color(red: 144 / 255, green: 194 / 255, blue: 231 / 255))
                }
            }
            .padding([.leading, .trailing], 30)
            
        }
        
    }
}

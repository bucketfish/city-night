import SwiftUI

struct BackgroundParallaxView: View {
    @Binding var is_player_falling: Bool
    @State var screenheight: CGFloat
    @Binding var rain_modulo_visible: Int
    @Binding var rainbow_part: Bool
    
    var body: some View {
        // background parallax
        ZStack{
            
            // background color
            if !rainbow_part {
                Color(red: 62 / 255, green: 92 / 255, blue: 118 / 255)
            }
            else {
                Color(red: 144 / 255, green: 194 / 255, blue: 231 / 255)
            }
            
            
            // geometryreader for scrolling
            GeometryReader { geometry in
                let size = geometry.size.width
                
                InfiniteScroller(contentWidth: size, scrollSpeed: 40, is_stopped: $is_player_falling) {
                    Image("back1")
                        .resizable()
                        .scaledToFill()
                }         
                
                // rainbow
                Circle()
                    .fill(
                        RadialGradient(gradient: Gradient(colors: [.clear, .red, .yellow, .green, .blue, .purple, .clear]), center: .center, startRadius: 800, endRadius: 1200)
                    )
                    .frame(width: 2400, height: 2400)
                    .offset(x: 500, y: 0)
                    .opacity(rainbow_part ? 0.6 : 0)
                    .animation(.easeIn, value: rainbow_part)
                    

                InfiniteScroller(contentWidth: size, scrollSpeed: 25, is_stopped: $is_player_falling) {
                    Image("back2")
                        .resizable()
                        .scaledToFill()
                }
                
                InfiniteScroller(contentWidth: size, scrollSpeed: 12, is_stopped: $is_player_falling) {
                    Image("back3")
                        .resizable()
                        .scaledToFill()
                }
                
            }
            
            
            // show the rain in front
            RainView(screenheight: $screenheight, modulo_visible: $rain_modulo_visible)
            
            // floor
            Image("floor")
                .resizable()
                .scaledToFill()
            
        }
    }
}

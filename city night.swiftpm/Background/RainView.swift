import SwiftUI

struct RainView: View {
    @Binding var screenheight: CGFloat
    @State var rain_offsets: [CGFloat] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    @Binding var modulo_visible: Int // out of 100
    
    var body: some View {
        
        HStack{
            ForEach( (0...30), id: \.self) {i in 
                
                Color(.white)
                    .opacity(i % modulo_visible == 0 ? 0.5 : 0) // by decreasing modulo_visible, more rain shows up
                    .frame(width: 2, height: 120)
                    .offset(x: 0, y: rain_offsets[i])
                    .onAppear {
                        rain_offsets[i] = 0
                        withAnimation(.linear(duration: CGFloat.random(in: 1...2)).repeatForever(autoreverses: false)) {
                            rain_offsets[i] = screenheight
                            // let the rain down!
                        }
                    }
                
                if (i != 30) {
                    Spacer()
                }
            }
        }
        // let the rain take up the entire screen
        .rotationEffect(Angle(degrees: 15), anchor: .center)
        .scaleEffect(CGSize(width: 1.5, height: 2.0), anchor: .center)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading) 
        
    }
}

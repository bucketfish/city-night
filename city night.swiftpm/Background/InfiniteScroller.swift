import SwiftUI


struct InfiniteScroller<Content: View>: View {
    @State var contentWidth: CGFloat
    var scrollSpeed: CGFloat
    @Binding var is_stopped:Bool
    
    @State var xOffset: CGFloat = 0

    var content: (() -> Content)
    
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            
            HStack(spacing: 0) {
                // repeat the content twice so that there's no weird gaps in movement
                content()
                content()
            }
            .offset(x: xOffset)

        }
        .disabled(true) 
        .onAppear {
            
            _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (Timer) in

                if (!is_stopped) { // scroll if not stopped
                    
                    withAnimation(.linear(duration: 0.5)) { // in increments of 0.5 so it can be stopped when needed
                        xOffset -= contentWidth / (scrollSpeed * 2)
                    }
                    
                    if (xOffset - contentWidth / (scrollSpeed * 2) <= -contentWidth) {
                        xOffset = 0
                    }
                    
                }
            }
        }        
        
    }
}

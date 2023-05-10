import SwiftUI

struct Typewriter: View {
    @State var text: String
    @State var after: Double = 0
    @State var time: Double = 3
    
    @State var text_to_show: String = ""
    @State var text_offset: Int = 0
    
    @State var is_bold: Bool = false
    @State var align = TextAlignment.center

    
    @State var upperBound = String.Index(utf16Offset: 0, in: "text")
    
    var body: some View {
        
        Text(text[..<upperBound])
            .fontWeight(is_bold ? .bold : .none)
            .font(.title2)
            .multilineTextAlignment(align)
            .fixedSize(horizontal: false, vertical: true)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + after) {
                    _ = Timer.scheduledTimer(withTimeInterval: (time / Double(text.count)), repeats: true) { timer in
                        
                        if text_offset < text.count {
                            text_offset += 1
                            
                            upperBound = text.index(text.startIndex, offsetBy: text_offset)

                        }
                        else {
                            timer.invalidate()
                        }
                    }
                }

            }
        
    }
}

import SwiftUI
import AVFoundation

struct EndingView: View {
    
    @Binding var is_player_looking_up: Bool
    @Binding var rainbow_part: Bool
    @Binding var zoom_constant: Double
    
    @Binding var audio_player: AVAudioPlayer
    @Binding var small_player: AVAudioPlayer
    
    @Binding var yellowframe: String
    @Binding var yellowoffset: CGFloat


    
    var giveUpText = [
        "I can't do this anymore. There's too much work all at once —",
        "Why does it feel like I have to keep doing something?",
        "There's so much to do. I don't even know where to start.",
        "I'm so tired."
    ]
    
    var dialogue = [
        DialogueLine(text: "Are you alright?", person: 1),
        
        DialogueLine(text: "Yeah... just kind of stressed out.", person: 0),
        DialogueLine(text: "There's so much to do and I can't keep up.", person: 0),
        
        DialogueLine(text: "I know how that feels. It's hard to balance everything sometimes.", person: 1),
        
        DialogueLine(text: "It feels like everyone else has it all figured out and I'm just falling behind...", person: 0),
        
        DialogueLine(text: "Trust me, you're not alone.", person: 1),
        DialogueLine(text: "It's easy to think that everyone else is doing better than us, but everyone has their own struggles and challenges.", person: 1),
        DialogueLine(text: "No one has it all figured out.", person: 1),
        
        DialogueLine(text: "Yeah, I guess that's true.", person: 0),
        DialogueLine(text: "But the pressure to be productive and successful all the time is overwhelming.", person: 0),
        
        DialogueLine(text: "I totally get it. ", person: 1),
        DialogueLine(text: "But remember, success isn't just about what you accomplish.", person: 1),
        DialogueLine(text: "It's also about how you treat yourself and others. And taking care of yourself is the most important thing you can do.", person: 1),
        DialogueLine(text: "Maybe it's time to take a break, do something you enjoy, and recharge your batteries.", person: 1),
        
        DialogueLine(text: "You're right.", person: 0),
        DialogueLine(text: "Maybe I need to remind myself that it's okay to slow down.", person: 0),
        
        DialogueLine(text: "Exactly!", person: 1),
        DialogueLine(text: "Your worth isn't tied to your productivity. You deserve to take care of yourself, too.", person: 1)

        
    ]
    
    var horOffset = 400
    var vertOffset = 350
    
    @State var defaultOffset: [CGSize] = []
    @State var giveUpOffset: [CGSize] = []
    
    @State var textNum = 1.0
    
    @State var vignetteOffset = 0
    @State var textOpacity: Double = 1
    
    @State var personanim = false
    
    @State var personframe = 0
    @State var personStand = false
    
    @State var all_opacity: Double  = 1
    
    
    @State var dIndex = -5
    
    var body: some View {
        ZStack {
            
            // vignette overlay
            Rectangle().fill(
                RadialGradient(
                    gradient: Gradient(colors: [.clear, .black]),
                    center: .center,
                    startRadius: max(0, CGFloat(300 - vignetteOffset)),
                    endRadius: CGFloat(1000 - vignetteOffset)
                ))
            .opacity(all_opacity)
            
            
            
            // two characters dialogue — lots of frames & alignment to align the dialogue
            VStack (spacing: 25){
                ForEach(max(dIndex, 0)..<min(dialogue.count, dIndex + 6), id: \.self) {i in
                        
                    HStack {
                        Typewriter(text: dialogue[i].text, time: 0.5, align: dialogue[i].person == 0 ? .leading : .trailing)
                            .foregroundColor(dialogue[i].person == 0 ? Color(red: 144 / 255, green: 194 / 255, blue: 231 / 255) : Color(red: 243 / 255, green: 217 / 255, blue: 126 / 255))
                            .font(.title2)
                            .frame(minWidth: 100, idealWidth: 300, maxWidth: 400, alignment: dialogue[i].person == 0 ? .leading : .trailing)

                    }
                    .frame(minWidth: 900, idealWidth: 1500, maxWidth: 1600, alignment: dialogue[i].person == 0 ? .leading : .trailing)
                }
            }
            .frame(minWidth: 900, idealWidth: 1500, maxWidth: 1600)
            .padding([.leading, .trailing], 5)
            .opacity(personStand ? all_opacity : 0)
            
            
            
            // the giving up texts should show up in random-ish positions
            VStack {
                ForEach(0..<giveUpOffset.count, id: \.self) { i in
                    
                    Text (giveUpText[i])
                        .foregroundColor(.white)
                        .opacity(i < Int(textNum) ? 1 : 0)
                        .font(.title2)
                        .lineLimit(nil)
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(minWidth: 200, idealWidth: 400, maxWidth: 500, minHeight: 200, idealHeight: 400, maxHeight: 500)
                        .offset(x: giveUpOffset[i].width, y: giveUpOffset[i].height)
                    
                }
            }
            .opacity(textOpacity)
            .onAppear {

                // randomly position the give up texts
                self.defaultOffset = [CGSize(width: -horOffset, height: vertOffset), CGSize(width: horOffset, height: vertOffset), CGSize(width: -horOffset, height: -vertOffset), CGSize(width: horOffset, height: -vertOffset)]
                
                self.giveUpOffset = [CGSize(width: -horOffset, height: vertOffset), CGSize(width: horOffset, height: vertOffset), CGSize(width: -horOffset, height: -vertOffset), CGSize(width: horOffset, height: -vertOffset)]
                
                
                _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                    
                    // once it's all positioned, end and show other stuff
                    if (textNum >= 4) {
                        timer.invalidate()
                        personanim = true
                        
                        // show the friend character
                        withAnimation(.linear(duration: 3)) {
                            vignetteOffset = 500
                            yellowoffset = 120
                            textOpacity = 0
                        }
                        
                        // pull back the vignette + music after friend character shows up
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            personStand = true
                            is_player_looking_up = true
                            
                            small_player.play()
                            small_player.setVolume(1, fadeDuration: 1)
                            
                            withAnimation(.linear(duration: 1)) {
                                vignetteOffset = 0
                                
                            }
                        }
                        
                        
                        
                    }
                    textNum += 0.5 // 0.5 so it moves slower
                    withAnimation(.linear(duration: 1)) {
                        // constantly animate the floating texts
                        for i in 0..<4 {
                            giveUpOffset[i].width = defaultOffset[i].width + CGFloat.random(in: -25...25)
                            giveUpOffset[i].height = defaultOffset[i].height + CGFloat.random(in: -25...25)
                        }
                    }
                }
                
                
            }
                        
                        
        }
        .onAppear {
            // animate the friend walking
            _ = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { timer in
                if (personframe == 3) {
                    personframe = 0
                    
                }
                else {
                    personframe += 1
                }
                
                if personStand {
                    personframe = 4
                    timer.invalidate()
                }
                
                yellowframe = "umbrella\(personframe)"
                
            }
        }
        .contentShape(Rectangle()) // big tap area for dialogue
        .onTapGesture {
            // advance dialogue on tap
            if !(dialogue.count == dIndex + 5) && personStand {
                dIndex += 1
            }
            
            if (dIndex + 5 == dialogue.count) {
                // time to move on!!!! RAINBOW TIME
                rainbow_part = true
                withAnimation(.easeInOut(duration: 1)) {
                    all_opacity = 0
                }
            }
        }
    }
}

import SwiftUI
import AVFoundation



struct ContentView: View {
    @Binding var app_state: AppState
    
    @Binding var audio_player: AVAudioPlayer
    
    @Binding var small_player: AVAudioPlayer
    
    @Binding var rain_player: AVAudioPlayer
    
    @State var walkframe = 0.0
    
    @State var yellowframe = "umbrella0"
    @State var yellowoffset: CGFloat = 1200
    
    @State var timeleft = 60
    
    var back1move = 0.5
    
    @State var back1offset = 0
    var back2move = 0.7
    var back3move = 0.9
    

    @State var strikes = 0
    
    @State var zoomconstant = 1.0
    
    @State var game_opacity: Double = 1.0
    
    @State var is_player_falling = false
    @State var is_player_looking_up = false
    
    @State var rain_modulo_visible = 5
    
    
    var timerDuration: Int = 15
    var moreDuration: Int = 5
    
    
    let strikeMax: Int = 3
    
    @State var screenheight: CGFloat = UIScreen.main.bounds.height
    
    @State var rainbow_part = false
    
    
    
    var body: some View {
        ZStack{
            
            // background parallax
            BackgroundParallaxView(is_player_falling: $is_player_falling, screenheight: screenheight, rain_modulo_visible: $rain_modulo_visible, rainbow_part: $rainbow_part)
            .scaleEffect(CGSize(width: zoomconstant, height: zoomconstant), anchor: .bottom)
            
            
            // foreground
            VStack {
                
                HStack {
                    
                    // timer
                    HStack {
                        Image(systemName: "timer")
                            .font(.system(size: 48))
                        Text("0\(timeleft / 60):\(String(format: "%02d", timeleft % 60))")
                            .foregroundColor(.white)
                            .font(.system(size: 64))
                            .bold()
                            .onAppear() {
                                _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                                    timeleft -= 1
                                    
                                    if (is_player_falling) {
                                        timer.invalidate()
                                    }
                                    
                                    if (timeleft <= 0) {
                                        timer.invalidate()
                                        
                                        advanceToCutscene()
                                        
                                        
                                    }
                                }
                            }
                    }
                    
                    
                    // strikes
                    HStack {
                        Group {
                            
                            ForEach(0..<strikeMax, id: \.self) { i in
                                Text(String("\u{2717}"))
                                    .foregroundColor(strikes < i + 1 ? .black : .red)
                            }
                            
                            
                        }
                        .font(.system(size: 48))
                        
                    }
                }
                .padding([.top])
                .opacity(game_opacity)

                
                
                Spacer()
                
            
                
                // math stuff
                MathQuestionsView(strikes: $strikes, is_player_falling: $is_player_falling, timerDuration: timerDuration, moreDuration: moreDuration)
                .scaleEffect(CGSize(width: zoomconstant, height: zoomconstant), anchor: .bottom)
                .opacity(game_opacity)


                
                
                HStack (alignment: .bottom){
                    
                    // multiple choice quiz
                    QuizView(strikes: $strikes, timerDuration: timerDuration, moreDuration: moreDuration, is_player_falling: $is_player_falling)
                        .frame(minWidth: 500, idealWidth: 650, maxWidth: 700, minHeight: 200, idealHeight: 500, maxHeight: 800, alignment: .center)
                        .padding([.leading], 50)
                        .opacity(game_opacity)
                    
                    
                    // player
                    ZStack {
                        Image(is_player_looking_up ? "look\(Int(walkframe))" : is_player_falling ? "fall\(Int(walkframe))" : "walk\(Int(walkframe))")
                            .resizable()
                            .frame(width: 350, height: 350)
                        
                            .padding(.bottom)
                            .onAppear {
                                _ = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { timer in
                                    
                                    // stop-motion frame animation for player
                                    
                                    if (walkframe == 3 && !is_player_falling){
                                        walkframe = 0
                                        
                                    }
                                    else if (walkframe == 3 && is_player_falling) {
                                        timer.invalidate()
                                    }
                                    else if (is_player_falling) {
                                        walkframe += 0.5
                                    }
                                    else {
                                        walkframe += 1
                                    }
                                    
                                }
                            }
                            .onChange(of: is_player_looking_up) {value in
                                walkframe = 0
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    walkframe = 1
                                }
                                
                            }
                        
                        
                        Image(yellowframe)
                            .resizable()
                            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                            .frame(width: 350, height: 466.5)
                            .offset(x: yellowoffset, y: -50)
                            .padding(.bottom)
                        
                    }
                    // notifications from phone
                    NotificationsView(is_player_falling: $is_player_falling)
                        .offset(x: -120, y: -360)
                        .scaleEffect(CGSize(width: zoomconstant, height: zoomconstant), anchor: .bottom)
                        .opacity(game_opacity)
                    
                }
                .scaleEffect(CGSize(width: zoomconstant, height: zoomconstant), anchor: .bottom)
                
            }
            
            
            
            
            // the stuff that happens after she falls
            if (is_player_falling) {
                
                EndingView(is_player_looking_up: $is_player_looking_up, rainbow_part: $rainbow_part, zoom_constant: $zoomconstant, audio_player: $audio_player, small_player: $small_player, yellowframe: $yellowframe, yellowoffset: $yellowoffset)
                .opacity(1 - game_opacity)
                
            }
            
            // final endgame dialogue
            if (rainbow_part) {
                FinalDialogueView(app_state: $app_state)
            }
        }
        
        .onChange(of: strikes) { newValue in
            // update strikes
            strikes = newValue
            if (newValue >= strikeMax && !is_player_falling) {
                advanceToCutscene()
            }
        }
        
        .onChange(of: rainbow_part) { newValue in
            // synchronise sound and transition into a fuller version of the soundtrack
            let currentDeviceTime = small_player.deviceCurrentTime
            let trackTime = small_player.currentTime
            audio_player.currentTime = trackTime
            audio_player.play(atTime: currentDeviceTime + 0.1)

            audio_player.setVolume(1, fadeDuration: 0.5)
            small_player.setVolume(0, fadeDuration: 0.5)
            
            rain_player.setVolume(0, fadeDuration: 1)
            
            withAnimation(.easeInOut(duration: 2)) {
                zoomconstant = 1.0
                rain_modulo_visible = 35
            }
            
        }
        .onAppear {
            _ = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
                
                rain_modulo_visible = max(1, rain_modulo_visible - 1)
                
                if (is_player_falling) {
                    rain_modulo_visible = 1
                    timer.invalidate()
                }
            }
            
        }
    }
    

    func advanceToCutscene() {
        is_player_falling = true
        walkframe = 0
        audio_player.setVolume(0, fadeDuration: 1)
        
        withAnimation (.easeInOut(duration: 1.0)) {
            zoomconstant = 2.0
            game_opacity = 0
        }
    }
    
    
    
}

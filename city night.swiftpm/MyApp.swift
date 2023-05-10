import SwiftUI
import AVFoundation


@main
struct MyApp: App {
    
    
    init () { // initialise audio
        let url = Bundle.main.url(forResource: "ost", withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: url!)
        
        let small_url = Bundle.main.url(forResource: "small", withExtension: "mp3")
        small_player = try! AVAudioPlayer(contentsOf: small_url!)
        
        let rain_url = Bundle.main.url(forResource: "rain", withExtension: "mp3")
        rain_player = try! AVAudioPlayer(contentsOf: rain_url!)

        
        player.numberOfLoops =  -1
        player.play()
        
        // the quieter ost should be silent at first, it comes in later
        small_player.numberOfLoops = -1
        small_player.setVolume(0, fadeDuration: 0)
        
        rain_player.numberOfLoops =  -1
        rain_player.play()
    
    }
    
    // store app state to switch screens
    @State var app_state = AppState.opening
    
    @State var player: AVAudioPlayer
    @State var small_player: AVAudioPlayer
    @State var rain_player: AVAudioPlayer
    
    var body: some Scene {
        WindowGroup {
            // display page depending on app state & pass in the audio players so they can be changed (if needed)
            switch app_state {
            case .opening:
                OpeningView(app_state: $app_state)
            case .game:
                ContentView(app_state: $app_state, audio_player: $player, small_player: $small_player, rain_player: $rain_player)
            case .closing:
                ClosingView()
            }    
        }
        
    }
}

enum AppState {
    case opening
    case game
    case closing
}

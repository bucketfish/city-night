import SwiftUI

struct NotificationsView: View {
    @Binding var is_player_falling: Bool
    
    @State var notifsshowing = -2
    
    var notifitems = [
        NotifItem(name: "email", content: "The deadline to apply for leadership positions is next week, don't miss out!"),
        NotifItem(name: "friend", content: "Can you help me with physics??"),
        NotifItem(name: "classroom", content: "English comprehension — due tomorrow"),
        NotifItem(name: "mom", content: "Are you on your way home yet?"),
        NotifItem(name: "study group", content: "Last-minute cram session tonight at 8 pm, see you all there~"),
        NotifItem(name: "weather app", content: "Severe thunderstorm warning in effect for your area"),
        NotifItem(name: "friend", content: "Hey, have you done the math assignment yet?"),
        NotifItem(name: "group project", content: "We need to reschedule our meeting, when are you free?"),
        NotifItem(name: "email", content: "Summer internship applications are due in 2 days, don't miss the deadline!"),
        NotifItem(name: "classroom", content: "Project proposal — due this friday"),
        NotifItem(name: "friend", content: "Did you understand anything from that lecture? I'm so lost!"),
        NotifItem(name: "group project", content: "We need to meet ASAP to work on our presentation!"),
        NotifItem(name: "calendar", content: "Reminder: Consultation tomorrow at 10 am"),
        NotifItem(name: "email", content: "Don't forget to sign up for the career fair next week!")
    ]
    
    
    var body: some View {
        VStack (alignment: .leading){
            Spacer() // bottom align
            
            ForEach(min(notifsshowing, notifitems.count - 1)...min(notifitems.count - 1, notifsshowing + 2), id: \.self) { i in
                
                if i >= 0 {
                    ChatBubble (showTail: i == min(notifitems.count - 1, notifsshowing + 2)) {
                        Group {
                            Text (notifitems[i].name + ": ").foregroundColor(.black).bold() +
                            Text (notifitems[i].content).foregroundColor(.gray)
                        }
                        .font(.title2)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding([.leading], 20)
                        .padding([.top, .bottom, .trailing], 15)
                        .background(Color.white)
                        // padding offsets to position it at user's phone (hopefully)
                        
                    }
                }
                
            }
            
        }
        .frame(minWidth: 400, idealWidth: 450, maxWidth: 600, minHeight: 150, idealHeight: 350, maxHeight: 600)
        .padding([.trailing], 50)
        
        .onAppear { // notifs show up automatically by increasing the number showing
            _ = Timer.scheduledTimer(withTimeInterval: 6, repeats: true) { timer in
                notifsshowing += 1
                
                if (is_player_falling) {
                    timer.invalidate()
                }
            }
        }
    }
}

import SwiftUI

struct ContentView: View {
    @StateObject private var personalityAnalyzer = PersonalityAnalyzer()
    @StateObject private var voiceManager = VoiceManager()
    
    var body: some View {
        NavigationStack {
            WelcomeView()
                .environmentObject(personalityAnalyzer)
                .environmentObject(voiceManager)
        }
    }
}

#Preview {
    ContentView()
}

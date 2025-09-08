import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var personalityAnalyzer: PersonalityAnalyzer
    @EnvironmentObject var voiceManager: VoiceManager
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // 欢迎标题
            VStack(spacing: 20) {
                Image(systemName: "heart.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.pink)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isAnimating)
                
                Text("欢迎来到个性分析")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text("Welcome to Personality Analysis")
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // 描述文本
            VStack(spacing: 15) {
                Text("通过简单的对话，我将帮助您")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                
                Text("发现您独特的个性特征")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .multilineTextAlignment(.center)
                
                Text("Through simple conversations, I'll help you discover your unique personality traits")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Spacer()
            
            // 开始按钮
            NavigationLink(destination: ChatView().environmentObject(personalityAnalyzer).environmentObject(voiceManager)) {
                HStack {
                    Image(systemName: "message.circle.fill")
                    Text("开始聊天")
                        .fontWeight(.semibold)
                    Text("Start Chat")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(15)
                .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 50)
        }
        .padding()
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    NavigationStack {
        WelcomeView()
            .environmentObject(PersonalityAnalyzer())
            .environmentObject(VoiceManager())
    }
}

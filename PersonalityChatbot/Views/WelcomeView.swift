import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var personalityAnalyzer: PersonalityAnalyzer
    @EnvironmentObject var voiceManager: VoiceManager
    @State private var isAnimating = false
    @State private var showVoiceTest = false
    
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
                
                // 语音功能说明
                VStack(spacing: 10) {
                    HStack {
                        Image(systemName: "keyboard")
                        Text("支持键盘输入")
                        Spacer()
                        Image(systemName: "mic.fill")
                        Text("支持语音对话")
                    }
                    .font(.body)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 20)
                    
                    Text("您可以选择先测试语音功能，或直接开始对话")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
            
            Spacer()
            
            // 操作按钮
            VStack(spacing: 15) {
                // 语音测试按钮
                Button(action: {
                    showVoiceTest = true
                }) {
                    HStack {
                        Image(systemName: "mic.badge.plus")
                        Text("先测试语音功能")
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                    )
                }
                
                // 直接开始按钮
                NavigationLink(destination: ChatView().environmentObject(personalityAnalyzer).environmentObject(voiceManager)) {
                    HStack {
                        Image(systemName: "message.circle.fill")
                        Text("直接开始对话")
                            .fontWeight(.semibold)
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
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 50)
        }
        .padding()
        .onAppear {
            isAnimating = true
        }
        .sheet(isPresented: $showVoiceTest) {
            VoiceTestView()
                .environmentObject(voiceManager)
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

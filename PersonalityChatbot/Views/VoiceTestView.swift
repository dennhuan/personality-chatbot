import SwiftUI

struct VoiceTestView: View {
    @EnvironmentObject var voiceManager: VoiceManager
    @Environment(\.dismiss) var dismiss
    @State private var testStep: VoiceTestStep = .introduction
    @State private var testComplete = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // 标题
                VStack(spacing: 10) {
                    Image(systemName: "mic.badge.plus")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("语音功能测试")
                        .font(.title)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                // 测试步骤内容
                VStack(spacing: 20) {
                    switch testStep {
                    case .introduction:
                        introductionView
                    case .permissionCheck:
                        permissionCheckView
                    case .speechRecognitionTest:
                        speechRecognitionTestView
                    case .textToSpeechTest:
                        textToSpeechTestView
                    case .completion:
                        completionView
                    }
                }
                
                Spacer()
                
                // 操作按钮
                HStack(spacing: 20) {
                    if testStep != .introduction {
                        Button("上一步") {
                            previousStep()
                        }
                        .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    if testStep == .completion {
                        Button("完成测试") {
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                    } else {
                        Button(testStep == .introduction ? "开始测试" : "下一步") {
                            nextStep()
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(!canProceed)
                    }
                }
                .padding()
            }
            .padding()
            .navigationTitle("语音测试")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("跳过") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // MARK: - Test Step Views
    
    private var introductionView: some View {
        VStack(spacing: 15) {
            Text("语音功能包含两个部分：")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "mic.fill")
                        .foregroundColor(.blue)
                    Text("语音识别：将您的话转换为文字")
                }
                
                HStack {
                    Image(systemName: "speaker.wave.2.fill")
                        .foregroundColor(.green)
                    Text("语音合成：将机器人的回复朗读出来")
                }
            }
            .font(.body)
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(10)
            
            Text("我们将逐步测试这些功能，确保一切工作正常。")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    private var permissionCheckView: some View {
        VStack(spacing: 20) {
            Text("检查权限设置")
                .font(.headline)
            
            VStack(spacing: 15) {
                HStack {
                    Image(systemName: voiceManager.isAuthorized ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(voiceManager.isAuthorized ? .green : .red)
                    Text("麦克风和语音识别权限")
                    Spacer()
                    Text(voiceManager.isAuthorized ? "已授权" : "需要授权")
                        .foregroundColor(voiceManager.isAuthorized ? .green : .red)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            }
            
            if !voiceManager.isAuthorized {
                Text("请在系统设置中允许应用使用麦克风和语音识别功能。")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Button("打开设置") {
                    if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsUrl)
                    }
                }
                .foregroundColor(.blue)
            } else {
                Text("权限设置正常，可以继续测试！")
                    .font(.body)
                    .foregroundColor(.green)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    private var speechRecognitionTestView: some View {
        VStack(spacing: 20) {
            Text("测试语音识别")
                .font(.headline)
            
            Text("请按住下方按钮并说："你好，我想测试语音功能"")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
            
            // 语音识别状态
            VStack(spacing: 15) {
                Button(action: {
                    if voiceManager.isRecording {
                        voiceManager.stopRecording()
                    } else {
                        do {
                            try voiceManager.startRecording()
                        } catch {
                            // 处理错误
                        }
                    }
                }) {
                    VStack {
                        Image(systemName: voiceManager.isRecording ? "mic.fill" : "mic")
                            .font(.system(size: 40))
                            .foregroundColor(voiceManager.isRecording ? .red : .blue)
                        Text(voiceManager.isRecording ? "正在录音..." : "点击开始录音")
                            .font(.caption)
                    }
                    .frame(width: 100, height: 100)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(Circle())
                }
                
                if !voiceManager.speechText.isEmpty {
                    VStack(spacing: 5) {
                        Text("识别结果：")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(voiceManager.speechText)
                            .font(.body)
                            .padding()
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
    
    private var textToSpeechTestView: some View {
        VStack(spacing: 20) {
            Text("测试语音合成")
                .font(.headline)
            
            Text("点击下方按钮，听听机器人的声音：")
                .font(.body)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 15) {
                Button(action: {
                    if voiceManager.isSpeaking {
                        voiceManager.stopSpeaking()
                    } else {
                        voiceManager.speak(text: "你好！我是你的个性分析助手。我会帮助你了解自己的个性特征。")
                    }
                }) {
                    HStack {
                        Image(systemName: voiceManager.isSpeaking ? "speaker.slash.fill" : "speaker.wave.2.fill")
                        Text(voiceManager.isSpeaking ? "停止播放" : "播放测试语音")
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
                }
                
                if voiceManager.isSpeaking {
                    HStack {
                        ProgressView()
                            .scaleEffect(0.8)
                        Text("正在播放...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Text("如果您能听到清晰的中文语音，说明语音合成功能正常。")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    private var completionView: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)
            
            Text("语音功能测试完成！")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("语音识别功能正常")
                }
                
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("语音合成功能正常")
                }
            }
            .font(.body)
            .padding()
            .background(Color.green.opacity(0.1))
            .cornerRadius(10)
            
            Text("现在您可以开始使用语音功能进行个性分析对话了！")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Helper Functions
    
    private var canProceed: Bool {
        switch testStep {
        case .introduction:
            return true
        case .permissionCheck:
            return voiceManager.isAuthorized
        case .speechRecognitionTest:
            return !voiceManager.speechText.isEmpty
        case .textToSpeechTest:
            return true
        case .completion:
            return true
        }
    }
    
    private func nextStep() {
        switch testStep {
        case .introduction:
            testStep = .permissionCheck
        case .permissionCheck:
            testStep = .speechRecognitionTest
            voiceManager.clearSpeechText()
        case .speechRecognitionTest:
            testStep = .textToSpeechTest
        case .textToSpeechTest:
            testStep = .completion
        case .completion:
            break
        }
    }
    
    private func previousStep() {
        switch testStep {
        case .introduction:
            break
        case .permissionCheck:
            testStep = .introduction
        case .speechRecognitionTest:
            testStep = .permissionCheck
        case .textToSpeechTest:
            testStep = .speechRecognitionTest
        case .completion:
            testStep = .textToSpeechTest
        }
    }
}

enum VoiceTestStep: CaseIterable {
    case introduction
    case permissionCheck
    case speechRecognitionTest
    case textToSpeechTest
    case completion
}

#Preview {
    VoiceTestView()
        .environmentObject(VoiceManager())
}

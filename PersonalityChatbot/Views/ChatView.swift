import SwiftUI

struct ChatView: View {
    @EnvironmentObject var personalityAnalyzer: PersonalityAnalyzer
    @EnvironmentObject var voiceManager: VoiceManager
    @State private var inputText: String = ""
    @State private var showVoiceError = false
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(personalityAnalyzer.messages) { msg in
                            HStack {
                                if msg.isFromUser { Spacer() }
                                
                                VStack(alignment: msg.isFromUser ? .trailing : .leading) {
                                    Text(msg.content)
                                        .padding(12)
                                        .foregroundColor(msg.isFromUser ? .white : .primary)
                                        .background(msg.isFromUser ? Color.blue : Color.gray.opacity(0.15))
                                        .cornerRadius(12)
                                    
                                    // 为机器人消息添加播放按钮
                                    if !msg.isFromUser {
                                        HStack {
                                            Button(action: {
                                                if voiceManager.isSpeaking {
                                                    voiceManager.stopSpeaking()
                                                } else {
                                                    voiceManager.speak(text: msg.content)
                                                }
                                            }) {
                                                Image(systemName: voiceManager.isSpeaking ? "speaker.slash.fill" : "speaker.wave.2.fill")
                                                    .foregroundColor(.blue)
                                                    .font(.caption)
                                            }
                                            .buttonStyle(.plain)
                                            Spacer()
                                        }
                                        .padding(.horizontal, 12)
                                    }
                                }
                                
                                if !msg.isFromUser { Spacer() }
                            }
                            .id(msg.id)
                        }
                        if personalityAnalyzer.isTyping {
                            HStack {
                                ProgressView().scaleEffect(0.8)
                                Text("正在思考…")
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                        }
                    }
                    .padding()
                }
                .onChange(of: personalityAnalyzer.messages.count) { _ in
                    if let last = personalityAnalyzer.messages.last { proxy.scrollTo(last.id, anchor: .bottom) }
                }
            }
            
            Divider()
            
            // 语音识别状态显示
            if voiceManager.isRecording {
                HStack {
                    Image(systemName: "waveform")
                        .foregroundColor(.red)
                        .font(.title2)
                    Text(voiceManager.isListening ? "正在聆听..." : "语音识别中...")
                        .foregroundColor(.secondary)
                    Spacer()
                    Button("停止") {
                        voiceManager.stopRecording()
                        if !voiceManager.speechText.isEmpty {
                            inputText = voiceManager.speechText
                        }
                    }
                    .foregroundColor(.red)
                }
                .padding()
                .background(Color.red.opacity(0.1))
            }
            
            // 语音文本预览
            if !voiceManager.speechText.isEmpty {
                VStack(alignment: .leading) {
                    Text("语音识别结果:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(voiceManager.speechText)
                        .padding(8)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }
                .padding(.horizontal)
            }
            
            // 输入区域
            HStack {
                TextField("输入内容…", text: $inputText)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: voiceManager.speechText) { speechText in
                        if !speechText.isEmpty {
                            inputText = speechText
                        }
                    }
                
                // 语音输入按钮
                Button(action: {
                    if voiceManager.isRecording {
                        voiceManager.stopRecording()
                        if !voiceManager.speechText.isEmpty {
                            inputText = voiceManager.speechText
                        }
                    } else {
                        do {
                            try voiceManager.startRecording()
                            voiceManager.clearSpeechText()
                        } catch {
                            showVoiceError = true
                        }
                    }
                }) {
                    Image(systemName: voiceManager.isRecording ? "mic.fill" : "mic")
                        .foregroundColor(voiceManager.isRecording ? .red : .blue)
                        .font(.title2)
                }
                .disabled(!voiceManager.isAuthorized)
                
                Button("发送") {
                    let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !text.isEmpty else { return }
                    personalityAnalyzer.processUserInput(text)
                    inputText = ""
                    voiceManager.clearSpeechText()
                }
                .buttonStyle(.borderedProminent)
                .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding()
        }
        .navigationTitle("个性测试")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if personalityAnalyzer.showResult {
                    NavigationLink("查看结果") {
                        ResultView()
                            .environmentObject(personalityAnalyzer)
                    }
                }
                
                // 语音控制按钮
                if voiceManager.isSpeaking {
                    Button(action: {
                        voiceManager.stopSpeaking()
                    }) {
                        Image(systemName: "speaker.slash")
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .alert("语音权限错误", isPresented: $showVoiceError) {
            Button("确定", role: .cancel) { }
            Button("设置") {
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsUrl)
                }
            }
        } message: {
            Text(voiceManager.errorMessage ?? "无法使用语音功能，请检查麦克风和语音识别权限")
        }
        .onChange(of: voiceManager.errorMessage) { error in
            showVoiceError = error != nil
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            // 应用失去焦点时停止录音
            if voiceManager.isRecording {
                voiceManager.stopRecording()
            }
        }
    }
}

#Preview {
    NavigationStack {
        ChatView()
            .environmentObject(PersonalityAnalyzer())
            .environmentObject(VoiceManager())
    }
}

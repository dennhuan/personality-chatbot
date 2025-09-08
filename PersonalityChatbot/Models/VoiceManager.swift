import Foundation
import Speech
import AVFoundation
import SwiftUI

// 语音管理器 - 处理语音识别和语音合成
@MainActor
class VoiceManager: NSObject, ObservableObject {
    @Published var isRecording = false
    @Published var isListening = false
    @Published var speechText = ""
    @Published var isAuthorized = false
    @Published var errorMessage: String?
    @Published var isSpeaking = false
    
    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var audioEngine = AVAudioEngine()
    private var speechSynthesizer = AVSpeechSynthesizer()
    
    override init() {
        super.init()
        
        // 设置中文语音识别器
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "zh-Hans-CN"))
        speechRecognizer?.delegate = self
        speechSynthesizer.delegate = self
        
        // 监听自动朗读通知
        NotificationCenter.default.addObserver(self, selector: #selector(handleSpeakBotMessage(_:)), name: .speakBotMessage, object: nil)
        
        Task {
            await requestPermissions()
        }
    }
    
    // 请求语音权限
    private func requestPermissions() async {
        // 请求语音识别权限
        let speechStatus = await SFSpeechRecognizer.requestAuthorization()
        
        // 请求麦克风权限
        let microphoneStatus = await AVAudioSession.sharedInstance().requestRecordPermission()
        
        await MainActor.run {
            self.isAuthorized = speechStatus == .authorized && microphoneStatus
            
            if !self.isAuthorized {
                if speechStatus != .authorized {
                    self.errorMessage = "需要语音识别权限才能使用语音输入"
                } else if !microphoneStatus {
                    self.errorMessage = "需要麦克风权限才能使用语音输入"
                }
            }
        }
    }
    
    // 开始语音识别
    func startRecording() throws {
        // 停止当前的识别任务
        stopRecording()
        
        guard isAuthorized else {
            errorMessage = "缺少必要的语音权限"
            return
        }
        
        // 配置音频会话
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        // 创建识别请求
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            throw VoiceError.recognitionRequestFailed
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        // 如果设备支持，启用设备端识别
        if #available(iOS 13, *) {
            recognitionRequest.requiresOnDeviceRecognition = true
        }
        
        // 配置音频引擎
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
        // 开始语音识别任务
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            Task { @MainActor in
                guard let self = self else { return }
                
                if let result = result {
                    self.speechText = result.bestTranscription.formattedString
                    self.isListening = !result.isFinal
                } else if let error = error {
                    self.errorMessage = "语音识别出错: \(error.localizedDescription)"
                    self.stopRecording()
                }
            }
        }
        
        isRecording = true
        isListening = true
        speechText = ""
        errorMessage = nil
    }
    
    // 停止语音识别
    func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        
        recognitionTask?.cancel()
        recognitionTask = nil
        
        isRecording = false
        isListening = false
    }
    
    // 清除语音文本
    func clearSpeechText() {
        speechText = ""
    }
    
    // 语音合成 - 朗读文本
    func speak(text: String, language: String = "zh-Hans-CN") {
        // 停止当前的语音合成
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = 0.5 // 稍微慢一点的语速，便于理解
        utterance.pitchMultiplier = 1.0
        utterance.volume = 0.8
        
        isSpeaking = true
        speechSynthesizer.speak(utterance)
    }
    
    // 停止语音合成
    func stopSpeaking() {
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
        isSpeaking = false
    }
    
    // 处理自动朗读通知
    @objc private func handleSpeakBotMessage(_ notification: Notification) {
        guard let text = notification.object as? String else { return }
        speak(text: text)
    }
    
    // 暂停/恢复语音合成
    func pauseOrContinueSpeaking() {
        if speechSynthesizer.isPaused {
            speechSynthesizer.continueSpeaking()
        } else if speechSynthesizer.isSpeaking {
            speechSynthesizer.pauseSpeaking(at: .immediate)
        }
    }
}

// MARK: - Speech Recognition Delegate
extension VoiceManager: SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        Task { @MainActor in
            if !available {
                self.errorMessage = "语音识别当前不可用"
                self.stopRecording()
            }
        }
    }
}

// MARK: - Speech Synthesizer Delegate  
extension VoiceManager: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        isSpeaking = true
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeaking = false
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        isSpeaking = false
    }
}

// MARK: - Voice Errors
enum VoiceError: Error, LocalizedError {
    case recognitionRequestFailed
    case audioEngineFailed
    case recognitionFailed
    
    var errorDescription: String? {
        switch self {
        case .recognitionRequestFailed:
            return "无法创建语音识别请求"
        case .audioEngineFailed:
            return "音频引擎启动失败"
        case .recognitionFailed:
            return "语音识别失败"
        }
    }
}

// MARK: - Voice Input State
struct VoiceInputState {
    let isRecording: Bool
    let isListening: Bool
    let speechText: String
    let isAuthorized: Bool
    let errorMessage: String?
    
    var canStartRecording: Bool {
        return isAuthorized && !isRecording
    }
    
    var hasValidSpeechText: Bool {
        return !speechText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

// 通知名称
extension Notification.Name {
    static let speakBotMessage = Notification.Name("speakBotMessage")
}

import Foundation
import SwiftUI

// 个性分类聊天机器人分析器 - 对用户呈现为简单的个性分类工具
class PersonalityAnalyzer: ObservableObject {
    @Published var currentSession: WelcomeChatSession?
    @Published var currentState: ConversationState = .welcome
    @Published var messages: [ChatMessage] = []
    @Published var isTyping: Bool = false
    @Published var showResult: Bool = false
    @Published var personalityResult: PersonalityTendency?
    @Published var autoSpeakBotMessages = true // 自动朗读机器人消息
    
    private let anonymousUserId: String
    private var questionsAsked: Int = 0
    private let totalQuestions = 6 // 用户看到的问题数量
    
    init() {
        self.anonymousUserId = UUID().string
        startNewSession()
    }
    
    // 开始新的对话会话
    func startNewSession() {
        currentSession = WelcomeChatSession(userId: anonymousUserId)
        currentState = .welcome
        messages = []
        questionsAsked = 0
        showResult = false
        personalityResult = nil
        addWelcomeMessage()
    }
    
    // 处理用户输入
    func processUserInput(_ input: String) {
        guard currentState != .completion else { return }
        
        let userMessage = ChatMessage(
            content: input,
            isFromUser: true,
            messageType: .response,
            questionId: nil
        )
        messages.append(userMessage)
        currentSession?.messages.append(userMessage)
        questionsAsked += 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.generateNextPrompt()
        }
    }
    
    private func generateNextPrompt() {
        isTyping = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.isTyping = false
            let text: String
            switch self.questionsAsked {
            case 1:
                self.currentState = .identityExploration
                text = "如果朋友介绍你，他们会用哪个词来形容你？A理性 B温和 C有趣 D可靠"
            case 2:
                self.currentState = .valueDiscovery
                text = "做重要决定时你最看重？A事实 B感受 C机会 D稳定"
            case 3:
                self.currentState = .relationshipMapping
                text = "团队中你更像？A规划者 B协调者 C点子王 D执行者"
            case 4:
                self.currentState = .motivationUncovering
                text = "什么场景最让你有动力？A安静深思 B融洽协作 C新鲜挑战 D清晰秩序"
            case 5:
                self.currentState = .fearAcknowledgment
                text = "压力来时你更倾向？A分析原因 B寻求支持 C换个思路 D按计划走"
            case 6:
                self.currentState = .visionSharing
                text = "周末更喜欢？A学习充电 B陪伴交流 C探索尝新 D在家放松"
            default:
                self.currentState = .integration
                self.personalityResult = self.inferResult()
                self.showResult = true
                self.currentState = .completion
                text = self.makeResultText()
            }
            if !text.isEmpty {
                let bot = ChatMessage(content: text, isFromUser: false, messageType: self.currentState == .completion ? .completion : .question)
                self.messages.append(bot)
                self.currentSession?.messages.append(bot)
                
                // 发送通知以触发TTS
                if self.autoSpeakBotMessages {
                    NotificationCenter.default.post(name: .speakBotMessage, object: text)
                }
            }
        }
    }
    
    private func inferResult() -> PersonalityTendency {
        // 这里用简化规则：根据提问数随机，真实实现应基于答案统计
        return PersonalityTendency.allCases.randomElement() ?? .analytical
    }
    
    private func makeResultText() -> String {
        guard let result = personalityResult else { return "分析错误，请重试。" }
        let desc = result.getCurrentDescription(intensity: .moderate)
        return """
        🎉 个性分析完成
        你的个性倾向：\(result.title)
        \n\(desc)\n\n提示：个性会随着经历而变化，这只是当前倾向。
        """
    }
    
    func restart() { startNewSession() }
    
    private func addWelcomeMessage() {
        let welcomeText = "欢迎来到个性分析测试！先简单聊聊，回答几个问题即可获得你的个性倾向。随便回复任何内容开始～"
        let welcome = ChatMessage(
            content: welcomeText,
            isFromUser: false,
            messageType: .welcome
        )
        messages.append(welcome)
        currentSession?.messages.append(welcome)
        
        // 自动朗读欢迎消息
        if autoSpeakBotMessages {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                NotificationCenter.default.post(name: .speakBotMessage, object: welcomeText)
            }
        }
    }
}

private extension UUID {
    var string: String { uuidString }
}

// 通知名称
extension Notification.Name {
    static let speakBotMessage = Notification.Name("speakBotMessage")
}

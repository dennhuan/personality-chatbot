import Foundation

// 聊天消息模型 - 为后续专家分析设计
struct ChatMessage: Identifiable, Codable {
    let id = UUID()
    let content: String
    let isFromUser: Bool
    let timestamp: Date
    let messageType: MessageType
    let questionId: String? // 关联的问题ID，便于分析
    let responseContext: ResponseContext? // 回答的上下文信息
    
    init(content: String, isFromUser: Bool, messageType: MessageType = .text, questionId: String? = nil, responseContext: ResponseContext? = nil) {
        self.content = content
        self.isFromUser = isFromUser
        self.messageType = messageType
        self.questionId = questionId
        self.responseContext = responseContext
        self.timestamp = Date()
    }
}

enum MessageType: String, Codable {
    case welcome = "欢迎"
    case question = "问题"
    case response = "回答"
    case followUp = "追问"
    case transition = "过渡"
    case completion = "完成"
}

// 回答上下文 - 帮助专家理解回答背景
struct ResponseContext: Codable {
    let responseTime: TimeInterval // 回答思考时间
    let responseLength: Int        // 回答长度
    let hesitationMarkers: [String] // 犹豫标记词 ("嗯", "这个", "可能")
    let emotionalIndicators: [String] // 情感指示词
    let specificityLevel: SpecificityLevel // 回答具体性程度
}

enum SpecificityLevel: String, Codable {
    case vague = "模糊" // "还好吧", "一般"
    case general = "一般" // 比较笼统的回答
    case specific = "具体" // 具体的例子和描述
    case detailed = "详细" // 非常详细的描述
}

// 欢迎聊天会话 - 为专家分析优化
struct WelcomeChatSession: Identifiable, Codable {
    let id = UUID()
    let userId: String
    let startTime: Date
    var endTime: Date?
    var messages: [ChatMessage]
    var questionResponses: [QuestionResponse] // 结构化的问答对
    var behavioralObservations: BehavioralObservations
    var isCompleted: Bool
    
    init(userId: String) {
        self.id = UUID()
        self.userId = userId
        self.startTime = Date()
        self.messages = []
        self.questionResponses = []
        self.behavioralObservations = BehavioralObservations()
        self.isCompleted = false
    }
}

// 结构化问答对
struct QuestionResponse: Identifiable, Codable {
    let id = UUID()
    let question: PsychologicalQuestion
    let userResponse: String
    let responseTime: TimeInterval
    let followUpResponses: [String] // 追问的回答
    let confidenceLevel: ConfidenceLevel // 回答的自信程度
    let emotionalState: EmotionalState // 回答时的情感状态
}

enum ConfidenceLevel: String, Codable {
    case uncertain = "不确定" // "我不太确定", "可能是"
    case somewhat = "比较确定" // "我觉得是", "应该是"
    case confident = "确定" // "我确定", "绝对是"
    case absolute = "非常确定" // "毫无疑问"
}

enum EmotionalState: String, Codable {
    case neutral = "中性"
    case excited = "兴奋"
    case hesitant = "犹豫"
    case defensive = "防御"
    case reflective = "反思"
    case passionate = "热情"
    case vulnerable = "脆弱"
}

// 行为观察记录
struct BehavioralObservations: Codable {
    var averageResponseTime: TimeInterval = 0
    var totalPauses: Int = 0 // 长时间暂停次数
    var messageLength: MessageLengthPattern = .balanced
    var communicationPattern: CommunicationPattern = .balanced
    var topicAvoidance: [String] = [] // 回避的话题
    var emotionalShifts: [EmotionalShift] = [] // 情感变化
    var consistencyLevel: ConsistencyLevel = .consistent
}

enum MessageLengthPattern: String, Codable {
    case brief = "简短" // 总是很短的回答
    case verbose = "详细" // 总是很长的回答
    case balanced = "平衡" // 长短适中
    case variable = "变化" // 根据话题变化
}

enum CommunicationPattern: String, Codable {
    case direct = "直接"
    case circumlocutory = "绕圈"
    case balanced = "平衡"
    case contextual = "情境化"
}

enum ConsistencyLevel: String, Codable {
    case consistent = "一致"
    case someInconsistency = "少量不一致"
    case inconsistent = "不一致"
    case contradictory = "矛盾"
}

struct EmotionalShift: Codable {
    let fromState: EmotionalState
    let toState: EmotionalState
    let trigger: String // 触发话题
    let timestamp: Date
}

// 心理学问题框架
struct PsychologicalQuestion: Identifiable, Codable {
    let id: String
    let category: QuestionCategory
    let chineseText: String
    let englishText: String
    let analysisTarget: [AnalysisTarget] // 这个问题要分析什么
    let followUpTriggers: [String] // 什么样的回答需要追问
    let psychologicalFramework: PsychologicalFramework
    let priority: QuestionPriority
}

enum QuestionCategory: String, Codable, CaseIterable {
    case identityCore = "核心身份认同" // "你觉得什么最能代表真正的你？"
    case valueSystem = "价值观系统"   // "什么对你来说最重要？"
    case relationshipStyle = "关系模式" // "你在人际关系中的角色"
    case motivationDriver = "动机驱动" // "什么真正驱动你前进？"
    case fearPattern = "恐惧模式"      // "什么让你最不安？"
    case copingMechanism = "应对机制"  // "压力下你如何反应？"
    case lifeVision = "人生愿景"       // "你理想的生活是什么样？"
    case selfPerception = "自我认知"   // "你如何看待自己？"
    case conflictResolution = "冲突处理" // "面对冲突时的反应"
    case emotionalRegulation = "情绪调节" // "情绪管理方式"
    case decisionMaking = "决策方式"    // "如何做重要决定"
    case meaningMaking = "意义构建"     // "如何理解人生意义"
}

enum AnalysisTarget: String, Codable {
    case personalityTrait = "个性特质"
    case attachmentStyle = "依恋风格"
    case cognitivePattern = "认知模式"
    case emotionalStyle = "情感风格"
    case motivationalCore = "核心动机"
    case defensePattern = "防御模式"
    case valueHierarchy = "价值层次"
    case identityStructure = "身份结构"
    case relationshipNeed = "关系需求"
    case lifeTheme = "人生主题"
}

enum PsychologicalFramework: String, Codable {
    case bigFive = "大五人格"
    case attachment = "依恋理论"
    case cognitive = "认知心理学"
    case humanistic = "人本主义"
    case psychodynamic = "心理动力学"
    case existential = "存在主义心理学"
    case positive = "积极心理学"
    case narrative = "叙事心理学"
}

enum QuestionPriority: String, Codable {
    case essential = "必问" // 核心问题，必须问到
    case important = "重要" // 重要问题，最好问到
    case supplementary = "补充" // 补充问题，时间允许时问
    case contextual = "情境" // 根据前面回答决定是否问
}

// 对话状态
enum ConversationState {
    case welcome              // 欢迎和建立信任
    case identityExploration  // 身份认同探索
    case valueDiscovery       // 价值观发现
    case relationshipMapping  // 关系模式映射
    case motivationUncovering // 动机挖掘
    case fearAcknowledgment   // 恐惧承认
    case visionSharing        // 愿景分享
    case integration          // 整合总结
    case completion           // 完成
}

// 用户档案 - 为专家分析准备
struct UserAnalysisProfile: Identifiable, Codable {
    let id = UUID()
    let anonymousId: String
    let createdAt: Date
    var chatSessions: [WelcomeChatSession]
    var readyForAnalysis: Bool // 是否有足够数据进行专家分析
    
    init(anonymousId: String) {
        self.anonymousId = anonymousId
        self.createdAt = Date()
        self.chatSessions = []
        self.readyForAnalysis = false
    }
    
    // 检查是否收集了足够的数据
    mutating func assessAnalysisReadiness() {
        let completedSessions = chatSessions.filter { $0.isCompleted }
        let totalResponses = completedSessions.flatMap { $0.questionResponses }.count
        let essentialQuestionsAnswered = completedSessions.flatMap { $0.questionResponses }
            .filter { $0.question.priority == .essential }.count
        
        readyForAnalysis = totalResponses >= 20 && essentialQuestionsAnswered >= 10
    }
}

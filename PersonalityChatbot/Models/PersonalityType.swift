import Foundation

// 个性倾向枚举 - 强调这是倾向而非固定类型
enum PersonalityTendency: String, CaseIterable {
    case analytical = "分析倾向"      // 理性分析倾向
    case harmonizing = "和谐倾向"     // 和谐协调倾向
    case adventurous = "冒险倾向"     // 冒险探索倾向
    case nurturing = "关爱倾向"       // 关怀照顾倾向
    case leading = "领导倾向"         // 领导统率倾向
    case creative = "创造倾向"        // 艺术创造倾向
    case stabilizing = "稳定倾向"     // 守护稳定倾向
    case innovating = "创新倾向"      // 创新变革倾向
    
    var title: String {
        return self.rawValue
    }
}

// 个性特质强度
enum TraitIntensity: String, CaseIterable {
    case mild = "轻微"
    case moderate = "中等"
    case strong = "强烈"
    
    var description: String {
        switch self {
        case .mild: return "你在这方面有轻微的倾向"
        case .moderate: return "你在这方面有中等程度的倾向"
        case .strong: return "你在这方面有强烈的倾向"
        }
    }
}

// 动态个性档案
struct PersonalityProfile {
    let primaryTendency: PersonalityTendency
    let secondaryTendency: PersonalityTendency?
    let intensity: TraitIntensity
    let contextualVariations: [String] // 不同情境下的表现变化
    let growthPotential: [String]      // 成长潜力方向
    let currentLifeStage: String       // 当前人生阶段影响
    
    var isFluid: Bool { return true }  // 强调个性的流动性
    
    var dynamicDescription: String {
        let baseDescription = primaryTendency.getCurrentDescription(intensity: intensity)
        let variationNote = "你的个性会根据环境、经历和成长而发生变化，这是完全正常的。"
        let secondaryNote = secondaryTendency != nil ? 
            "你同时也展现出\(secondaryTendency!.title)的特征。" : ""
        
        return "\(baseDescription)\n\n\(secondaryNote)\n\n\(variationNote)"
    }
}

extension PersonalityTendency {
    func getCurrentDescription(intensity: TraitIntensity) -> String {
        let baseDescription: String
        
        switch self {
        case .analytical:
            baseDescription = "目前你倾向于用理性和逻辑来处理问题。你喜欢深入分析，追求客观真理。这种倾向帮助你做出明智决策，但有时可能让你在情感表达上显得保守。随着生活经历的丰富，你可能会发展出更多直觉思维。"
        case .harmonizing:
            baseDescription = "现阶段你更关注人际和谐与团队协作。你善于理解他人感受，寻求共识与平衡。这让你成为很好的调解者，但有时可能会压抑自己的想法。随着自信心的增长，你会更勇于表达个人观点。"
        case .adventurous:
            baseDescription = "当前你对新体验充满渴望，喜欢探索和冒险。你适应性强，思维灵活，但可能在需要长期专注的事情上缺乏耐心。随着人生阅历的积累，你可能会在冒险精神和稳定性之间找到更好的平衡。"
        case .nurturing:
            baseDescription = "你现在表现出强烈的关爱特质，总是优先考虑他人需求。你的温暖和支持让身边的人感到安全，但有时会忽视自己的需要。通过学习自我关爱，你会发展出更健康的给予方式。"
        case .leading:
            baseDescription = "目前你展现出领导潜质，喜欢承担责任和指导他人。你有明确的目标导向，但有时可能过于强势。随着领导经验的增长，你会学会更好地平衡权威与包容。"
        case .creative:
            baseDescription = "现在你的创造力和艺术天赋比较突出，善于用独特方式表达自己。你敏感且富有想象力，但有时情绪波动较大。随着心理成熟，你会更好地驾驭创造力与情绪的关系。"
        case .stabilizing:
            baseDescription = "当前你重视稳定和可靠性，是他人可以依靠的支柱。你忠诚且有责任心，但可能对变化感到不安。通过逐步接触新事物，你会在稳定性和适应性之间找到平衡。"
        case .innovating:
            baseDescription = "现阶段你思维活跃，总是能想出新点子和解决方案。你喜欢推动变革，但有时执行力不够。通过培养持久力，你会更好地将创新想法转化为实际成果。"
        }
        
        let intensityModifier: String
        switch intensity {
        case .mild:
            intensityModifier = "这些特征在你身上表现得比较温和，可能在特定情况下才会显现。"
        case .moderate:
            intensityModifier = "这些特征在你身上有中等程度的体现，是你个性的重要组成部分。"
        case .strong:
            intensityModifier = "这些特征在你身上表现得很明显，是你个性的主要特色。"
        }
        
        return "\(baseDescription)\n\n\(intensityModifier)"
    }
    
    var adaptiveQualities: [String] {
        switch self {
        case .analytical:
            return ["可以培养更多直觉思维", "能学会更好的情感表达", "有潜力发展创造性思维"]
        case .harmonizing:
            return ["能够发展更强的个人立场", "可以学会健康的冲突处理", "有潜力成为更好的领导者"]
        case .adventurous:
            return ["能够培养更多耐心和专注力", "可以发展长期规划能力", "有潜力在稳定中保持活力"]
        case .nurturing:
            return ["能够学会更好的自我关爱", "可以发展个人边界意识", "有潜力成为更全面的支持者"]
        case .leading:
            return ["能够培养更多同理心", "可以学会更好的倾听技巧", "有潜力发展包容性领导风格"]
        case .creative:
            return ["能够发展更稳定的情绪管理", "可以学会将创意实用化", "有潜力在艺术和现实间平衡"]
        case .stabilizing:
            return ["能够逐步拥抱适度变化", "可以发展创新思维", "有潜力成为变革中的稳定力量"]
        case .innovating:
            return ["能够培养更强的执行力", "可以学会专注和坚持", "有潜力将创新落地实现"]
        }
    }
    
    var contextualVariations: [String: String] {
        let baseVariations: [String: String]
        
        switch self {
        case .analytical:
            baseVariations = [
                "工作环境": "更加理性和系统化",
                "家庭环境": "可能更加感性和直观",
                "压力情况": "倾向于过度分析",
                "放松状态": "可能展现更多创造性思维"
            ]
        case .harmonizing:
            baseVariations = [
                "团队合作": "充分发挥协调能力",
                "个人决策": "可能犹豫不决",
                "冲突情况": "努力寻求妥协",
                "亲密关系": "可能过度迁就"
            ]
        default:
            baseVariations = [
                "不同情境": "表现会有所变化",
                "成长过程": "特征会逐渐演变",
                "生活经历": "会影响个性发展",
                "环境因素": "会带来适应性改变"
            ]
        }
        
        return baseVariations
    }
    
    var growthDirections: [String] {
        switch self {
        case .analytical:
            return ["发展情感智能", "培养直觉判断", "增强人际沟通", "学习接纳不确定性"]
        case .harmonizing:
            return ["建立个人立场", "学习健康冲突", "提升决断能力", "发展自我倡导"]
        case .adventurous:
            return ["培养专注力", "发展长期视野", "学习深度思考", "建立稳定习惯"]
        case .nurturing:
            return ["发展自我关爱", "建立健康边界", "增强个人需求表达", "培养独立性"]
        case .leading:
            return ["发展同理心", "学习包容领导", "培养倾听技巧", "增强团队协作"]
        case .creative:
            return ["稳定情绪管理", "发展实用技能", "学习批评接纳", "平衡理想与现实"]
        case .stabilizing:
            return ["拥抱适度变化", "发展灵活性", "培养创新思维", "学习新事物接纳"]
        case .innovating:
            return ["提升执行力", "发展持久力", "学习专注技能", "培养实践能力"]
        }
    }
}

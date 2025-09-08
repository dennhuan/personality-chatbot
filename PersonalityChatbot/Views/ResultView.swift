import SwiftUI

struct ResultView: View {
    @EnvironmentObject var personalityAnalyzer: PersonalityAnalyzer
    
    var body: some View {
        VStack(spacing: 16) {
            if let result = personalityAnalyzer.personalityResult {
                Image(systemName: "star.circle.fill")
                    .font(.system(size: 64))
                    .foregroundColor(.yellow)
                Text("你的个性倾向")
                    .font(.title2)
                Text("\(result.chineseTitle) / \(result.englishTitle)")
                    .font(.title)
                    .fontWeight(.semibold)
                
                ScrollView {
                    Text(result.getCurrentDescription(intensity: .moderate))
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                }
                
                Button("重新测试") {
                    personalityAnalyzer.restart()
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, 8)
            } else {
                Text("尚未生成结果")
            }
            Spacer()
        }
        .padding()
        .navigationTitle("测试结果")
    }
}

#Preview {
    ResultView().environmentObject(PersonalityAnalyzer())
}

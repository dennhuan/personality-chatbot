# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

This is a bilingual (Chinese/English) iOS app that provides personality analysis through conversational interactions. The app classifies users into personality tendencies using a chat-based interface with **voice input and text-to-speech capabilities**, providing personalized insights designed specifically for Chinese users.

## Development Commands

### Building and Running
```bash
# Open the project in Xcode
open PersonalityChatbot.xcodeproj

# Build the project (Command+B in Xcode)
# Run on simulator (Command+R in Xcode)
```

### Testing
```bash
# Run tests in Xcode (Command+U)
# Or use xcodebuild for command line testing
xcodebuild test -project PersonalityChatbot.xcodeproj -scheme PersonalityChatbot -destination 'platform=iOS Simulator,name=iPhone 15'
```

### Code Analysis
```bash
# Find all Swift files in the project
find . -name "*.swift" -type f

# Search for specific patterns in the codebase
grep -r "PersonalityTendency" PersonalityChatbot/

# View localization files
cat PersonalityChatbot/Resources/Localizable.strings
```

### Python Dependencies (Backend Analysis Components)
```bash
# Install Python dependencies for NLP components
pip install -r requirements.txt

# The requirements.txt includes:
# - numpy, pandas, scikit-learn for data analysis
# - nltk, textblob, spacy for natural language processing
# - pydantic, pyyaml for configuration management
```

## Architecture

### High-Level Structure

The app follows an MVVM architecture with SwiftUI:

1. **App Layer** (`PersonalityChatbot/App/`)
   - `PersonalityChatbotApp.swift`: Main app entry point
   - `ContentView.swift`: Root view with NavigationStack and shared PersonalityAnalyzer

2. **Views** (`PersonalityChatbot/Views/`)
   - `WelcomeView.swift`: Landing page with animated introduction
   - `ChatView.swift`: Main conversation interface with ScrollView and message bubbles
   - `ResultView.swift`: Displays personality analysis results

3. **Models** (`PersonalityChatbot/Models/`)
   - `PersonalityAnalyzer.swift`: Core ObservableObject managing conversation state and analysis logic
   - `PersonalityType.swift`: Defines 8 personality tendencies with bilingual descriptions and growth insights
   - `ChatMessage.swift`: Complex messaging system with psychological context tracking
   - `VoiceManager.swift`: Handles speech recognition (Chinese) and text-to-speech functionality

4. **Data & Resources**
   - `personality_questions.json`: Structured question database
   - `Localizable.strings`: Bilingual localization support

### Key Architectural Patterns

#### State Management
- Uses `@StateObject` and `@EnvironmentObject` for sharing PersonalityAnalyzer and VoiceManager across views
- ConversationState enum tracks progression through analysis stages
- Published properties trigger UI updates automatically

#### Voice Integration Architecture
- **Speech Recognition**: Chinese language speech-to-text using iOS Speech framework
- **Text-to-Speech**: Automatic reading of bot responses with manual controls
- **Permission Management**: Handles microphone and speech recognition permissions gracefully
- **Notification System**: Uses NotificationCenter for coordinating between PersonalityAnalyzer and VoiceManager
- **State Synchronization**: Real-time voice input updates text field, seamless user experience

#### Personality Analysis System
The app implements a sophisticated personality classification system:
- **8 Personality Tendencies**: analytical, harmonizing, adventurous, nurturing, leading, creative, stabilizing, innovating
- **Dynamic Descriptions**: Context-aware descriptions that emphasize personality fluidity
- **Growth-Oriented**: Each tendency includes adaptive qualities and growth directions
- **Cultural Adaptation**: Descriptions specifically crafted for Chinese cultural context

#### Message Architecture
The ChatMessage model is designed for future expert analysis:
- **Response Context Tracking**: Records hesitation markers, response time, specificity levels
- **Behavioral Observations**: Tracks communication patterns, consistency levels, emotional shifts
- **Structured Question-Response Pairs**: Links questions to psychological frameworks (Big Five, attachment theory, etc.)
- **Session Management**: WelcomeChatSession aggregates multiple conversations for analysis

#### Conversation Flow
The PersonalityAnalyzer manages a 6-question conversation flow:
1. **Welcome**: Establishes rapport
2. **Identity Exploration**: "How would friends describe you?"
3. **Value Discovery**: "What matters most in decisions?"
4. **Relationship Mapping**: "Your role in teams?"
5. **Motivation Uncovering**: "What energizes you?"
6. **Fear Acknowledgment**: "How do you handle pressure?"
7. **Vision Sharing**: "Preferred weekend activities?"
8. **Integration**: Generates personalized analysis

### Data Flow

1. **User Input** → `ChatView` text field
2. **Processing** → `PersonalityAnalyzer.processUserInput()`
3. **State Update** → Updates `@Published` properties
4. **UI Refresh** → SwiftUI automatically re-renders affected views
5. **Next Question** → Generated based on conversation stage
6. **Final Analysis** → `inferResult()` creates PersonalityTendency result

### Localization Strategy

- **Bilingual Interface**: All UI text in both Chinese (primary) and English (secondary)
- **Cultural Sensitivity**: Personality descriptions adapted for Chinese users
- **Question Design**: Multiple choice questions designed for Chinese cultural context

### Future Architecture Considerations

The codebase is designed for expansion into professional psychological analysis:
- Complex psychological frameworks (MBTI, Big Five, attachment theory)
- Professional analysis tools with detailed behavioral observations
- Export capabilities for psychological reports
- Integration with external analysis services

## Voice Functionality

### Speech Recognition Features
- **Chinese Language Support**: Optimized for Mandarin Chinese (zh-Hans-CN) speech recognition
- **Real-time Transcription**: Live speech-to-text with partial results during recording
- **Voice Input UI**: Microphone button with visual feedback for recording state
- **Permission Handling**: Graceful requests for microphone and speech recognition permissions
- **Error Management**: User-friendly error messages and settings redirection

### Text-to-Speech Features  
- **Automatic Reading**: Bot responses are automatically read aloud when sent
- **Manual Controls**: Individual play/stop buttons for each bot message
- **Toolbar Controls**: Global TTS stop button in navigation toolbar
- **Chinese TTS**: Optimized speech synthesis for Chinese text with appropriate speed and pitch

### Voice Integration Points
- Voice input automatically populates text field
- Speech recognition works alongside keyboard input
- TTS can be controlled independently for each message
- Voice recording stops automatically when app loses focus
- Seamless integration with existing conversation flow

## Key Files to Understand

- `PersonalityAnalyzer.swift`: The heart of the conversation logic and state management
- `PersonalityType.swift`: Comprehensive personality tendency definitions with cultural adaptations
- `ChatMessage.swift`: Sophisticated messaging architecture designed for psychological analysis
- `VoiceManager.swift`: Complete voice functionality including speech recognition and TTS
- `personality_questions.json`: Question database structure

## Development Notes

### Requirements
- Xcode 14.0+
- iOS 15.0+ deployment target
- Swift 5.7+
- macOS 12.0+ for development

### Testing Strategy
- The app includes comprehensive models designed for unit testing
- Personality analysis logic can be tested independently of UI
- Message context tracking enables behavior analysis testing

### Bilingual Development
When modifying text:
- Always update both Chinese and English versions
- Chinese is the primary language for user interaction
- English serves as secondary/accessibility support
- Cultural context is crucial for personality descriptions

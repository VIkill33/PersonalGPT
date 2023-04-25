//
//  GPTVM.swift
//  PersonalGPT
//
//  Created by Vikill Blacks on 2023/4/25.
//
/*
import SwiftUI
import Alamofire
import SwiftyJSON

class ChatViewModel: ObservableObject {
    
    private let alamoSession: Session
    
    @Published var isLoading = false
    @Published var toastTitle = ""
    @Published var toastSubtitle = ""
    @Published private var generatedText = ""
    
    var settings: Settings
    var user: User
    var promptText: String
    
    init(settings: Settings, user: User, promptText: String) {
        self.settings = settings
        self.user = user
        self.promptText = promptText
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        configuration.urlCache?.removeAllCachedResponses()
        self.alamoSession = Alamofire.Session(configuration: configuration /*, interceptor: interceptor*/)
        
        if settings.isSystemPrompt {
            user.chats.append(Chat(messsages: ["role": "system", "content": settings.systemPrompt], answers: ""))
        }
        if settings.isAssistantPrompt {
            user.chats.append(Chat(messsages: ["role": "assistant", "content": settings.assistantPrompt], answers: ""))
        }
    }
    
    func sendMessage(_ text: String) async {
        isLoading = true
        
        user.chats.append(Chat(messsages: ["content": text, "role": "user"], answers: ""))
        user.chats[user.chats.count - 1].messsages["content"] = text
        user.chats[user.chats.count - 1].answers = " "
        user.chats[user.chats.count - 1].date = Date()
        
        let apiType = settings.apiType
        var apiKey: String
        var url: String
        var parameters: [String: Any]
        var headers: HTTPHeaders
        
        switch apiType {
        case .api2d:
            apiKey = settings.api2d_key
            url = "https://openai.api2d.net/v1/chat/completions"
            
            parameters = [
                "model": settings.model.rawValue,
                "messages": user.messageArray(),
                "max_tokens": 1000,
                "user": user.id.uuidString,
                "stream": true
            ]
            
            headers = [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(apiKey)"
            ]
        case .openai:
            apiKey = settings.api_key
            url = "https://api.openai.com/v1/chat/completions"
            
            parameters = [
                "model": settings.model.rawValue,
                "messages": user.messageArray(),
                "max_tokens": 1000,
                "user": user.id.uuidString,
                "stream": true
            ]
            
            headers = [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(apiKey)"
            ]
        }
        
        let myParameters = MyParameters(model: settings.model.rawValue,
                                        messages: user.messageArray(),
                                        max_tokens: 1000,
                                        user: user.id.uuidString,
                                        stream: true
        )
        
        let request = AF.streamRequest(
            url,
            method: .post,
            parameters: myParameters,
            encoder: JSONParameterEncoder.default,
            headers: headers
        )
        
        do {
            generatedText = try await getStream(request: request)
        } catch let error {
            print(error)
        }
    }
    
    func getStream(request: DataStreamRequest) async throws -> String {
        var finalGeneratedText: String = ""
        return try await withCheckedThrowingContinuation { continuation in
            request.responseStreamString { [self] stream in
                switch stream.event {
                case let .stream(result):
                    switch result {
                    case let .success(data):
                        let string = data
                        print(string)
                        var message = findContent(form: string, of: "\"content\":\"", endBefore: "\"},\"index\"")
                        if message.contains("\\\"") {
                            message = message.replacingOccurrences(of: "\\\"", with: #"""#)
                        }
                        if message.contains("\\n") {
                            message = message.replacingOccurrences(of: "\\n", with: "  \n")
                        }
                        if string.prefix(4) == "data" {
                            // 处理得到的消息内容
                            // DispatchQueue.main.async {
                                generatedText += message
                            self.user.chats[self.user.chats.count - 1].answers = self.generatedText
                            //}
                        } else {
                            var error_message = findContent(form: string, of: "\"message\": \"", endBefore: "\",\n")
                            var error_type = findContent(form: string, of: "\"type\": \"", endBefore: "\",\n")
                            error_message = error_message.count > 0 ? error_message : "Oops, something went wrong!"
                            
                            DispatchQueue.main.async {
                                self.generatedText = error_message
                                user.chats[user.chats.count - 1].answers = generatedText
                                self.toastTitle = error_message
                                self.toastSubtitle = error_type
                                self.settings.isShowErrorToast = true
                            }
                        }
                        //continuation.resume(returning: data)
                    case let .failure(error):
                        print(error)
                        continuation.resume(throwing: AFError.responseSerializationFailed(reason: .inputFileNil))
                    }
                case .complete(_):
                    print(generatedText)
                    print(finalGeneratedText)
                    DispatchQueue.main.async {
                        user.chats.append(Chat(messsages: ["role": "assistant", "content": generatedText], answers: ""))
                        isLoading = false
                        promptText = ""
                        generatedText = ""
                    }
                }
            }
        }
    }
    
}
*/

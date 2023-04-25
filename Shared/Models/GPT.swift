//
//  GPT.swift
//  PersonalGPT
//
//  Created by Vikill Blacks on 2023/3/3.
//

import SwiftUI
import Alamofire
import SwiftyJSON

public enum api_type: String {
    case openai
    case api2d
}

enum Models: String, CaseIterable, Identifiable {
    case gpt4 = "gpt-4"
    case gpt40314 = "gpt-4-0314"
    case gpt432k = "gpt-4-32k"
    case gpt432k0314 = "gpt-4-32k-0314"
    case gpt35turbo = "gpt-3.5-turbo"
    case gpt35turbo0301 = "gpt-3.5-turbo-0301"
    var id: String {self.rawValue}
}

extension ChatView {
    //@MainActor
    func generateText(prompt_text: String) async -> Void {
        lazy var alamoSession: Session = {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 20
            configuration.urlCache?.removeAllCachedResponses()
            return Alamofire.Session(configuration: configuration /*, interceptor: interceptor*/)
        }()
        
        //DispatchQueue.main.async {
        isLoading = true
        if user.chats.isEmpty {
            if settings.isSystemPrompt {
                user.chats.append(Chat(messsages: ["role": "system", "content": settings.systemPrompt], answers: ""))
            }
            if settings.isAssistantPrompt {
                user.chats.append(Chat(messsages: ["role": "assistant", "content": settings.assistantPrompt], answers: ""))
            }
        }
        
        user.chats.append(Chat(messsages: ["content": prompt_text, "role": "user"], answers: ""))
        
        user.chats[user.chats.count - 1].messsages["content"] = prompt_text
        user.chats[user.chats.count - 1].answers = " "
        user.chats[user.chats.count - 1].date = Date()
        //}
        let apiType = settings.apiType
        var apiKey: String
        var url: String
        var parameters: [String: Any]
        var headers: HTTPHeaders
        
        switch apiType {
        case .api2d:
            apiKey = settings.api2d_key
            url = "https://openai.api2d.net/v1/chat/completions"
            
            // user.chat.messsages.append(["content": promptText, "role": "user"])
            
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
            
            
            
            
            // user.chat.messsages.append(["content": promptText, "role": "user"])
            
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
        var finalString: String = ""
        return try await withCheckedThrowingContinuation { continuation in
            request.responseStreamString { stream in
                switch stream.event {
                case let .stream(result):
                    switch result {
                    case let .success(data):
                        let string = data
                        finalString += string
                        // print("🐶" + string + "🐱")
                        var message = stream2Message(form: string)
                        // print("MESSAGE = " + message)
                        if string.prefix(4) == "data" {
                            // 处理得到的消息内容
                            // DispatchQueue.main.async {
                                generatedText += message
                                user.chats[user.chats.count - 1].answers = generatedText
                            //}
                        } else {
                            var error_message = findContent(form: string, of: "\"message\": \"", endBefore: "\",\n")
                            var error_type = findContent(form: string, of: "\"type\": \"", endBefore: "\",\n")
                            error_message = error_message.count > 0 ? error_message : "Oops, something went wrong!"
                            
                            DispatchQueue.main.async {
                                generatedText = error_message
                                user.chats[user.chats.count - 1].answers = generatedText
                                toastTitle = error_message
                                toastSubtitle = error_type
                                settings.isShowErrorToast = true
                            }
                        }
                        //continuation.resume(returning: data)
                    case let .failure(error):
                        print(error)
                        continuation.resume(throwing: AFError.responseSerializationFailed(reason: .inputFileNil))
                    }
                case .complete(_):
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

func stream2Message(form rawStr: String) -> String {
    var rawStrArr = rawStr.components(separatedBy: "data")
    var res = ""
    for subRawStr in rawStrArr {
        var subData = findContent(form: subRawStr, of: "\"content\":\"", endBefore: "\"},\"index\"")
        if subData.contains("\\\"") {
            subData = subData.replacingOccurrences(of: "\\\"", with: #"""#)
        }
        if subData.contains("\\n") {
            subData = subData.replacingOccurrences(of: "\\n", with: "  \n")
        }
        res += subData
    }
    return res
}

func findContent(form rawStr: String, of content: String, endBefore endStr: String) -> String {
    var res: String = ""
    let subStr: String = content
    var position: Int = findSubstr(from: rawStr, of: subStr)
    res = String(rawStr.dropFirst(position + content.count))
    if res.count == 0 {
        return res
    }
    position = findSubstr(from: res, of: endStr)
    res = String(res.prefix(position))
    return res
}

func findSubstr(from rawStr: String, of subStr:String) -> Int {
    var position: Int = 0
    if let range = rawStr.range(of: subStr) {
        position = rawStr.distance(from: rawStr.startIndex, to: range.lowerBound)
    } else {
        position = rawStr.count
        //print("SubStr \"\(subStr)\" not found")
    }
    return position
}

func trimStr(_ rawStr: String) -> String {
    var checkStr: [Character] = ["c", "c"]
    var index = 0
    for c in rawStr {
        checkStr.remove(at: 0)
        checkStr.append(c)
        index += 1
        if checkStr[0] == "\n" && checkStr[1] == "\n" {
            break
        }
    }
    if index == rawStr.count {
        return rawStr
    } else {
        return String(rawStr.dropFirst(index))
    }
}

struct MyParameters: Codable {
    let model: String
    let messages: [[String:String]]
    let max_tokens: Int
    let user: String
    let stream: Bool
    
    init(model: String, messages: [[String:String]], max_tokens: Int, user: String, stream: Bool) {
        self.model = model
        self.messages = messages
        self.max_tokens = max_tokens
        self.user = user
        self.stream = stream
    }
}

//
//  GPT.swift
//  PersonalGPT
//
//  Created by Vikill Blacks on 2023/3/3.
//

import SwiftUI
import Alamofire
import SwiftyJSON

extension ChatView {
    func generateText() {
        DispatchQueue.main.async {
            isLoading = true
        }
        let apiKey = "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"
        let url = "https://api.openai.com/v1/completions"
        
        let parameters: [String: Any] = [            "model": "text-davinci-003",            "prompt": promptText,            "max_tokens": 1000        ]
        
        let headers: HTTPHeaders = [            "Content-Type": "application/json",            "Authorization": "Bearer \(apiKey)"        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                isLoading = false
                print(response)
                if let value = response.value {
                    let json = JSON(value)
                    let choices = json["choices"].arrayValue
                    let text = choices.map { $0["text"].stringValue }.joined()
                    DispatchQueue.main.async {
                        generatedText = trimStr(text)
                        promptText_shown = promptText
                        promptText = ""
                    }
                }
            }
    }
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


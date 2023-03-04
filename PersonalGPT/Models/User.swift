//
//  User.swift
//  PersonalGPT
//
//  Created by Vikill Blacks on 2023/3/3.
//

import SwiftUI

class User: ObservableObject {
    var id = UUID()
    @Published var chats: [Chat] = []
    func messageArray() -> [[String: Any]] {
        var message_array: [[String: Any]] = []
        for chat in chats {
            message_array.append(chat.messsages)
        }
        return message_array
    }
    func answerArray() -> [String] {
        var answer_array: [String] = []
        for chat in chats {
            answer_array.append(chat.answers)
        }
        return answer_array
    }
}

struct Chat: Identifiable {
    var messsages: [String: Any]
    var answers: String
    var id =  UUID()
    init(messsages: [String : Any], answers: String) {
        self.messsages = messsages
        self.answers = answers
        self.id = UUID()
    }
}

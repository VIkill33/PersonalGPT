//
//  User.swift
//  PersonalGPT
//
//  Created by Vikill Blacks on 2023/3/3.
//

import SwiftUI

class User: ObservableObject {
    var id = UUID()
    @Published var messsages: [[String: Any]] = []
}

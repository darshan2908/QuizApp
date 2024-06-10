//
//  Quiz.swift
//  Darshan
//
//  Created by Darshan on 10/06/24.
//

import Foundation

struct Question: Codable {
    let id: String
    let question: String
    let ans1: String
    let ans2: String
    let ans3: String
    let ans4: String
    let ans5: String
    let correct: String
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case question
        case ans1
        case ans2
        case ans3
        case ans4
        case ans5
        case correct
        case status
    }
}

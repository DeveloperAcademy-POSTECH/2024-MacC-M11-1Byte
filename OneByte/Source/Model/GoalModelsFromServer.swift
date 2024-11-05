//
//  GoalModelFromServer.swift
//  OneByte
//
//  Created by 트루디 on 11/3/24.
//
import SwiftData
import SwiftUI


// MARK: - ServerMainGoal
struct ServerMainGoal: Codable {
    let id: Int
    let title: String
    let isAchieved: Bool
    let createdTime, modifiedTime: String
    let subGoals: [ServerSubGoal]

    enum CodingKeys: String, CodingKey {
        case id = "mainGoalId"
        case title, isAchieved, createdTime, modifiedTime, subGoals
    }
}

// MARK: - SubGoal
struct ServerSubGoal: Codable {
    let id: Int?
    let title: String
    let isAchieved: Bool
    let createdTime, modifiedTime: String
    let detailGoals: [ServerDetailGoal]
    let mainGoalID: Int?

    enum CodingKeys: String, CodingKey {
        case id, title, isAchieved, createdTime, modifiedTime, detailGoals
        case mainGoalID = "subGoalId"
    }
}

// MARK: - DetailGoal
struct ServerDetailGoal: Codable {
    let id: Int?
    let title: String
    let isAchieved: Bool
    let createdTime, modifiedTime: String
    let detailGoalID: Int?

    enum CodingKeys: String, CodingKey {
        case id, title, isAchieved, createdTime, modifiedTime
        case detailGoalID = "detailGoalId"
    }
}

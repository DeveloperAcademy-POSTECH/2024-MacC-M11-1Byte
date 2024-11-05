//
//  ObjectiveView.swift
//  OneByte
//
//  Created by 트루디 on 10/17/24.
//

//import SwiftUI
//
//struct MandalartView: View {
//
//    var body: some View {
//        let createService = ClientCreateService()
//        let updateService = ClientUpdateService(mainGoals: [], subGoals: [], detailGoals: [])
//        let viewModel = CUTestViewModel(createService: createService)
//        CUTestView(viewModel: viewModel) // 뷰에 뷰모델 전달
//    }
//}

import SwiftUI
import SwiftData

struct MandalartView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = CUTestViewModel(createService: ClientCreateService())
    
    @Query private var mainGoals: [MainGoal]
    
    @State var goalTitle: String = ""
    @State private var selectedGoal: MainGoal? // 수정할 메인골
    @State private var isEditing = false
    @State private var isDataSaved = false // 데이터 저장 후 이동 여부

    
    init(viewModel: CUTestViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            VStack{
                Button("Save Goals from JSON") {
                    let json = """
                {
                  "mainGoals": [
                    {
                      "id": 1,
                      "title": "Health Improvement",
                      "isAchieved": false,
                      "goalYear": 2024,
                      "createdTime": "2024-01-01T00:00:00Z",
                      "modifiedTime": "2024-01-02T00:00:00Z",
                      "subGoals": [
                        {
                          "id": 11,
                          "title": "몸관리",
                          "memo": "Maintain good body condition",
                          "isAchieved": false,
                          "createdTime": "2024-01-01T00:00:00Z",
                          "modifiedTime": "2024-01-02T00:00:00Z",
                          "detailGoals": [
                            {
                              "id": 111,
                              "title": "Stretch Daily",
                              "memo": "Stretching exercises every morning",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 112,
                              "title": "Run 3x a week",
                              "memo": "Running three times a week for stamina",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 113,
                              "title": "Daily Hydration",
                              "memo": "Drink at least 2 liters of water",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 114,
                              "title": "Balance Diet",
                              "memo": "Eat balanced meals each day",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 115,
                              "title": "Sleep 8 hours",
                              "memo": "Aim for 8 hours of sleep per night",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 116,
                              "title": "Weekly Yoga",
                              "memo": "Practice yoga once a week",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 117,
                              "title": "FSQ 90kg",
                              "memo": "Achieve 90kg on Front Squat",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 118,
                              "title": "Cardio Training",
                              "memo": "30 minutes cardio every day",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            }
                          ]
                        },
                        {
                          "id": 12,
                          "title": "영양제 먹기",
                          "memo": "Take daily supplements",
                          "isAchieved": false,
                          "createdTime": "2024-01-01T00:00:00Z",
                          "modifiedTime": "2024-01-02T00:00:00Z",
                          "detailGoals": [
                            {
                              "id": 121,
                              "title": "Vitamin C",
                              "memo": "Take Vitamin C supplement daily",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 122,
                              "title": "Vitamin D",
                              "memo": "Take Vitamin D supplement daily",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 123,
                              "title": "Magnesium",
                              "memo": "Take Magnesium supplement daily",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 124,
                              "title": "Omega-3",
                              "memo": "Take Omega-3 supplement daily",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 125,
                              "title": "Probiotics",
                              "memo": "Take Probiotics supplement daily",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 126,
                              "title": "Zinc",
                              "memo": "Take Zinc supplement daily",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 127,
                              "title": "Iron",
                              "memo": "Take Iron supplement daily",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 128,
                              "title": "Calcium",
                              "memo": "Take Calcium supplement daily",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            }
                          ]
                        },
                        {
                          "id": 13,
                          "title": "FSQ 90kg",
                          "memo": "Achieve Front Squat goal",
                          "isAchieved": false,
                          "createdTime": "2024-01-01T00:00:00Z",
                          "modifiedTime": "2024-01-02T00:00:00Z",
                          "detailGoals": [
                            {
                              "id": 131,
                              "title": "Squat Practice",
                              "memo": "Practice squats daily",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 132,
                              "title": "Strength Training",
                              "memo": "Increase strength with weight training",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 133,
                              "title": "Increase Weight",
                              "memo": "Gradually increase squat weight",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 134,
                              "title": "Leg Press",
                              "memo": "Add leg press to routine",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 135,
                              "title": "Leg Press2",
                              "memo": "Add leg press to routine",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 136,
                              "title": "Leg Press3",
                              "memo": "Add leg press to routine",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 137,
                              "title": "Leg Press4",
                              "memo": "Add leg press to routine",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 138,
                              "title": "Leg Press5",
                              "memo": "Add leg press to routine",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                          ]
                        },
                        {
                          "id": 14,
                          "title": "유연성",
                          "memo": "Improve overall flexibility",
                          "isAchieved": false,
                          "createdTime": "2024-01-01T00:00:00Z",
                          "modifiedTime": "2024-01-02T00:00:00Z",
                          "detailGoals": [
                            {
                              "id": 141,
                              "title": "Daily Stretching",
                              "memo": "Stretch all major muscle groups daily",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 142,
                              "title": "Yoga Classes",
                              "memo": "Attend yoga classes twice a week",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 143,
                              "title": "Dynamic Stretching",
                              "memo": "Incorporate dynamic stretching in warm-ups",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 144,
                              "title": "Static Stretching",
                              "memo": "Focus on static stretching post-workout",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 145,
                              "title": "Pilates",
                              "memo": "Incorporate Pilates into weekly routine",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 146,
                              "title": "Hip Flexor Stretch",
                              "memo": "Focus on hip flexor stretches",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 147,
                              "title": "Hamstring Stretch",
                              "memo": "Include hamstring stretches in routine",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 148,
                              "title": "Shoulder Stretch",
                              "memo": "Perform shoulder stretches regularly",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            }
                          ]
                        },
                        {
                          "id": 15,
                          "title": "몸 만들기",
                          "memo": "Build muscle mass and definition",
                          "isAchieved": false,
                          "createdTime": "2024-01-01T00:00:00Z",
                          "modifiedTime": "2024-01-02T00:00:00Z",
                          "detailGoals": [
                            {
                              "id": 151,
                              "title": "Strength Training",
                              "memo": "Complete strength training sessions 4x a week",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 152,
                              "title": "Protein Intake",
                              "memo": "Increase daily protein intake",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 153,
                              "title": "Track Progress",
                              "memo": "Log workouts and progress weekly",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 154,
                              "title": "Weekly Measurements",
                              "memo": "Measure body composition weekly",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 155,
                              "title": "Rest Days",
                              "memo": "Include rest days in workout schedule",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 156,
                              "title": "Hydration",
                              "memo": "Maintain hydration during workouts",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 157,
                              "title": "Muscle Recovery",
                              "memo": "Incorporate recovery techniques after workouts",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 158,
                              "title": "Flexibility Training",
                              "memo": "Add flexibility training to routine",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            }
                          ]
                        },
                        {
                          "id": 16,
                          "title": "RSQ 130kg",
                          "memo": "Achieve 130kg on Back Squat",
                          "isAchieved": false,
                          "createdTime": "2024-01-01T00:00:00Z",
                          "modifiedTime": "2024-01-02T00:00:00Z",
                          "detailGoals": [
                            {
                              "id": 161,
                              "title": "Back Squat Practice",
                              "memo": "Practice Back Squats every week",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 162,
                              "title": "Strength Training",
                              "memo": "Follow strength training program",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 163,
                              "title": "Weight Increase",
                              "memo": "Increase squat weight gradually",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 164,
                              "title": "Leg Day",
                              "memo": "Schedule leg day workouts weekly",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 165,
                              "title": "Core Strength",
                              "memo": "Work on core strength for stability",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 166,
                              "title": "Proper Form",
                              "memo": "Focus on maintaining proper squat form",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 167,
                              "title": "Nutrition Support",
                              "memo": "Ensure nutrition supports muscle growth",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 168,
                              "title": "Recovery Techniques",
                              "memo": "Use recovery techniques post-workout",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            }
                          ]
                        },
                        {
                          "id": 17,
                          "title": "스테미너",
                          "memo": "Increase stamina and endurance",
                          "isAchieved": false,
                          "createdTime": "2024-01-01T00:00:00Z",
                          "modifiedTime": "2024-01-02T00:00:00Z",
                          "detailGoals": [
                            {
                              "id": 171,
                              "title": "Cardio Workouts",
                              "memo": "Incorporate cardio workouts 3x a week",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 172,
                              "title": "Interval Training",
                              "memo": "Add interval training to routine",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 173,
                              "title": "Long Runs",
                              "memo": "Increase distance of long runs weekly",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 174,
                              "title": "Hydration Plan",
                              "memo": "Create a hydration plan for workouts",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 175,
                              "title": "Cross Training",
                              "memo": "Incorporate cross training for variety",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 176,
                              "title": "Rest and Recovery",
                              "memo": "Prioritize rest and recovery days",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 177,
                              "title": "Sleep Schedule",
                              "memo": "Maintain a consistent sleep schedule",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 178,
                              "title": "Nutrition for Endurance",
                              "memo": "Focus on nutrition that supports endurance",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            }
                          ]
                        },
                        {
                          "id": 18,
                          "title": "가동력",
                          "memo": "Improve mobility and range of motion",
                          "isAchieved": false,
                          "createdTime": "2024-01-01T00:00:00Z",
                          "modifiedTime": "2024-01-02T00:00:00Z",
                          "detailGoals": [
                            {
                              "id": 181,
                              "title": "Mobility Drills",
                              "memo": "Incorporate mobility drills daily",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 182,
                              "title": "Foam Rolling",
                              "memo": "Use foam roller for recovery",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 183,
                              "title": "Dynamic Warm-ups",
                              "memo": "Perform dynamic warm-ups before workouts",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 184,
                              "title": "Joint Mobility",
                              "memo": "Focus on joint mobility exercises",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 185,
                              "title": "Yoga for Mobility",
                              "memo": "Incorporate yoga into routine",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 186,
                              "title": "Stretching Routine",
                              "memo": "Develop a comprehensive stretching routine",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 187,
                              "title": "Post-Workout Stretching",
                              "memo": "Focus on stretching after workouts",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            },
                            {
                              "id": 188,
                              "title": "Mobility Assessment",
                              "memo": "Regularly assess mobility progress",
                              "isAchieved": false,
                              "createdTime": "2024-01-01T00:00:00Z",
                              "modifiedTime": "2024-01-02T00:00:00Z"
                            }
                          ]
                        }
                      ]
                    }
                  ]
                }
"""
                    
                    viewModel.saveGoalsFromJSON(jsonString: json, modelContext: modelContext)
                    isDataSaved = true
                }
                
            }
            .navigationDestination(isPresented: $isDataSaved) {
                            GoalListView() // 데이터가 저장된 경우 GoalListView로 이동
                        }
        }
    }
}

struct GoalListView: View {
    @Query private var mainGoals: [MainGoal] // 메인골 가져오기

    var body: some View {
        List(mainGoals) { goal in
            VStack(alignment: .leading) {
                Text(goal.title)
                    .font(.headline)
                Text("Achieved: \(goal.isAchieved ? "Yes" : "No")")
                Text("Year: \(goal.goalYear)")

                // 서브골 표시
                ForEach(goal.subGoals) { subGoal in
                    VStack(alignment: .leading) {
                        Text(" - SubGoal: \(subGoal.title)")
                            .bold()
                            .font(.title)
                        
                        // 디테일골 표시
                        ForEach(subGoal.detailGoals) { detailGoal in
                            Text("   - DetailGoal: \(detailGoal.title)")
                        }
                    }
                }
            }
        }
        .navigationTitle("Goals")
    }
}

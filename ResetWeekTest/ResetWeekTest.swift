//
//  ResetWeekTest.swift
//  ResetWeekTest
//
//  Created by 이상도 on 11/23/24.
//

import XCTest
@testable import OneByte

final class ResetWeekTest: XCTestCase {

    func testWeeklyReset() {
            // Given
            UserDefaults.standard.removeObject(forKey: "lastResetDate")
            let testGoals = createTestGoals()
            
            // Before reset 상태 확인
            XCTAssertEqual(testGoals[0].subGoals[0].detailGoals[0].achieveCount, 3)
            XCTAssertTrue(testGoals[0].subGoals[0].detailGoals[0].achieveMon)
            
            // When
            WeeklyResetManager.resetGoals(goals: testGoals)
            
            // Then
            XCTAssertEqual(testGoals[0].subGoals[0].detailGoals[0].achieveCount, 0)
            XCTAssertFalse(testGoals[0].subGoals[0].detailGoals[0].achieveMon)
        }
        
        private func createTestGoals() -> [MainGoal] {
            let detailGoals = [
                DetailGoal(id: 1, title: "Test Goal 1", memo: "", achieveCount: 3, achieveGoal: 5, alertMon: true, alertTue: true, alertWed: true, alertThu: false, alertFri: false, alertSat: false, alertSun: false, isRemind: false, remindTime: nil, achieveMon: true, achieveTue: true, achieveWed: true, achieveThu: false, achieveFri: false, achieveSat: false, achieveSun: false)
            ]
            let subGoals = [
                SubGoal(id: 1, title: "Test SubGoal 1", leafState: 0, detailGoals: detailGoals)
            ]
            return [MainGoal(id: 1, title: "Test MainGoal 1", cloverState: 0, subGoals: subGoals)]
        }

}

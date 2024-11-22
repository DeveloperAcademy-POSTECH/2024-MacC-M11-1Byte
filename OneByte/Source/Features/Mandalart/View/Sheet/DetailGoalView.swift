//
//  DetailGoalSheetView.swift
//  OneByte
//
//  Created by 트루디 on 11/12/24.
//

import SwiftUI

struct DetailGoalView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var context
    private let viewModel = MandalartViewModel(
        createService: CreateService(),
        updateService: UpdateService(mainGoals: [], subGoals: [], detailGoals: []),
        deleteService: DeleteService(mainGoals: [], subGoals: [], detailGoals: [])
    )
    @State private var isEditing: Bool = false
    @Binding var detailGoal: DetailGoal?
    @State private var newTitle: String = ""
    @State private var newMemo: String = ""
    @State private var achieveCount = 0
    @State private var achieveGoal = 0
    @Binding var tabBarVisible: Bool
    
    // 알람 요일
    @State private var alertMon: Bool = false
    @State private var alertTue: Bool = false
    @State private var alertWed: Bool = false
    @State private var alertThu: Bool = false
    @State private var alertFri: Bool = false
    @State private var alertSat: Bool = false
    @State private var alertSun: Bool = false
    @State private var isRemind: Bool = false
    @State private var remindTime: Date? = nil
    @State private var achieveMon: Bool = false
    @State private var achieveTue: Bool = false
    @State private var achieveWed: Bool = false
    @State private var achieveThu: Bool = false
    @State private var achieveFri: Bool = false
    @State private var achieveSat: Bool = false
    @State private var achieveSun: Bool = false
    
    @State private var showAlert = false
    
    private let titleLimit = 20 // 제목 글자수 제한
    private let memoLimit = 100 // 메모 글자수 제한
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28/852 * UIScreen.main.bounds.height) {
                Spacer()
                if isEditing {
                    // 타이틀 입력란
                    detailGaolTitle()
                    
                    // 메모 입력란
                    DetailGoalMemo()
                    
                    // 요일 선택
                    selectDays()
                    
                    // 리마인드 알림
                    remind()
                    
                    // 삭제 버튼
                    deleteButton()
                } else {
                    // 저장되었을 때 보여주는 화면
                    saved()
                }
                Spacer()
            }
        }
        
        .navigationBarBackButtonHidden()
        .backButtonToolbar { dismiss() }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                Button(action: {
                    isEditing.toggle()
                    if !isEditing, let detailGoal = detailGoal{
                        // 요일 갯수 계산
                        achieveGoal = [alertMon, alertTue, alertWed, alertThu, alertFri, alertSat, alertSun]
                            .filter { $0 }
                            .count
                        
                        // 알림 시간 기본값 설정
                        if isRemind, remindTime == nil {
                            remindTime = Date() // 현재 시간으로 설정
                        }
                        
                        viewModel.updateDetailGoal(
                            detailGoal: detailGoal,
                            newTitle: newTitle,
                            newMemo: newMemo,
                            achieveCount: achieveCount,
                            achieveGoal: achieveGoal,
                            alertMon: alertMon,
                            alertTue: alertTue,
                            alertWed: alertWed,
                            alertThu: alertThu,
                            alertFri: alertFri,
                            alertSat: alertSat,
                            alertSun: alertSun,
                            isRemind: isRemind,
                            remindTime: remindTime,
                            achieveMon: achieveMon,
                            achieveTue: achieveTue,
                            achieveWed: achieveWed,
                            achieveThu: achieveThu,
                            achieveFri: achieveFri,
                            achieveSat: achieveSat,
                            achieveSun: achieveSun
                        )
                        // 알림 설정 호출
                        if isRemind {
                            let selectedDays = getSelectedDays()
                            if let remindTime = remindTime {
                                let identifier = "\(detailGoal.title)-\(getSelectedDays().joined(separator: ","))"
                                let content = UNMutableNotificationContent()
                                content.title = "알림 제목"
                                content.body = "알림 내용"
                                content.sound = .default
                                
                                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false)
                                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                                
                                scheduleNotification(for: newTitle, on: selectedDays, at: remindTime)
                            }
                        } else {
                            let identifier = "\(newTitle)-\(getSelectedDays().joined(separator: ","))"
                            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
                        }
                        // 디버깅: 알림 확인
                        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                            for request in requests {
                                print("Pending notification: \(request.identifier)")
                            }
                        }
                    }
                }, label: {
                    Text(isEditing ? "저장" : "수정")
                        .foregroundStyle(Color.my538F53)
                })
            })
        }
        .padding(.horizontal, 20)
        .onAppear {
            tabBarVisible = false
            if let detailGoal = detailGoal {
                newTitle = detailGoal.title
                newMemo = detailGoal.memo
                achieveCount = detailGoal.achieveCount
                achieveGoal = detailGoal.achieveGoal
                alertMon = detailGoal.alertMon
                alertTue = detailGoal.alertTue
                alertWed = detailGoal.alertWed
                alertThu = detailGoal.alertThu
                alertFri = detailGoal.alertFri
                alertSat = detailGoal.alertSat
                alertSun = detailGoal.alertSun
                isRemind = detailGoal.isRemind
                remindTime = detailGoal.remindTime
                achieveMon = detailGoal.achieveMon
                achieveTue = detailGoal.achieveTue
                achieveWed = detailGoal.achieveWed
                achieveThu = detailGoal.achieveThu
                achieveFri = detailGoal.achieveFri
                achieveSat = detailGoal.achieveSat
                achieveSun = detailGoal.achieveSun
            } else { print("실패")}
            
        }
        .background(Color.myFFFAF4)
    }
    
    // 선택된 요일을 필터링하여 배열로 반환하는 함수
    func getSelectedDays() -> [String] {
        var selected: [String] = []
        if alertSun { selected.append("일") }
        if alertMon { selected.append("월") }
        if alertTue { selected.append("화") }
        if alertWed { selected.append("수") }
        if alertThu { selected.append("목") }
        if alertFri { selected.append("금") }
        if alertSat { selected.append("토") }
        return selected
    }
}

extension DetailGoalView {
    @ViewBuilder
    func detailGaolTitle() -> some View {
        Text("루틴 이름")
            .font(.Pretendard.SemiBold.size16)
            .padding(.leading, 4)
            .foregroundStyle(Color.my675542)
        
        // 할 일 제목 입력란
        ZStack {
            TextField("루틴을 입력해주세요.", text: $newTitle)
                .padding()
                .background(.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.myF0E8DF, lineWidth: 1)
                )
                .onChange(of: newTitle) { oldValue, newValue in
                    if newValue.count > titleLimit {
                        newTitle = String(newValue.prefix(titleLimit))
                    }
                }
            
            HStack {
                Spacer()
                if newTitle != "" {
                    Button(action: {
                        newTitle = ""
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 23, height: 23)
                            .foregroundStyle(Color.myB9B9B9)
                    })
                    .padding(.trailing)
                }
            }
        }
        .padding(.top, -20)
        
        if isEditing {
            // 글자수 부분
            HStack(spacing: 0) {
                Spacer()
                Text("\(newTitle.count)")
                    .font(.Pretendard.Medium.size12)
                    .foregroundStyle(Color.my6C6C6C)
                Text("/\(titleLimit)")
                    .font(.Pretendard.Medium.size12)
                    .foregroundStyle(Color.my6C6C6C.opacity(0.5))
            }
            .padding(.trailing, 10)
            .padding(.top, -20)
        }
    }
    
    @ViewBuilder
    func DetailGoalMemo() -> some  View {
        Text("메모")
            .font(.Pretendard.SemiBold.size16)
            .padding(.leading, 4)
            .padding(.top, -10)
            .foregroundStyle(Color.my675542)
        
        ZStack {
            VStack(alignment: .leading) {
                TextField("루틴에 대한 메모를 자유롭게 작성해보세요.", text: $newMemo, axis: .vertical)
                    .scrollContentBackground(.hidden)
                    .padding()
                    .onChange(of: newMemo) { oldValue, newValue in
                        if newValue.count > memoLimit {
                            newMemo = String(newValue.prefix(memoLimit))
                        }
                    }
                Spacer()
            }
            // 글자수 부분
            VStack(spacing: 0){
                Spacer()
                HStack(spacing: 0){
                    Spacer()
                    Text("\(newMemo.count)")
                        .font(.Pretendard.Medium.size12)
                        .foregroundStyle(Color.my6C6C6C)
                    Text("/\(memoLimit)")
                        .font(.Pretendard.Medium.size12)
                        .foregroundStyle(Color.my6C6C6C.opacity(0.5))
                }
                .padding([.trailing, .bottom], 10)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 133/852 * UIScreen.main.bounds.height)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.myF0E8DF, lineWidth: 1)
        )
        .padding(.top, -20)
    }
    
    @ViewBuilder
    func selectDays() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("요일 선택")
                .font(.Pretendard.Medium.size14)
                .foregroundStyle(Color.my675542)
            
            Text("루틴을 실행할 요일을 선택해주세요.")
                .font(.Pretendard.Medium.size14)
                .foregroundStyle(Color.myB4A99D)
        }
        .padding(.leading, 4)
        //실제 요일 선택
        VStack(alignment: .leading, spacing: 16){
            Text("반복 요일")
                .font(.Pretendard.SemiBold.size16)
            HStack(spacing: 12) {
                DayButton(title: "일", isSelected: $alertSun)
                DayButton(title: "월", isSelected: $alertMon)
                DayButton(title: "화", isSelected: $alertTue)
                DayButton(title: "수", isSelected: $alertWed)
                DayButton(title: "목", isSelected: $alertThu)
                DayButton(title: "금", isSelected: $alertFri)
                DayButton(title: "토", isSelected: $alertSat)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 105/852 * UIScreen.main.bounds.height)
        .background(.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.myF0E8DF, lineWidth: 1)
        )
        .padding(.top, -18)
    }
    
    @ViewBuilder
    func remind() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("리마인드 알림")
                .font(.Pretendard.Medium.size14)
            
            Text("루틴을 시작할 때 받을 알림을 설정해주세요.")
                .foregroundStyle(Color.myB4A99D)
        }
        .padding(.leading, 4)
        Section {
            VStack(spacing: 0){
                // 알림 설정 토글
                HStack() {
                    Text("알림 설정")
                        .font(.Pretendard.SemiBold.size16)
                        .foregroundStyle(.black)
                    Spacer()
                    
                    Toggle("", isOn: $isRemind)
                        .toggleStyle(SwitchToggleStyle(tint: Color.my538F53)) // 초록색 토글
                }
                
                if isRemind {
                    Divider()
                        .foregroundStyle(Color.myF0E8DF)
                        .frame(height: 1)
                        .padding(.vertical, 8)
                    
                    // 알림 시간 설정
                    HStack {
                        Text("알림 시간")
                            .font(.Pretendard.SemiBold.size16)
                            .foregroundStyle(.black)
                        Spacer()
                        
                        // 알림 시간을 선택할 수 있는 DatePicker
                        DatePicker(
                            "",
                            selection: Binding(
                                get: { remindTime ?? Date() },
                                set: { remindTime = $0 }
                            ),
                            displayedComponents: .hourAndMinute
                        )
                        .labelsHidden() // 라벨 숨기기
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
        .background(.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.myF0E8DF, lineWidth: 1)
        )
        .padding(.top, -18)
    }
    
    @ViewBuilder
    func saved() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 30) {
                Text("루틴 이름")
                    .foregroundStyle(Color.my675542)
                    .font(.Pretendard.SemiBold.size16)
                    .frame(width: 60)
                Text(newTitle)
                    .font(.Pretendard.Medium.size16)
                Spacer()
            }
            Divider()
                .padding(.horizontal, -16)
            HStack(spacing: 30) {
                Text("메모")
                    .foregroundStyle(Color.my675542)
                    .font(.Pretendard.SemiBold.size16)
                    .frame(width: 60, alignment: .leading)
                Text(newMemo)
                    .font(.Pretendard.Medium.size16)
                Spacer()
            }
            Divider()
                .padding(.horizontal, -16)
            HStack(spacing: 30) {
                Text("반복 요일")
                    .foregroundStyle(Color.my675542)
                    .font(.Pretendard.SemiBold.size16)
                    .frame(width: 60)
                // 선택된 요일만 표시
                let selectedDays = getSelectedDays()
                Text(selectedDays.joined(separator: ", "))
                    .font(.Pretendard.Medium.size16)
                Spacer()
            }
            Divider()
                .padding(.horizontal, -16)
            HStack(spacing: 30) {
                Text("알람 시간")
                    .foregroundStyle(Color.my675542)
                    .font(.Pretendard.SemiBold.size16)
                    .frame(width: 60)
                if isRemind {
                    var formattedRemindTime: String {
                        guard let remindTime = remindTime else {
                            return "미설정"
                        }
                        
                        let formatter = DateFormatter()
                        formatter.dateFormat = "a h시 mm분" // 오전/오후 + 시:분 형식
                        formatter.locale = Locale(identifier: "ko_KR") // 한국어로 설정
                        return formatter.string(from: remindTime)
                    }
                    Text(formattedRemindTime)
                        .font(.Pretendard.Medium.size16)
                } else {
                    Text("미설정")
                        .font(.Pretendard.Medium.size16)
                        .foregroundStyle(Color.gray)
                }
                Spacer()
            }
        }
        .padding()
        .background(.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.myF0E8DF, lineWidth: 1)
        )
    }
    
    @ViewBuilder
    func deleteButton() -> some View {
        Button(action: {
            showAlert = true
        }, label: {
            HStack(spacing: 8) {
                Image(systemName: "trash")
                    .font(.system(size: 16))
                    .foregroundStyle(.red)
                Text("삭제하기")
                    .font(.Pretendard.Medium.size16)
                    .foregroundStyle(.red)
            }
            .padding(.vertical, 14.5)
            .frame(maxWidth: .infinity)
            .background(Color.myF0E8DF)
            .cornerRadius(12)
        })
        .alert("루틴을 삭제하시겠습니까?", isPresented: $showAlert) {
            Button("삭제하기", role: .destructive) {
                if let detailGoal = detailGoal {
                    viewModel.deleteDetailGoal(
                        detailGoal: detailGoal, newTitle: "", newMemo: "", achieveCount: 0, achieveGoal: 0, alertMon: false, alertTue: false, alertWed: false, alertThu: false, alertFri: false, alertSat: false, alertSun: false, isRemind: false, remindTime: nil, achieveMon: false, achieveTue: false, achieveWed: false, achieveThu: false, achieveFri: false, achieveSat: false, achieveSun: false
                    )
                }
                isEditing = false
                // 버튼 누르면 SubGoalDetailGridView로 pop되게 하기
                dismiss()
            }
            Button("계속하기", role: .cancel) {}
        } message: {
            Text("삭제한 루틴은 복구할 수 없어요.")
        }
    }
}

// 요일 버튼 컴포넌트
struct DayButton: View {
    let title: String
    @Binding var isSelected: Bool
    
    var body: some View {
        Button(action: {
            isSelected.toggle()
        }) {
            Text(title)
                .font(.Pretendard.Medium.size17)
                .foregroundStyle(.white)
                .frame(width: 36, height: 36)
                .background(isSelected ? Color.my538F53 : Color.myCFCFCF)
                .clipShape(Circle())
        }
        .buttonStyle(PlainButtonStyle()) // 기본 효과 제거
    }
}

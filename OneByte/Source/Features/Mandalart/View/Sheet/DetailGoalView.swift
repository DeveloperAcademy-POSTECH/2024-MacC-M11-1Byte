//
//  DetailGoalSheetView.swift
//  OneByte
//
//  Created by 트루디 on 11/12/24.
//

import SwiftUI
import SwiftData

struct DetailGoalView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var mainGoals: [MainGoal]
    @Query private var clovers: [Clover]
    @StateObject private var viewModel = MandalartViewModel(
        createService: CreateService(),
        updateService: UpdateService(mainGoals: [], subGoals: [], detailGoals: []),
        deleteService: DeleteService(mainGoals: [], subGoals: [], detailGoals: []),
        firebaseService: FirebaseService()
    )

    @Binding var detailGoal: DetailGoal?

    @State private var newTitle = ""
    @State private var newMemo = ""
    @State private var achieveCount = 0
    @State private var achieveGoal = 0
    @State private var alertMon = false
    @State private var alertTue = false
    @State private var alertWed = false
    @State private var alertThu = false
    @State private var alertFri = false
    @State private var alertSat = false
    @State private var alertSun = false
    @State private var isRemind = false
    @State private var remindTime: Date? = nil
    @State private var achieveMon = false
    @State private var achieveTue = false
    @State private var achieveWed = false
    @State private var achieveThu = false
    @State private var achieveFri = false
    @State private var achieveSat = false
    @State private var achieveSun = false
    @State private var isMorning = true
    @State private var isAfternoon = false
    @State private var isEvening = false
    @State private var isNight = false
    @State private var isFree = false
    @State private var repeatType: RoutineRepeatType = .weekday
    @State private var scheduledDayOfMonth = 1

    @State private var showDeleteAlert = false
    @State private var showBackAlert = false
    @State private var showPermissionAlert = false
    @State private var isModified = false
    @State private var isQuestionMarkClicked = false
    @State private var selectedTime = "아침"
    @State private var titleError: String?
    @State private var repeatError: String?

    @FocusState private var isFocused: Bool

    private let timeOptions = ["아침", "점심", "저녁", "자기전", "자율"]
    private let titleLimit = 20
    private let memoLimit = 100

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                titleSection()
                memoSection()
                repeatSection()
                timeSection()
                remindSection()

                if detailGoal?.title != "" {
                    deleteButton()
                        .padding(.bottom, 53/852 * UIScreen.main.bounds.height)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 28)
        }
        .scrollIndicators(.hidden)
        .background(Color.myFFFAF4)
        .contentShape(Rectangle())
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("루틴 추가하기")
        .navigationBarTitleDisplayMode(.inline)
        .backButtonToolbar {
            if isModified {
                showBackAlert = true
            } else {
                dismiss()
            }
        }
        .alert("작업을 중단하시겠습니까?", isPresented: $showBackAlert) {
            Button("나가기", role: .destructive) { dismiss() }
            Button("계속하기", role: .cancel) {}
        } message: {
            Text("작성한 내용이 저장되지 않아요.")
        }
        .alert("알림 설정이 꺼져있어요", isPresented: $showPermissionAlert) {
            Button("취소", role: .cancel) {
                isRemind = false
            }
            Button("이동하기") {
                isRemind = false
                openSystemNotificationSettings()
            }
        } message: {
            Text("하고만다는 서버 없이 로컬 알림으로 루틴을 알려드려요.\n기기 설정에서 알림을 허용해주세요.")
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("저장") {
                    saveRoutine()
                }
                .foregroundStyle(isModified ? .my538F53 : .myA9C5A3)
                .fontWeight(isModified ? .bold : .regular)
                .disabled(!isModified)
            }
        }
        .onAppear {
            loadDetailGoal()
        }
    }

    private func loadDetailGoal() {
        guard let detailGoal else { return }
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
        isMorning = detailGoal.isMorning
        isAfternoon = detailGoal.isAfternoon
        isEvening = detailGoal.isEvening
        isNight = detailGoal.isNight
        isFree = detailGoal.isFree
        repeatType = detailGoal.repeatType
        scheduledDayOfMonth = detailGoal.scheduledDayOfMonth ?? 1

        if detailGoal.isAfternoon {
            selectedTime = "점심"
        } else if detailGoal.isEvening {
            selectedTime = "저녁"
        } else if detailGoal.isNight {
            selectedTime = "자기전"
        } else if detailGoal.isFree {
            selectedTime = "자율"
        } else {
            selectedTime = "아침"
        }
    }

    private func markModified() {
        isModified = true
    }

    private func validateInputs() -> Bool {
        titleError = newTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "루틴 이름을 입력해주세요." : nil

        switch repeatType {
        case .weekday:
            repeatError = hasSelectedWeekdays ? nil : "반복할 요일을 1개 이상 선택해주세요."
        case .monthlyDate:
            repeatError = (1...7).contains(scheduledDayOfMonth) ? nil : "주간 수행 횟수를 선택해주세요."
        case .flexible:
            repeatError = nil
        }

        return titleError == nil && repeatError == nil
    }

    private func saveRoutine() {
        UIApplication.shared.endEditing()
        guard validateInputs(), let detailGoal else { return }

        let cleanedTitle = newTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        let effectiveReminder = isRemind
        let selectedDays = repeatType == .weekday ? getSelectedDays() : []
        let notSelectedDays = getNotSelectedDays()
        achieveGoal = repeatType == .weekday ? selectedDays.count : scheduledDayOfMonth
        achieveCount = RoutineProgressLogic.achievementCount(
            storedCount: achieveCount,
            weeklyStates: weeklyAchievementStates
        )

        if effectiveReminder, remindTime == nil {
            remindTime = Date()
        }

        viewModel.updateDetailGoal(
            detailGoal: detailGoal,
            newTitle: cleanedTitle,
            newMemo: newMemo,
            achieveCount: achieveCount,
            achieveGoal: achieveGoal,
            alertMon: repeatType == .weekday ? alertMon : false,
            alertTue: repeatType == .weekday ? alertTue : false,
            alertWed: repeatType == .weekday ? alertWed : false,
            alertThu: repeatType == .weekday ? alertThu : false,
            alertFri: repeatType == .weekday ? alertFri : false,
            alertSat: repeatType == .weekday ? alertSat : false,
            alertSun: repeatType == .weekday ? alertSun : false,
            isRemind: effectiveReminder,
            remindTime: effectiveReminder ? remindTime : nil,
            achieveMon: achieveMon,
            achieveTue: achieveTue,
            achieveWed: achieveWed,
            achieveThu: achieveThu,
            achieveFri: achieveFri,
            achieveSat: achieveSat,
            achieveSun: achieveSun,
            isMorning: selectedTime == "아침",
            isAfternoon: selectedTime == "점심",
            isEvening: selectedTime == "저녁",
            isNight: selectedTime == "자기전",
            isFree: selectedTime == "자율",
            repeatTypeRaw: repeatType.rawValue,
            scheduledDayOfMonth: repeatType == .monthlyDate ? scheduledDayOfMonth : nil
        )

        if effectiveReminder {
            viewModel.createNotification(detailGoal: detailGoal, newTitle: cleanedTitle, selectedDays: selectedDays)
            viewModel.deleteNotification(detailGoal: detailGoal, days: notSelectedDays)
        } else {
            viewModel.deleteNotification(detailGoal: detailGoal, days: ["월", "화", "수", "목", "금", "토", "일"])
        }

        TodayRoutineViewModel().refreshNotificationSchedules(mainGoals: mainGoals)

        if let mainGoal = mainGoal(containing: detailGoal) {
            let routineViewModel = TodayRoutineViewModel()
            routineViewModel.updateCloverState(for: mainGoal)
            routineViewModel.calculateCurrentWeekAndMonthWeek(
                mainGoal: mainGoal,
                clovers: clovers,
                context: modelContext
            )
            routineViewModel.syncWidgetSnapshot(mainGoals: mainGoals)
        }

        isModified = false
        dismiss()
    }

    private var hasSelectedWeekdays: Bool {
        alertMon || alertTue || alertWed || alertThu || alertFri || alertSat || alertSun
    }

    private var weeklyAchievementStates: [Bool] {
        [achieveMon, achieveTue, achieveWed, achieveThu, achieveFri, achieveSat, achieveSun]
    }

    private func mainGoal(containing detailGoal: DetailGoal) -> MainGoal? {
        mainGoals.first { mainGoal in
            mainGoal.subGoals.contains { subGoal in
                subGoal.detailGoals.contains { $0 === detailGoal }
            }
        }
    }

    private func getSelectedDays() -> [String] {
        var selected: [String] = []
        if alertMon { selected.append("월") }
        if alertTue { selected.append("화") }
        if alertWed { selected.append("수") }
        if alertThu { selected.append("목") }
        if alertFri { selected.append("금") }
        if alertSat { selected.append("토") }
        if alertSun { selected.append("일") }
        return selected
    }

    private func getNotSelectedDays() -> [String] {
        ["월", "화", "수", "목", "금", "토", "일"].filter { !getSelectedDays().contains($0) }
    }
}

private extension DetailGoalView {
    @ViewBuilder
    func titleSection() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("루틴 이름")
                .font(.setPretendard(weight: .semiBold, size: 16))
                .padding(.leading, 4)
                .foregroundStyle(Color.my675542)

            ZStack {
                TextField("루틴을 입력해주세요.", text: $newTitle)
                    .padding()
                    .background(.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(titleError == nil ? Color.myF0E8DF : .red.opacity(0.7), lineWidth: 1)
                    )
                    .onChange(of: newTitle) { _, newValue in
                        viewModel.detailGoalTitleText = newValue
                        if newValue.count > titleLimit {
                            newTitle = String(newValue.prefix(titleLimit))
                        }
                        titleError = nil
                        markModified()
                    }

                HStack {
                    Spacer()
                    if !newTitle.isEmpty {
                        Button {
                            newTitle = ""
                            markModified()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 23, height: 23)
                                .foregroundStyle(Color.myB9B9B9)
                        }
                        .padding(.trailing)
                    }
                }
            }

            HStack(spacing: 0) {
                Spacer()
                Text("\(newTitle.count)")
                    .font(.setPretendard(weight: .medium, size: 12))
                    .foregroundStyle(Color.my6C6C6C)
                Text("/\(titleLimit)")
                    .font(.setPretendard(weight: .medium, size: 12))
                    .foregroundStyle(Color.my6C6C6C.opacity(0.5))
            }
            .padding(.trailing, 10)

            if let titleError {
                Text(titleError)
                    .font(.setPretendard(weight: .medium, size: 13))
                    .foregroundStyle(.red.opacity(0.85))
                    .padding(.leading, 4)
            }

            wwhGuide()
        }
    }

    @ViewBuilder
    func wwhGuide() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                Image(viewModel.wwh[0] ? "Routine_Check_Green" : "Routine_Check")
                    .resizable()
                    .frame(width: 16, height: 16)
                Text("어디서")
                    .font(.setPretendard(weight: .semiBold, size: 14))
                    .foregroundStyle(viewModel.wwh[0] ? .my6FB56F : .myC8B7A3)

                Image(viewModel.wwh[1] ? "Routine_Check_Green" : "Routine_Check")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .padding(.leading, 8)
                Text("무엇을")
                    .font(.setPretendard(weight: .semiBold, size: 14))
                    .foregroundStyle(viewModel.wwh[1] ? .my6FB56F : .myC8B7A3)

                Image(viewModel.wwh[2] ? "Routine_Check_Green" : "Routine_Check")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .padding(.leading, 8)
                Text("얼마나")
                    .font(.setPretendard(weight: .semiBold, size: 14))
                    .foregroundStyle(viewModel.wwh[2] ? .my6FB56F : .myC8B7A3)

                Button {
                    isQuestionMarkClicked.toggle()
                } label: {
                    Image(systemName: "questionmark.circle")
                        .foregroundStyle(.my8E8E8E)
                }
                Spacer()
            }

            if isQuestionMarkClicked {
                Text("체크항목을 참고해서 루틴을 더 구체적으로 작성해보세요.")
                    .font(.setPretendard(weight: .medium, size: 13))
                    .foregroundStyle(.myB4A99D)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(Color.myF0E8DF)
                    .cornerRadius(8)
            }
        }
    }

    @ViewBuilder
    func memoSection() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("메모")
                .font(.setPretendard(weight: .semiBold, size: 16))
                .padding(.leading, 4)
                .foregroundStyle(Color.my675542)

            ZStack(alignment: .bottomTrailing) {
                TextEditor(text: $newMemo)
                    .scrollContentBackground(.hidden)
                    .focused($isFocused)
                    .font(.setPretendard(weight: .medium, size: 14))
                    .foregroundStyle(Color.my2B2B2B)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .onChange(of: newMemo) { _, newValue in
                        if newValue.count > memoLimit {
                            newMemo = String(newValue.prefix(memoLimit))
                        }
                        markModified()
                    }

                if newMemo.isEmpty {
                    VStack {
                        HStack {
                            Text("루틴에 대한 메모를 자유롭게 작성해보세요.")
                                .font(.setPretendard(weight: .medium, size: 14))
                                .foregroundStyle(Color.myB9B9B9)
                                .padding(.top, 18)
                                .padding(.leading, 18)
                            Spacer()
                        }
                        Spacer()
                    }
                    .allowsHitTesting(false)
                }

                Text("\(newMemo.count)/\(memoLimit)")
                    .font(.setPretendard(weight: .medium, size: 12))
                    .foregroundStyle(Color.my6C6C6C)
                    .padding(.trailing, 10)
                    .padding(.bottom, 10)
            }
            .frame(height: 133/852 * UIScreen.main.bounds.height)
            .background(.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.myF0E8DF, lineWidth: 1)
            )
            .onTapGesture {
                isFocused = true
            }
        }
    }

    @ViewBuilder
    func repeatSection() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("반복 유형")
                .font(.setPretendard(weight: .semiBold, size: 16))
                .padding(.leading, 4)
                .foregroundStyle(Color.my675542)

            Text("루틴이 언제 수행되는지 선택해주세요.")
                .font(.setPretendard(weight: .medium, size: 14))
                .foregroundStyle(Color.myB4A99D)
                .padding(.leading, 4)

            VStack(alignment: .leading, spacing: 16) {
                Picker("반복 유형", selection: $repeatType) {
                    ForEach(RoutineRepeatType.selectableCases, id: \.self) { type in
                        Text(type.title).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: repeatType) { _, newValue in
                    repeatError = nil
                    if newValue == .monthlyDate {
                        alertMon = false
                        alertTue = false
                        alertWed = false
                        alertThu = false
                        alertFri = false
                        alertSat = false
                        alertSun = false
                    }
                    markModified()
                }

                if repeatType == .weekday {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("반복 요일")
                            .font(.setPretendard(weight: .semiBold, size: 16))

                        HStack(spacing: 12) {
                            DayButton(title: "월", isSelected: $alertMon, isModified: $isModified)
                            DayButton(title: "화", isSelected: $alertTue, isModified: $isModified)
                            DayButton(title: "수", isSelected: $alertWed, isModified: $isModified)
                            DayButton(title: "목", isSelected: $alertThu, isModified: $isModified)
                            DayButton(title: "금", isSelected: $alertFri, isModified: $isModified)
                            DayButton(title: "토", isSelected: $alertSat, isModified: $isModified)
                            DayButton(title: "일", isSelected: $alertSun, isModified: $isModified)
                        }
                    }
                } else if repeatType == .monthlyDate {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("주간 수행 횟수")
                            .font(.setPretendard(weight: .semiBold, size: 16))
                        Stepper(value: $scheduledDayOfMonth, in: 1...7) {
                            Text("주 \(scheduledDayOfMonth)회")
                                .font(.setPretendard(weight: .medium, size: 16))
                        }
                        .onChange(of: scheduledDayOfMonth) { _, _ in
                            repeatError = nil
                            markModified()
                        }
                    }
                }
            }
            .padding()
            .background(.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(repeatError == nil ? Color.myF0E8DF : .red.opacity(0.7), lineWidth: 1)
            )

            if let repeatError {
                Text(repeatError)
                    .font(.setPretendard(weight: .medium, size: 13))
                    .foregroundStyle(.red.opacity(0.85))
                    .padding(.leading, 4)
            }
        }
    }

    @ViewBuilder
    func timeSection() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("시간대 선택")
                .font(.setPretendard(weight: .semiBold, size: 16))
                .padding(.leading, 4)
                .foregroundStyle(Color.my675542)

            Text("루틴을 실행할 대략적인 시간대를 선택해주세요.")
                .font(.setPretendard(weight: .medium, size: 14))
                .foregroundStyle(Color.myB4A99D)
                .padding(.leading, 4)

            HStack {
                Text("루틴 시간대")
                    .font(.setPretendard(weight: .medium, size: 16))
                Spacer()
                Picker("시간대", selection: $selectedTime) {
                    ForEach(timeOptions, id: \.self) { time in
                        Text(time).tag(time)
                    }
                }
                .pickerStyle(.menu)
                .accentColor(.my3C3C43.opacity(0.6))
                .onChange(of: selectedTime) { _, _ in
                    markModified()
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
    }

    @ViewBuilder
    func remindSection() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("리마인드 알림")
                .font(.setPretendard(weight: .semiBold, size: 16))
                .padding(.leading, 4)
                .foregroundStyle(Color.my675542)

            Text("하고만다는 서버 없이 로컬 알림으로 루틴 시작을 안내해드려요.")
                .font(.setPretendard(weight: .medium, size: 14))
                .foregroundStyle(Color.myB4A99D)
                .padding(.leading, 4)

            VStack(spacing: 0) {
                HStack {
                    Text("알림 설정")
                        .font(.setPretendard(weight: .medium, size: 16))
                    Spacer()
                    Toggle("", isOn: $isRemind)
                        .toggleStyle(SwitchToggleStyle(tint: Color.my538F53))
                        .onChange(of: isRemind) { _, newValue in
                            markModified()
                            guard newValue else { return }
                            fetchNotificationAuthorizationState { state in
                                DispatchQueue.main.async {
                                    switch state {
                                    case .authorized:
                                        isRemind = true
                                    case .notDetermined:
                                        requestNotificationPermission { granted in
                                            DispatchQueue.main.async {
                                                isRemind = granted
                                                if !granted {
                                                    showPermissionAlert = true
                                                }
                                            }
                                        }
                                    case .denied:
                                        isRemind = false
                                        showPermissionAlert = true
                                    }
                                }
                            }
                        }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)

                if isRemind {
                    Divider().foregroundStyle(Color.myF0E8DF)
                    HStack {
                        Text("알림 시간")
                            .font(.setPretendard(weight: .medium, size: 16))
                        Spacer()
                        DatePicker(
                            "",
                            selection: Binding(
                                get: { remindTime ?? Date() },
                                set: { remindTime = $0 }
                            ),
                            displayedComponents: .hourAndMinute
                        )
                        .labelsHidden()
                        .onChange(of: remindTime) { _, _ in
                            markModified()
                        }
                    }
                    .padding()
                }
            }
            .background(.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.myF0E8DF, lineWidth: 1)
            )
        }
    }

    @ViewBuilder
    func deleteButton() -> some View {
        Button {
            showDeleteAlert = true
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "trash")
                    .font(.system(size: 16))
                    .foregroundStyle(.red)
                Text("삭제하기")
                    .font(.setPretendard(weight: .medium, size: 16))
                    .foregroundStyle(.red)
            }
            .padding(.vertical, 14.5)
            .frame(maxWidth: .infinity)
            .background(Color.myF0E8DF)
            .cornerRadius(12)
        }
        .alert("루틴을 삭제하시겠습니까?", isPresented: $showDeleteAlert) {
            Button("삭제하기", role: .destructive) {
                if let detailGoal {
                    viewModel.deleteDetailGoal(detailGoal: detailGoal, days: ["월", "화", "수", "목", "금", "토", "일"])
                    if let mainGoal = mainGoal(containing: detailGoal) {
                        let routineViewModel = TodayRoutineViewModel()
                        routineViewModel.updateCloverState(for: mainGoal)
                        routineViewModel.calculateCurrentWeekAndMonthWeek(
                            mainGoal: mainGoal,
                            clovers: clovers,
                            context: modelContext
                        )
                        routineViewModel.refreshNotificationSchedules(mainGoals: mainGoals)
                        routineViewModel.syncWidgetSnapshot(mainGoals: mainGoals)
                    }
                }
                dismiss()
            }
            Button("취소", role: .cancel) {}
        } message: {
            Text("삭제한 루틴은 다시 되돌릴 수 없어요.")
        }
    }
}

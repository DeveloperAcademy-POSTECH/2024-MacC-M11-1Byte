//
//  MadalArtCRUDTestViewModel.swift
//  OneByte
//
//  Created by 트루디 on 10/30/24.
//

// CUTestViewModel.swift
import SwiftUI
import SwiftData
import NaturalLanguage
import CoreML
import Combine
import UIKit
import FirebaseFirestore


class MandalartViewModel: ObservableObject {
    @Published var mainGoal: MainGoal?
    
    @Published var detailGoalTitleText: String = ""
    private var cancellables = Set<AnyCancellable>()
    
    private let mlModel: SpecificTagger4192
    
    @Published var wwh: [Bool] = [false, false, false] // Where What HOW-MUCH 포함 여부 리스트
    let whenList: [String] = [
        "매일", "일일",
        "매주", "주간",
        "매달", "월간",
        "매년", "연간",
        "매시간", "매분", "매초",
        "격주", "격월", "격년",
        "매일매일",
        "아침", "점심", "저녁",
        "아침에", "점심에", "저녁에",
        "오전", "오후", "밤", "새벽",
        "오전에", "오후에", "밤에", "새벽에",
        "월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"
    ]
    
    let howMuchList: [String] = [
        // 횟수
        "한번", "두번", "세번", "네번", "다섯번", "여섯번", "일곱번", "여덟번", "아홉번", "열번", "하나", "둘", "셋", "넷", "다섯", "여섯", "일곱", "여덟", "아홉" ,"열", "두", "세",
        
        // 수량
        "한개", "두개", "세개", "네개", "다섯개", "여섯개", "일곱개", "여덟개", "아홉개", "열개","한알", "두알", "세알", "네알",
        
        // 거리
        "한바퀴", "두바퀴", "세바퀴", "네바퀴",
        
        // 시간
        "한시간", "두시간", "세시간", "한차례", "두차례", "세차례",
        
        // 음료 및 음식
        "한잔", "두잔", "세잔", "한접시", "두접시", "세접시", "한그릇", "두그릇", "세그릇", "한컵", "두컵", "세컵",
        
        // 운동
        "한세트", "두세트", "세세트", "한회", "두회", "세회",
        
        //문제
        "한문제", "두문제", "세문제"
    ]
    
    let db = Firestore.firestore()
        .collection("routines")
    
    private let createService: CreateGoalUseCase
    private let updateService: UpdateGoalUseCase
    private let deleteService: DeleteService
    
    init(createService: CreateGoalUseCase, updateService: UpdateGoalUseCase, deleteService: DeleteService ) {
        self.createService = createService
        self.updateService = updateService
        self.deleteService = deleteService
        self.mlModel = try! SpecificTagger4192(configuration: MLModelConfiguration())
        self.manageWordTagger()
    }
    
    func createGoals(modelContext: ModelContext) {
        createService.createGoals(modelContext: modelContext)
    }
    
    func updateMainGoal(mainGoal: MainGoal,id: Int, newTitle: String, cloverState: Int) {
        updateService.updateMainGoal(mainGoal: mainGoal, id: id, newTitle: newTitle, cloverState: cloverState)
    }
    
    func updateSubGoal(subGoal: SubGoal, newTitle: String, category: String) {
        updateService.updateSubGoal(subGoal:subGoal,newTitle: newTitle, category: category)
    }
    
    func updateDetailGoal(detailGoal: DetailGoal, newTitle: String, newMemo: String, achieveCount: Int, achieveGoal: Int, alertMon: Bool, alertTue: Bool, alertWed: Bool, alertThu: Bool, alertFri: Bool, alertSat: Bool, alertSun: Bool, isRemind: Bool, remindTime: Date?, achieveMon: Bool, achieveTue: Bool, achieveWed: Bool, achieveThu: Bool, achieveFri: Bool, achieveSat: Bool, achieveSun: Bool, isMorning: Bool, isAfternoon: Bool, isEvening: Bool, isNight: Bool, isFree: Bool) async {
        updateService.updateDetailGoal(
            detailGoal: detailGoal,
            title: newTitle,
            memo: newMemo,
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
            achieveSun: achieveSun,
            isMorning: isMorning,
            isAfternoon: isAfternoon,
            isEvening: isEvening,
            isNight: isNight,
            isFree: isFree
        )
        do {
            let ref = try await db.addDocument(data: [
                "device_UUID": UserDefaults().string(forKey: "deviceUUID") ?? "None",
                "title": newTitle,
                "memo": newMemo,
                "alertMon": alertMon,
                "alertTue": alertTue,
                "alertWed": alertWed,
                "alertThu": alertThu,
                "alertFri": alertFri,
                "alertSat": alertSat,
                "alertSun": alertSun,
                "isMorning": isMorning,
                "isAfternoon": isAfternoon,
                "isEvening": isEvening,
                "isNight": isNight,
                "isFree": isFree,
                "createdAt": FieldValue.serverTimestamp()
                
            ])
            print("Document added with ID: \(ref.documentID)")
        } catch {
            print("Error adding document: \(error)")
        }
    }
    
    func deleteMainGoal(mainGoal: MainGoal) {
        deleteService.deleteMainGoal(mainGoal: mainGoal)
    }
    
    func deleteSubGoal(subGoal: SubGoal) {
        deleteService.deleteSubGoal(subGoal: subGoal)
    }
    
    func deleteSubDetailGoals(subGoal: SubGoal, days: [String]) {
        deleteService.deleteSubDetailGoals(subGoal: subGoal, days: days)
    }
    
    func deleteDetailGoal(detailGoal: DetailGoal, days: [String]) {
        deleteService.deleteDetailGoal(detailGoal: detailGoal, days: days)
    }
    
    func resetAllData(modelContext: ModelContext, mainGoal: MainGoal) {
        deleteService.resetAllData(modelContext: modelContext, mainGoal: mainGoal)
    }
    
    func deleteNotification(detailGoal: DetailGoal, days: [String]) {
        deleteService.deleteNotification(detailGoal: detailGoal, days: days)
    }
    
    func initializeSubGoal(subGoal: SubGoal?, categories: [String]) -> (String, Bool) {
        guard let subGoal = subGoal else {
            return ("", false) // 기본값 반환
        }
        
        let category = subGoal.category
        
        // 저장된 카테고리가 categories에 없으면 "기타" 활성화
        let isCustomCategoryActive = !categories.contains(category) && !category.isEmpty
        
        return (category, isCustomCategoryActive)
    }
    
    func presentShareSheet(with image: UIImage, isClickedShare: Binding<Bool>, showToast: Binding<Bool>) {
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)

        // 시트가 닫히는 시점을 감지
        activityVC.completionWithItemsHandler = { activity, success, items, error in
            if success {
                print("Sharing succeeded.") // 공유 성공 시 동작
            } else {
                print("Sharing cancelled or failed.") // 공유 취소 또는 실패 시 동작
            }
            print("Share sheet dismissed.") // 시트가 닫힌 후 동작
            isClickedShare.wrappedValue = false
            self.showToastMessage(showToast: showToast)
        }

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
    // Time Period Management
    func updateTimePeriodStates(detailGoal: DetailGoal, for time: String) {
        // 모든 값 초기화
        detailGoal.isMorning = false
        detailGoal.isAfternoon = false
        detailGoal.isEvening = false
        detailGoal.isNight = false
        detailGoal.isFree = false
        
        // 시간대에 맞게 상태 업데이트
        switch time {
        case "아침":
            detailGoal.isMorning = true
        case "점심":
            detailGoal.isAfternoon = true
        case "저녁":
            detailGoal.isEvening = true
        case "자기전":
            detailGoal.isNight = true
        case "자율":
            detailGoal.isFree = true
        default:
            break
        }
    }
    
    func manageWordTagger() {
        $detailGoalTitleText
            .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
            .sink { [weak self] newText in
                self?.wordTagger()
            }
            .store(in: &cancellables)
    }

    func wordTagger() {
        guard !detailGoalTitleText.isEmpty else {
            wwh = [false,false,false]
            return
        }
        do {
            let tokenizer = NLTokenizer(unit: .word)
            tokenizer.string = detailGoalTitleText
            var tokens: [String] = []
            tokenizer.enumerateTokens(in: detailGoalTitleText.startIndex..<detailGoalTitleText.endIndex) { tokenRange, _ in
                let word = String(detailGoalTitleText[tokenRange])
                print("\(tokenRange)")
                tokens.append(word)
                return true
            }
            
            var results: [TaggedWord] = []
            for word in tokens {
                let input = SpecificTagger4192Input(text: word)
                let output = try mlModel.prediction(input: input)
                let tag = output.labels
                let taggedWord = TaggedWord(word: word, tag: tag.first ?? "")
                results.append(taggedWord)
            }
            wwh = convertToWWH(taggedWords: results)
        } catch {
            wwh = [false,false,false]
            print("Error loading model or making prediction: \(error)")
        }
    }
    
    func convertToWWH(taggedWords: [TaggedWord]) -> [Bool] {
        var wwh: [Bool] = [false,false,false]
        
        for word in taggedWords {
            if howMuchList.contains(word.word) {
                wwh[2] = true
                continue
            }
            if whenList.contains(word.word) {
                continue
            }
            if word.tag == "WHERE" {
                print("WHERE: \(word.word)")
                wwh[0] = true
            }
            if word.tag == "WHAT" {
                print("WHAT: \(word.word)")
                wwh[1] = true
            }
            if word.tag == "HOW-MUCH" {
                print("HOW-MUCH: \(word.word)")
                wwh[2] = true
            }
            else {
                continue
            }
        }
        return wwh
    }
    
    func triggerHapticOn() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    // 알림 생성
    func createNotification(detailGoal: DetailGoal, newTitle: String, selectedDays: [String]) {
        createService.createNotification(detailGoal: detailGoal, newTitle: newTitle, selectedDays: selectedDays)
    }
    
    // 하고만다 앱의 '휴대폰 설정'화면으로 이동
    func openAppSettings() {
        if let appSettingsURL = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(appSettingsURL) {
                UIApplication.shared.open(appSettingsURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    // 알림 허용, 거부 여부 반환 함수
    func checkNotificationPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                print("알림 권한이 아직 결정되지 않았습니다.")
                // 권한 요청을 할 수 있음
                completion(true) // 아직 결정되지 않았으면 알림을 요청할 수 있으므로 true 반환
            case .denied:
                print("알림 권한이 거부되었습니다.")
                // 알림 권한이 거부된 상태
                completion(false) // 거부된 상태이므로 false 반환
            case .authorized:
                print("알림 권한이 허용되었습니다.")
                // 알림 권한이 허용된 상태
                completion(true) // 허용된 상태이므로 true 반환
            case .provisional:
                print("알림 권한이 임시 허용되었습니다.")
                // 임시 권한 허용 상태
                completion(true) // 임시 허용된 상태는 알림이 활성화되므로 true 반환
            case .ephemeral:
                print("알림 권한이 임시적(ephemeral)으로 허용되었습니다.")
                // ephemeral은 잠시만 허용된 상태이므로, 그에 맞는 처리 추가 가능
                completion(true) // 임시 허용도 알림이 활성화되므로 true 반환
            @unknown default:
                print("알 수 없는 상태입니다.")
                completion(true) // 알 수 없는 상태인 경우는 기본적으로 true 반환
            }
        }
    }
    
    func colorForGoal(achieveGoal: Int, achieveCount: Int) -> Color {
        switch (achieveGoal, achieveCount) {
        case(0,0):
            return Color.myD6F3D4
        case (1, 0):
            return Color.myD6F3D4
        case (1, 1):
            return Color.my438243
        case (2, 1...2):
            return achieveCount == 1 ? Color.myBFEBBB : Color.my428142
        case (3, 1...3):
            switch achieveCount {
            case 1: return Color.myBFEBBB
            case 2: return Color.my85C985
            default: return Color.my428142
            }
        case (4, 1...4):
            switch achieveCount {
            case 1: return Color.myBFEBBB
            case 2: return Color.myA0D8A0
            case 3: return Color.my6CB76C
            default: return Color.my428142
            }
        case (5, 1...5):
            switch achieveCount {
            case 1: return Color.myBFEBBB
            case 2: return Color.myA0D8A0
            case 3: return Color.my78C478
            case 4: return Color.my599859
            default: return Color.my428142
            }
        case (6, 1...6):
            switch achieveCount {
            case 1: return Color.myBFEBBB
            case 2: return Color.myA8DCAB
            case 3: return Color.my86CD86
            case 4: return Color.my6FB56F
            case 5: return Color.my599859
            default: return Color.my428142
            }
        case (7, 1...7):
            switch achieveCount {
            case 1: return Color.myBFEBBB
            case 2: return Color.myB0E4B0
            case 3: return Color.my95D895
            case 4: return Color.my7FC77F
            case 5: return Color.my6FB56F
            case 6: return Color.my599859
            default: return Color.my428142
            }
        default:
            return Color.myD6F3D4 // 기본 색상
        }
    }
    
    func showToastMessage(showToast: Binding<Bool>) {
        showToast.wrappedValue = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation {
                showToast.wrappedValue = false
            }
        }
    }
    
}

struct TaggedWord {
    let word: String
    let tag: String
}


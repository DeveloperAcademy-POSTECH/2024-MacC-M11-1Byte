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

class MandalartViewModel: ObservableObject {
    @Published var mainGoal: MainGoal?
    
    var taggedWords: [TaggedWord] = []
    var text: String = ""
    
    var wwh: [Int] {
        wordTagger()
    }
    
    private let createService: CreateGoalUseCase
    private let updateService: UpdateGoalUseCase
    private let deleteService: DeleteService
    
    init(createService: CreateGoalUseCase, updateService: UpdateGoalUseCase, deleteService: DeleteService ) {
        self.createService = createService
        self.updateService = updateService
        self.deleteService = deleteService
    }
    
    func createGoals(modelContext: ModelContext) {
        createService.createGoals(modelContext: modelContext)
    }
    
    func updateMainGoal(mainGoal: MainGoal,id: Int, newTitle: String, cloverState: Int) {
        updateService.updateMainGoal(mainGoal: mainGoal, id: id, newTitle: newTitle, cloverState: cloverState)
    }
    
    func updateSubGoal(subGoal: SubGoal, newTitle: String, leafState: Int) {
        updateService.updateSubGoal(subGoal:subGoal,newTitle: newTitle, leafState: leafState)
    }
    
    func updateDetailGoal(detailGoal: DetailGoal, newTitle: String, newMemo: String, achieveCount: Int, achieveGoal: Int, alertMon: Bool, alertTue: Bool, alertWed: Bool, alertThu: Bool, alertFri: Bool, alertSat: Bool, alertSun: Bool, isRemind: Bool, remindTime: Date?, achieveMon: Bool, achieveTue: Bool, achieveWed: Bool, achieveThu: Bool, achieveFri: Bool, achieveSat: Bool, achieveSun: Bool) {
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
            achieveSun: achieveSun
        )
    }
    
    func deleteMainGoal(mainGoal: MainGoal, modelContext: ModelContext, id: Int, newTitle: String, cloverState: Int) {
        deleteService.deleteMainGoal(mainGoal: mainGoal, modelContext: modelContext, id: id, newTitle: newTitle, cloverState: cloverState)
    }
    
    func deleteSubGoal(subGoal: SubGoal, id: Int, newTitle: String, leafState: Int) {
        deleteService.deleteSubGoal(subGoal: subGoal, newTitle: newTitle, leafState: leafState)
    }
    
    func deleteDetailGoal(detailGoal: DetailGoal,newTitle: String, newMemo: String, achieveCount: Int, achieveGoal: Int, alertMon: Bool, alertTue: Bool, alertWed: Bool, alertThu: Bool, alertFri: Bool, alertSat: Bool, alertSun: Bool, isRemind: Bool, remindTime: Date?, achieveMon: Bool, achieveTue: Bool, achieveWed: Bool, achieveThu: Bool, achieveFri: Bool, achieveSat: Bool, achieveSun: Bool) {
        deleteService.deleteDetailGoal(
            detailGoal: detailGoal,
            title: newTitle, memo: newMemo,
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
            achieveWed: achieveWed
            , achieveThu: achieveThu,
            achieveFri: achieveFri,
            achieveSat: achieveSat,
            achieveSun: achieveSun
        )
    }
    
    func resetAllData(modelContext: ModelContext, mainGoal: MainGoal) {
        deleteService.resetAllData(modelContext: modelContext, mainGoal: mainGoal)
    }

    func wordTagger() -> [Int] {
        let text = text
        
        guard !text.isEmpty else {
            return []
        }
        
        do {
            let mlModel = try SpecificTagger3496(configuration: MLModelConfiguration())
            
            let tokenizer = NLTokenizer(unit: .word)
            tokenizer.string = text
            var tokens: [String] = []
            tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { tokenRange, _ in
                let word = String(text[tokenRange])
                print("\(tokenRange)")
                tokens.append(word)
                return true
            }
            
            var results: [TaggedWord] = []
            for word in tokens {
                let input = SpecificTagger3496Input(text: word)
                let output = try mlModel.prediction(input: input)
                let tag = output.labels
                let taggedWord = TaggedWord(word: word, tag: tag.first ?? "")
                results.append(taggedWord)
            }
            
            DispatchQueue.main.async {
                self.taggedWords = results
            }
            
            return convertToWWH(taggedWords: taggedWords)
        
        } catch {
            print("Error loading model or making prediction: \(error)")
        }
        return []
        
    }
    
    func convertToWWH(taggedWords: [TaggedWord]) -> [Int] {
        var wwh: [Int] = [0,0,0]
        
        for word in taggedWords{
            if word.tag == "WHERE" {
                print("WHERE: \(word.word)")
                wwh[0] = 1
            }
            if word.tag == "WHAT" {
                print("WHAT: \(word.word)")
                wwh[1] = 1
            }
            if word.tag == "HOW-MUCH" {
                print("HOW-MUCH: \(word.word)")
                wwh[2] = 1
            }
            else {
                continue
            }
        }
        return wwh
    }
}

struct TaggedWord {
    let word: String
    let tag: String
}


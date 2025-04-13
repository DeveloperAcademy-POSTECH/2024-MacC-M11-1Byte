//
//  FirebaseService.swift
//  OneByte
//
//  Created by Dabin Lee on 2/5/25.
//

import Foundation
import FirebaseFirestore
import Combine

class FirebaseService: FirebaseUseCase {
    @Published var isConnected: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    let db = Firestore.firestore()
        .collection("routines")
    
    init(){
        NetworkMonitor.shared.$isConnected
            .receive(on: DispatchQueue.main)
            .assign(to: \.isConnected, on: self)
            .store(in: &cancellables)
    }
    
    func saveDeatailGoalData(newTitle: String, newMemo: String, alertMon: Bool, alertTue: Bool, alertWed: Bool, alertThu: Bool, alertFri: Bool, alertSat: Bool, alertSun: Bool) async {
        
        guard isConnected else {
            print("🛜인터넷 연결이 되어있지 않아, 서버 통신 불가")
            return
        }
        
        do {
            let ref = try await db.addDocument(data: [
                "device_UUID": UserDefaults.loadDeviceUUID(),
                "title": newTitle,
                "memo": newMemo,
                "alertMon": alertMon,
                "alertTue": alertTue,
                "alertWed": alertWed,
                "alertThu": alertThu,
                "alertFri": alertFri,
                "alertSat": alertSat,
                "alertSun": alertSun,
                "createdAt": FieldValue.serverTimestamp()
                
            ])
            print("Document added with ID: \(ref.documentID)")
        } catch {
            print("Error adding document: \(error)")
        }
    }
    
    
}

//
//  RecordManager.swift
//  WalkBreak14
//
//  Created by cmStudent on 2022/09/02.
//

import Foundation

struct Record: Identifiable, Codable {
    var id = UUID()
    var date: String
    var content: String
}

final class RecordManager {
    
    // 記録を入れる配列
    private var recordArray: [Record]  = [
        Record(date: "日付", content: "内容"),
        Record(date: "日付", content: "内容"),
        Record(date: "日付", content: "内容"),
        Record(date: "日付", content: "内容"),
        Record(date: "日付", content: "内容")
    ] {
        didSet {
            saveRecode(data: recordArray)
        }
    }
    
    init() {
        // 記録を入れる
        if let data = UserDefaults.standard.data(forKey: "userRecord") {
            if let getData = try? JSONDecoder().decode([Record].self, from: data) {
                recordArray = getData
            }
        }
    }
    
    func addRecord(content: String) {
        // 通知が30以上なら古い通知から削除する
        if recordArray.count > 29 {
            for num in 29..<recordArray.count {
                recordArray.remove(at: num)
            }
        }
        
        // 日付
        let date = Date()
        // フォーマッター
        let formatter = DateFormatter()
        // 西暦に変換
        formatter.calendar = Calendar(identifier: .gregorian)
        // 日付のフォーマットを指定
        formatter.dateFormat = "yyyy年MM月dd日 HH時mm分ss秒"
        // フォーマットした日付
        let fDate = formatter.string(from: date)
        
        // 配列の一番目に追加する
        recordArray.insert(Record(date: fDate, content: content), at: 0)
        
    }
    
    
    func getRecode() -> [Record] {
        return recordArray
    }
    
    // 記録クラスの保存
    private func saveRecode(data: [Record]) {
        guard let data = try? JSONEncoder().encode(data) else { return }
        UserDefaults.standard.set(data, forKey: "userRecord")
    }
    
}

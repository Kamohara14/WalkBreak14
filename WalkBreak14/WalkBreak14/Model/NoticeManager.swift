//
//  NoticeManager.swift
//  WalkBreak14
//
//  Created by cmStudent on 2022/08/25.
//

import Foundation
import UserNotifications // 通知用

struct Notice: Identifiable, Codable {
    var id = UUID()
    var title: String
    var date: String
}

final class NoticeManager {
    
    // 通知を入れる配列
    private var noticeArray: [Notice] = [] {
        didSet {
            saveNotice(data: noticeArray)
        }
    }
    
    // 通知許可が取れたかどうか
    private var noticePermit = false
    
    init() {
        
        // 通知を入れる
        if let data = UserDefaults.standard.data(forKey: "userNotice") {
            if let getData = try? JSONDecoder().decode([Notice].self, from: data) {
                noticeArray = getData
            }
        }
        
        // 通知許可
        permitNotification()
        
        // 通知の設定状況を反映
        noticePermit = UserDefaults.standard.bool(forKey: "noticePermit")
    }
    
    func permitNotification() {
        // 通知のリセット
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        // 通知を許諾するかどうか表示する(初使用時のみ)
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound, .badge]){
            (granted, _) in
            // 通知を許可していなかったら返す
            if granted {
                // 通知が許可されている
                self.noticePermit = true
                print("通知ON")
                
            } else {
                // 通知が許可されていない
                self.noticePermit = false
                print("通知OFF")
                
            }
        }
    }
    
    // 通知作成(水分補給か休憩かを判定)
    func makeNotification(isMoisture: Bool) {
        // 通知の許可をしていないなら実行させない
        if !noticePermit {
            print("通知が許可されていない")
            return
        }
        
        // 通知タイミング(即時に通知する, 繰り返さない)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        // 通知の内容
        let content = UNMutableNotificationContent()
        // identifier
        let identifier: String
        
        if isMoisture {
            // 水分補給の通知
            content.title = "水分補給をして下さい"
            identifier = "notification_moisture"
            
        } else {
            // 休憩の通知
            content.title = "休憩することをおすすめします"
            identifier = "notification_rest"
            
        }
        // タイトル確認
        print(content.title)
        // テキスト
        content.body = "タップでAppを開く"
        // サウンド(デフォルト)
        content.sound = UNNotificationSound.default
        
        //リクエスト作成
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        //リクエスト実行
        UNUserNotificationCenter.current().add(request)
    }
    
    
    
    
    func addNotice(title: String) {
        // 通知が10以上なら古い通知から削除する
        if noticeArray.count > 9 {
            for num in 9..<noticeArray.count {
                noticeArray.remove(at: num)
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
        noticeArray.insert(Notice(title: title, date: fDate), at: 0)
        
    }
    
    func getNotice() -> [Notice] {
        return noticeArray
    }
    
    // 通知クラスの保存
    private func saveNotice(data: [Notice]) {
        guard let data = try? JSONEncoder().encode(data) else { return }
        UserDefaults.standard.set(data, forKey: "userNotice")
    }
    
}

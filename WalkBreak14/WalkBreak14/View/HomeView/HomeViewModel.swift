//
//  HomeViewModel.swift
//  WalkBreak14
//
//  Created by cmStudent on 2022/08/18.
//

import Foundation
import SwiftUI
import UserNotifications // 通知用

final class HomeViewModel: ObservableObject {
    // Model
    private let motionManager = MotionManager.shared
    
    // MARK: - step
    // 歩数
    @Published var stepCount = 0
    // 歩いているかどうか
    @Published var isWalking = false
    
    // MARK: - Notification
    // 通知の許可
    @Published var isNotification: Bool = false
    // 水分通知
    @Published var moistureFlag = false
    // 休憩通知(ローカル)
    @Published var restFlag = false
    // 休憩通知(画面上)
    @Published var restViewFlag = false
    
    // MARK: - timer
    // 休憩秒数
    // TODO: 検証用に秒数を15にしているので、検証が必要無くなれば600に戻すこと
    @Published var restTime = 15
    // タイマーの変数を作成
    @Published var timerHandler : Timer?
    // カウント(経過時間)の変数を作成
    @Published var timerCount = 0
    // 休憩中かどうか
    @Published var isRest = false
    
    init() {
        // 通知を許諾するかどうか表示する(初使用時のみ)
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound, .badge]){
            (granted, error) in
            // エラーが発生したら戻す
            if error != nil {
                print("エラー：\(String(describing: error))")
                return
            }
            // 許諾内容を反映する
            print("通知初期化完了")
            DispatchQueue.main.async {
                self.isNotification = granted
            }
        }
        
        // 歩数計測開始
        updateSteps()
    }
    
    // 通知作成(水分補給か休憩かを判定)
    // FIXME: 通知が出る時と出ない時がある。原因がわからない。
    func makeNotification(isMoisture: Bool) {
        // 通知の許可をしていないなら実行させない
        if !isNotification {
            print("通知が許可されていない")
            return
        }
        
        //通知タイミング(即時に通知する, 繰り返さない)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        //通知の内容
        let content = UNMutableNotificationContent()
        
        var identifier = "notification"
        
        if isMoisture {
            // 水分補給通知のタイトル
            content.title = "水分補給をして下さい"
            identifier = "notification_moisture"
            
        } else {
            // 休憩通知のタイトル
            content.title = "休憩することをおすすめします"
            identifier = "notification_rest"
            
        }
        print(content.title)
        // テキスト
        content.body = "タップでAppを開く"
        // サウンド(デフォルト)
        content.sound = UNNotificationSound.default
        
        //リクエスト作成
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        //リクエスト実行
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func updateSteps() {
        guard !isWalking else { return }
        isWalking = true
        
        motionManager.updateMotion { count, moisture, rest in
            DispatchQueue.main.async {
                // 歩数を受け取る
                self.stepCount = count
                
                // 通知判定を受け取る
                self.moistureFlag = moisture
                self.restFlag = rest
                
                // 水分補給の通知
                if moisture {
                    self.makeNotification(isMoisture: true)
                    print("水分補給通知")
                }
                // 休憩の通知
                if rest {
                    self.makeNotification(isMoisture: false)
                    // 画面上の通知もONにする
                    self.restViewFlag = true
                    print("休憩通知")
                }
                
            }
        }
    }
    
    // 休憩スタート
    func startRest() {
        //カウントダウン中にスタートさせない
        if let unwrapedTimerHandler = timerHandler{
            if unwrapedTimerHandler.isValid {
                return
            }
        }
        
        // 休憩中
        self.isRest = true

        //タイマーをスタート(1秒毎に,繰り返す)
        timerHandler = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            _ in do {
                self.timerCount += 1
                print(self.timerCount)
                
                //タイマーを止める
                if self.restTime - self.timerCount <= 0 {
                    self.timerHandler?.invalidate()
                    // カウントリセット
                    self.timerCount = 0
                    // 画面上の通知をOFFにする
                    self.restViewFlag = false
                    // 休憩終了
                    self.isRest = false
                }
            }
        }
        
    }
    
    func stopSteps() {
        guard isWalking else { return }
        isWalking = false
        motionManager.stopMotion()
        
    }
}

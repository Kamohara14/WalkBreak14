//
//  WalkBreakViewModel.swift
//  WalkBreak14
//
//  Created by cmStudent on 2022/09/06.
//

import Foundation
import SwiftUI

final class WalkBreakViewModel: ObservableObject {
    
    // Model
    @Published private var motionManager = MotionManager.shared
    @Published private var noticeManager = NoticeManager()
    @Published private var recordManager = RecordManager()
    
    // MARK: - step
    // 歩数
    @Published var steps = 0
    // 歩いているかどうか
    @Published var isWalking = false
    
    // MARK: - Notification
    // 休憩通知(画面上)
    @Published var restViewFlag: Bool {
        didSet {
            UserDefaults.standard.set(restViewFlag, forKey: "restViewFlag")
        }
    }
    // 通知を入れる配列
    @Published var noticeArray: [Notice] = []
    
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
    
    // MARK: - record
    // 記録を入れる配列
    @Published var recordArray: [Record] = []
    
    init() {
        // 休憩通知を反映
        restViewFlag = UserDefaults.standard.bool(forKey: "restViewFlag")
        
        // 歩数計測とデータの更新を開始
        update()
    }
    
    // データ更新
    func update() {
        guard !isWalking else { return }
        isWalking = true
        
        motionManager.updateMotion { count, moisture, rest in
            DispatchQueue.main.async {
                // 歩数を受け取る
                self.steps = count
                
                // データの更新処理
                self.noticeArray = self.noticeManager.getNotice()
                self.recordArray = self.recordManager.getRecode()
                
                // 水分補給の通知
                if moisture {
                    // 通知をリクエスト
                    self.noticeManager.makeNotification(isMoisture: true)
                }
                // 休憩の通知
                if rest {
                    // 通知をリクエスト
                    self.noticeManager.makeNotification(isMoisture: false)
                    // 画面上の通知もONにする
                    self.restViewFlag = true
                    // View上に通知を表示
                    self.noticeManager.addNotice(title: "休憩することをおすすめします")
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
                    
                    // 記録する
                    self.recordManager.addRecord(content: "\(self.restTime)秒休憩しました")
                    print("記録しました")
                }
            }
        }
    }
}

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
    
    // 休憩する歩数(目安は6000、最低4000、最高8000)、Intに変換して使用する
    @Published var restStep: Double = 6000.0 {
        didSet {
            UserDefaults.standard.set(restStep, forKey: "restStep")
        }
    }
    
    // 水分補給する歩数(目安は1500、最低500、最高2000)、Intに変換して使用する
    @Published var moistureStep: Double = 1500.0 {
        didSet {
            UserDefaults.standard.set(moistureStep, forKey: "moistureStep")
        }
    }
    
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
    // 休憩秒数(目安は600秒、最短300秒、最長1200秒)、Intに変換して使用する
    @Published var restTime: Double = 600.0 {
        didSet {
            UserDefaults.standard.set(restTime, forKey: "restTime")
        }
    }
    // タイマーを作成
    private var timerHandler : Timer?
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
        
        // ユーザの設定を反映(初回起動時は保存されたデータが存在しないため、代入しない)
        if UserDefaults.standard.double(forKey: "restStep") != 0 {
            restStep = UserDefaults.standard.double(forKey: "restStep")
        }
        if UserDefaults.standard.double(forKey: "moistureStep") != 0 {
            moistureStep = UserDefaults.standard.double(forKey: "moistureStep")
        }
        if UserDefaults.standard.double(forKey: "restTime") != 0 {
            restTime = UserDefaults.standard.double(forKey: "restTime")
        }
        
        // 歩数計測とデータの更新を開始
        update()
    }
    
    // データ更新
    func update() {
        // クロージャを受け取り、繰り返す処理
        motionManager.updateMotion() { count, moisture, rest in
            DispatchQueue.main.async {
                // 休憩歩数と水分補給歩数を参照渡し
                self.motionManager.setSteps(restStep: &self.restStep, moistureStep: &self.moistureStep)
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
        
        //タイマーをスタート(1秒毎に, 繰り返す)
        timerHandler = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            _ in do {
                self.timerCount += 1
                print(self.timerCount)
                
                //タイマーを止める
                if Int(self.restTime) - self.timerCount <= 0 {
                    self.timerHandler?.invalidate()
                    // カウントリセット
                    self.timerCount = 0
                    // 画面上の通知をOFFにする
                    self.restViewFlag = false
                    // 休憩終了
                    self.isRest = false
                    
                    // 記録する
                    if Int(self.restTime) >= 60 {
                        if(Int(self.restTime) % 60) == 0 {
                            // 分のみで記録
                            self.recordManager.addRecord(content: "\(Int(self.restTime) / 60)分休憩しました")
                        } else {
                            // 分と秒で記録
                            self.recordManager.addRecord(content: "\(Int(self.restTime) / 60)分\(Int(self.restTime) % 60)秒休憩しました")
                        }
                    } else {
                        // 秒のみで記録
                        self.recordManager.addRecord(content: "\(Int(self.restTime))秒休憩しました")
                    }
                    print("記録しました")
                }
            }
        }
    }
    
    // テスト用に調整する
    func developermode() {
        // 休憩歩数を10歩にする
        self.restStep = 10.0
        // 水分補給歩数を5歩にする
        self.moistureStep = 5.0
        // 休憩時間をを5秒にする
        self.restTime = 5.0
    }
    
}

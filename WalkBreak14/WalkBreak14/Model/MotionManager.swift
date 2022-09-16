//
//  MotionManager.swift
//  WalkBreak14
//
//  Created by cmStudent on 2022/08/18.
//

import Foundation
import CoreMotion

final class MotionManager {
    // シングルトン
    static let shared: MotionManager = .init()
    
    // MARK: - CMMotionManager
    // CMMotionManager
    private let motion: CMMotionManager
    // 高頻度で取得した値をロストしないようにするキュー
    private let queue = OperationQueue()
    
    // MARK: - threshold
    // 閾値(デフォルト)
    private let threshold = 0.05
    // 動的な閾値
    private var nowThreshold = 0.05
    // 平滑にするための値
    private var smooth = 0.0
    
    // MARK: - count
    // カウントできるかどうか
    private var countFlag = true
    // カウント
    private var count = 0
    // 1カウントあたり削減する閾値
    private var rate = 0.01
    
    // MARK: - step
    // 歩数
    private var step: Int {
        didSet {
            UserDefaults.standard.set(step, forKey: "steps")
        }
    }
    // 休憩する歩数(目安は6000、最低4000、最高8000)、Intに変換して使用する
    private var restStep: Double = 6000.0
    
    // 水分補給する歩数(目安は1500、最低500、最高2000)、Intに変換して使用する
    private var moistureStep: Double = 1500.0
    // 歩数を更新した日付
    private var day: Int {
        didSet {
            UserDefaults.standard.set(day, forKey: "day")
        }
    }
    
    // MARK: - Notification
    // 水分通知
    private var moistureFlag = false
    // 休憩通知
    private var restFlag = false
    
    private init() {
        // モーションマネージャーを入れる
        motion = CMMotionManager()
        
        // 歩数の更新日にちを入れる
        day = UserDefaults.standard.integer(forKey: "day")
        
        if day == Calendar(identifier: .gregorian).component(.day, from: Date()) {
            // 日付が変わっていなかったら保存されている歩数を入れる
            step = UserDefaults.standard.integer(forKey: "steps")
        } else {
            // 日付が変わっていたら歩数をリセットする
            step = 0
        }
    }
    
    func updateMotion(handler: @escaping (Int, Bool, Bool) -> Void) {
        // ジャイロセンサーが使えない場合はこの先の処理を実行しない
        guard motion.isDeviceMotionAvailable else { return }
        // 更新間隔
        self.motion.deviceMotionUpdateInterval = 1.0 / 60.0
        // デバイスを動かすときに必要なもの
        self.motion.showsDeviceMovementDisplay = true
        
        // ジャイロセンサーを利用して取得した値をキューに入れる
        motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical, to: queue) { data, error in
            // dataとerrorはオプショナルなので確認してから処理をする
            if let validData = data {
                // 加速度を取得
                let x = validData.userAcceleration.x
                let y = validData.userAcceleration.y
                let z = validData.userAcceleration.z
                
                // 角度を取得し、度数にする
                let rollDeg = validData.attitude.roll * 180.0 / Double.pi
                let pitchDeg = validData.attitude.pitch * 180.0 / Double.pi
                
                // 計算(加速度(x, y, z), 角度(roll, pitch), 休憩歩数, 水分補給歩数)
                self.calcMotion(x: x, y: y, z: z, rollDeg: rollDeg, pitchDeg: pitchDeg)
                
                // 歩数と通知の判定を送る
                handler(self.step, self.moistureFlag, self.restFlag)
                
                // 通知の終了処理
                if self.moistureFlag {
                    self.moistureFlag = false
                }
                if self.restFlag {
                    self.restFlag = false
                }
            }
        }
    }
    
    private func calcMotion(x: Double, y: Double, z: Double, rollDeg: Double, pitchDeg: Double) {
        // 角度の正規化(rollのみで良い)
        var temp = rollDeg
        if rollDeg > 90.0 {
            temp = 90.0 - (rollDeg - 90.0)
        } else if rollDeg < -90.0 {
            temp = -90.0 - (rollDeg + 90.0)
        }
        
        let roll = temp / 90.0
        let pitch = pitchDeg / 90.0
        
        // 垂直成分の重みを計算
        let weightX = roll * (1.0 - fabs(pitch))
        let weightY = pitch * -1
        var weightZ = 1.0 - (fabs(weightX) + fabs(weightY))
        if !(fabs(rollDeg) > 90) {
            weightZ = weightZ * -1
        }
        
        // 加速度の垂直成分を計算
        let vertical = x * weightX + y * weightY + z * weightZ
        
        // 数値を平らにする
        smooth = vertical * 0.1 + smooth * 0.9
        
        // 歩数をカウント
        if smooth > nowThreshold && countFlag == true && count > 12 {
            countFlag = false
            count = 0
            // 歩数を+1する
            step += 1
            print("step!!!")
            
            // 日付が変わっていたら歩数をリセットする
            if day != Calendar(identifier: .gregorian).component(.day, from: Date()) {
                step = 1
            }
            
            // 歩数を更新した日にちを記録
            day = Calendar(identifier: .gregorian).component(.day, from: Date())
            
            // 指定した歩数ごとに水分補給の通知
            if step % Int(moistureStep) == 0 {
                moistureFlag = true
            }

            // 指定した歩数ごとに休憩の通知
            if step % Int(restStep) == 0 {
                restFlag = true
            }
            
        } else if smooth < 0.0 {
            countFlag = true
            
        }
        
        // 閾値を更新
        if smooth > nowThreshold {
            nowThreshold = smooth
            rate = (smooth - threshold) / 15.0
            
        } else if nowThreshold > threshold {
            nowThreshold -= rate
            
        } else {
            nowThreshold = threshold
        }
        
        count += 1
        
        
    }
    
    func setSteps(restStep: inout Double, moistureStep: inout Double) {
        self.restStep = restStep
        self.moistureStep = moistureStep
    }
    
    func stopMotion() {
        // 計測停止
        motion.stopDeviceMotionUpdates()
    }
}

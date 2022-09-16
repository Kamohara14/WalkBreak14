//
//  SettingView.swift
//  WalkBreak14
//
//  Created by cmStudent on 2022/08/25.
//

import SwiftUI

struct SettingView: View {
    // viewModel
    @ObservedObject var viewModel: WalkBreakViewModel
    
    // カスタマイズした戻る処理
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            
            Color.green.ignoresSafeArea(edges: .top)
            Color.white
            
            VStack {
                Spacer()
                Form {
                    
                    // 休憩時間の設定
                    Section {
                        // 300...1200(600)
                        Slider(value: $viewModel.restTime, in: 300...1200, step: 1,
                               minimumValueLabel: Text("5分"),
                               maximumValueLabel: Text("20分"),
                               label: { EmptyView() }
                        )
                        
                        // 秒数による表示変更
                        if Int(viewModel.restTime) >= 60 {
                            // 60秒以上
                            if Int(viewModel.restTime) % 60 == 0 {
                                // 割り切れるなら分数のみ表示
                                Text("\(Int(viewModel.restTime) / 60)分休憩")
                            } else {
                                // 割り切れないなら分数と秒数を表示
                                Text("\(Int(viewModel.restTime) / 60)分\(Int(viewModel.restTime) % 60)秒休憩")
                            }
                        } else {
                            // 60秒以下なら秒数のみ表示
                            Text("\(Int(viewModel.restTime))秒休憩")
                        }
                    } header: {
                        Text("休憩時間")
                    }
                    
                    // 休憩歩数の設定
                    Section {
                        // 4000...8000(6000)
                        Slider(value: $viewModel.restStep, in: 4000...8000, step: 1,
                               minimumValueLabel: Text("4000"),
                               maximumValueLabel: Text("8000"),
                               label: { EmptyView() }
                        )
                        
                        Text("\(Int(viewModel.restStep))歩で休憩")
                    } header: {
                        Text("休憩する歩数")
                    }
                    
                    // 水分補給歩数の設定
                    Section {
                        // 500...2000(1500)
                        Slider(value: $viewModel.moistureStep, in: 500...2000, step: 1,
                               minimumValueLabel: Text("500"),
                               maximumValueLabel: Text("2000"),
                               label: { EmptyView() }
                        )
                        
                        Text("\(Int(viewModel.moistureStep))歩で水分補給")
                    } header: {
                        Text("水分補給する歩数")
                    }
                    
                } // Form
                
                // 開発者用の調整
                HStack {
                    
                    Spacer()
                    
                    Button {
                        viewModel.developermode()
                    } label: {
                        Text("確認用")
                            .padding()
                    } // Button
                } // HS
            } // VS
        } // ZS
        .navigationBarBackButtonHidden(true)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button{
                                // 戻る
                                dismiss()
                                
                            } label: {
                                HStack {
                                    Image(systemName: "chevron.backward")
                                        .font(.system(size: 17, weight: .medium))
                                    Text("ホームへ")
                                }
                                .foregroundColor(.white)
                            }
                        }
                    }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(viewModel: WalkBreakViewModel())
    }
}

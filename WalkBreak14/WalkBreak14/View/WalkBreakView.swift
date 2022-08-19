//
//  WalkBreakView.swift
//  WalkBreak14
//
//  Created by cmStudent on 2022/08/16.
//

import SwiftUI

struct WalkBreakView: View {
    
    // TabView変更用のイニシャライザ
    init(){
        // TabViewの背景色の設定（緑色）
        UITabBar.appearance().backgroundColor = .systemGreen
        // 非選択のタブ
        UITabBar.appearance().unselectedItemTintColor = .white
        
    }
    
    var body: some View {
        VStack {
            WalkBreakHeader()
            
            TabView {
                HomeView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("ホーム")
                    }
                
                RecordView()
                    .tabItem {
                        Image(systemName: "list.bullet")
                        Text("記録")
                    }
                
                ManualView()
                    .tabItem {
                        Image(systemName: "lightbulb")
                        Text("休憩マニュアル")
                    }
                
            }
            .accentColor(.blue)
        }
    }
}

// ヘッダー
struct WalkBreakHeader: View {
    // View
    private let view = WalkBreakView()
    
    var body: some View {
        VStack {
            HStack {
                // タイトル
                Text("ぶれいくたいむ")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                
                Spacer()
                
                HStack {
                    // 通知ボタン
                    Button {
                        
                    } label: {
                        Circle()
                            .fill(Color(red: 0.9, green: 0.9, blue: 0.9))
                            .frame(width: 40, height: 40)
                            .overlay(
                                Image(systemName: "bell")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(.green)
                            )
                    }
                    .padding(3)
                    
                    // 設定ボタン
                    Button {
                        
                    } label: {
                        Circle()
                            .fill(Color(red: 0.9, green: 0.9, blue: 0.9))
                            .frame(width: 40, height: 40)
                            .overlay(
                                Image(systemName: "text.justify")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(.green)
                            )
                    }
                    .padding(3)
                    
                } // HS
                .padding(.trailing, 5)
            } // HS
            
        } // VS
        .background(.green)
    }
}


struct WalkBreakView_Previews: PreviewProvider {
    static var previews: some View {
        WalkBreakView()
    }
}

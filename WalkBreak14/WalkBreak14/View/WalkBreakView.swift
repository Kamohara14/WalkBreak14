//
//  WalkBreakView.swift
//  WalkBreak14
//
//  Created by cmStudent on 2022/08/16.
//

import SwiftUI

struct WalkBreakView: View {
    
    // View変更用のイニシャライザ
    init() {
        // NavigationView
        // 背景の色
        UINavigationBar.appearance().backgroundColor = .systemGreen
        // backの色
        UINavigationBar.appearance().tintColor = .white
        
        // TabView
        // 背景色の設定（緑色）
        UITabBar.appearance().backgroundColor = .systemGray6
        // 非選択のタブ
        UITabBar.appearance().unselectedItemTintColor = .systemGray2
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                
                VStack {
                    footerView()
                } // VS
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    // タイトル
                    ToolbarItem(placement: .navigationBarLeading){
                        Text("ぶれいくたいむ")
                            .foregroundColor(.white)
                            .fontWeight(.black)
                            .font(.title)
                    }
                    
                    
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        // 通知ボタン
                        Button {
                            
                        } label: {
                            NavigationLink(destination: NoticeView()) {
                                Image(systemName: "bell.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height:30)
                                    .foregroundColor(.white)
                            }
                        }
                        
                        // 設定ボタン
                        Button {
                            
                        } label: {
                            NavigationLink(destination: SettingView()) {
                                Image(systemName: "gearshape.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(10)
                    } // ItemGroup
                    
                } // ToolBar
                .background(Color.green)
            } // ZS
        } // Nav
    } // body
}



struct WalkBreakView_Previews: PreviewProvider {
    static var previews: some View {
        WalkBreakView()
    }
}

struct footerView: View {
    var body: some View {
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
            
        } // Tab
        .accentColor(.green)
    }
} // footer


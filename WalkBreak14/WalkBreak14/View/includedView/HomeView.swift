//
//  HomeView.swift
//  WalkBreak14
//
//  Created by cmStudent on 2022/08/16.
//

import SwiftUI

struct HomeView: View {
    // viewModel
    @StateObject var viewModel: WalkBreakViewModel
    
    var body: some View {
        ZStack {
            
            Color.green.ignoresSafeArea(edges: .top)
            Color.white
            
            VStack {
                
                Spacer()
                
                // 通知
                if viewModel.restViewFlag {
                    restNotificationView()
                }
                
                Spacer()
                
                // 休憩時間
                VStack {
                    HStack {
                        Text("休憩時間残り")
                        Spacer()
                    }
                    .padding()
                    
                    if viewModel.restViewFlag {
                        Text("\(viewModel.restTime - viewModel.timerCount)秒")
                            .font(.largeTitle)
                            .padding(.bottom, 50)
                    } else {
                        Text("休憩完了")
                            .font(.largeTitle)
                            .padding(.bottom, 50)
                    }
                    
                }
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 0.95, green: 0.95, blue: 0.95))
                )
                .padding()
                
                // 休憩開始
                if viewModel.restViewFlag {
                    Button {
                        viewModel.startRest()
                    } label: {
                        Text(" --- 休憩開始 --- ")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.green)
                    )
                    .disabled(viewModel.isRest)
                    
                }
                
                Spacer()
                Text("歩数：\(viewModel.steps)")
                Spacer()
            } // VS
        } // ZS
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: WalkBreakViewModel())
    }
}


struct restNotificationView: View {
    var body: some View {
        HStack {
            Image(systemName: "circle.fill")
                .scaledToFit()
                .foregroundColor(.red)
            
            Text("休憩をとって下さい")
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 0.9, green: 0.9, blue: 0.9))
        )
    }
}

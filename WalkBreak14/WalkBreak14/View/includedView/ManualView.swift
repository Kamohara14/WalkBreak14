//
//  ManualView.swift
//  WalkBreak14
//
//  Created by cmStudent on 2022/08/16.
//

import SwiftUI

struct ManualView: View {
    var body: some View {
        ZStack {
            
            Color.green.ignoresSafeArea(edges: .top)
            Color.white
            
            VStack {
                
                RestView()
                    .padding(8)
                
                HydrationView()
                    .padding(8)
                
                ConditionView()
                    .padding(8)
                
            }
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color(red: 0.4, green: 0.6, blue: 1.0))
            )
            .padding()
        } // VS
    } // ZS
    
    struct ManualView_Previews: PreviewProvider {
        static var previews: some View {
            ManualView()
        }
    }
}

// 休憩時間について
struct RestView: View {
    var body: some View {
        HStack {
            Text("1回の休憩時間は\n5分~10分が目安です")
                .padding()
            
            Image(systemName: "figure.walk")
                .resizable()
                .scaledToFit()
                .foregroundColor(.green)
                .frame(maxWidth: 50)
                .padding()
            
            
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color(red: 0.6, green: 0.8, blue: 1.0))
        )
    }
}

// 水分補給について
struct HydrationView: View {
    var body: some View {
        HStack {
            Image(systemName: "drop.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.blue)
                .frame(maxWidth: 50)
                .padding()
            
            Text("200ml~250ml前後の\n水分を摂取しましょう")
                .padding()
            
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color(red: 0.6, green: 0.8, blue: 1.0))
        )
    }
}

// 体調が悪い時は
struct ConditionView: View {
    var body: some View {
        VStack {
            Text("体調が良くない時は...\n水分や塩分の補給を行い安静にしましょう。その際、飲み物は少しずつ飲むようにしましょう。熱中症の疑いがある場合は、上記のに加え、涼しい場所で休憩を行い保冷剤や濡れたタオルなどで 脇の下や太もものつけねを冷やしてください")
                .padding()
            
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color(red: 0.6, green: 0.8, blue: 1.0))
        )
    }
}

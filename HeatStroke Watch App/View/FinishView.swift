//
//  FinishView.swift
//  HeatStroke
//
//  Created by Vannya Ade Gunawan on 06/07/26.
//

import SwiftUI

struct FinishView: View {
    
    let runner: Runner
    let elapsedSeconds: Int
    @State private var viewModel = FinishViewModel()
    
    var body: some View {
        let content = viewModel.content
        
        ScrollView {
            VStack (spacing: 10) {
                ZStack {
                    Circle()
                        .frame(width: 90, height: 90)
                        .foregroundColor(content.circleBackground)
                    Image(systemName: content.iconName)
                        .font(.system(size: 42))
                        .foregroundStyle(content.iconColor)
                }
                VStack(spacing: 0) {
                    Text(content.title)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(.white)
                    Text("BTN JAKIM 2027")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(content.subtitleColor)
                }
                VStack(spacing: 5) {
                    HStack (spacing: 5) {
                        VStack(alignment: .center) {
                            Text("Finish Time")
                                .font(.system(size: 11, weight: .regular))
                                .foregroundColor(.gray)
                            
                            Text(content.finishTime)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.checkmarkBgcolor)
                        }
                        .frame(width: 75, height: 40)
                        .background(Color.signalcard)
                        .cornerRadius(7)
                        
                        VStack(alignment: .center) {
                            Text("Avg zone")
                                .font(.system(size: 11, weight: .regular))
                                .foregroundColor(.gray)
                            
                            Text(content.avgZone)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.checkmarkBgcolor)
                        }
                        .frame(width: 75, height: 40)
                        .background(Color.signalcard)
                        .cornerRadius(7)
                        
                    }
                    Text(content.message)
                        .font(.system(size: 10, weight: .regular))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(content.messageColor)
                        .padding(.horizontal, 8)
                        .padding(.bottom, 4)
                    
                    Button {
                        NotificationCenter.default.post(name: .goHome, object: nil)
                    } label: {
                        Text("Confirm")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .frame(width: 168, height: 52)
                    .buttonStyle(.borderedProminent)
                    .tint(content.buttonTint)
                    
                }
            }
        }
        .task {
            await viewModel.fetchFinishData(runner: runner, elapsedSeconds: elapsedSeconds)
        }
    }
}

//#Preview {
//    FinishView()
//}


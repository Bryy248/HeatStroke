//
//  FinishView.swift
//  HeatStroke
//
//  Created by Vannya Ade Gunawan on 06/07/26.
//

import SwiftUI

struct FinishView: View {
    
    //enum -> pindahkan di viewmodel
    enum FinishType {
        case finish
        case finishwithalert
        case stopearly
    }
    
    @State var FinishState: FinishType = .stopearly
    
    var body: some View {
        ScrollView {
            if FinishState == .finish {
                VStack(spacing: 10) {
                    VStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .frame(width: 90, height: 90)
                                .foregroundColor(.inputBgcolor)
                            Image(systemName: "trophy.fill")
                                .font(.system(size: 42))
                                .foregroundStyle(.color1)
                        }
                        VStack(spacing: 0) {
                            Text("You did it!")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundStyle(.white)
                            Text("BTN JAKIM 2027")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.color1)
                        }
                    }
                    
                    VStack(spacing: 5) {
                        HStack (spacing: 5) {
                            VStack(alignment: .center) {
                                Text("Finish time")
                                    .font(.system(size: 11, weight: .regular))
                                    .foregroundColor(.gray)
                                
                                Text("2:30:08") //placeholder
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.checkmarkBgcolor)
                            }
                            .frame(width: 75, height: 40)
                            .background(Color.inputBgcolor)
                            .cornerRadius(7)
                            
                            VStack(alignment: .center) {
                                Text("Avg HR")
                                    .font(.system(size: 11, weight: .regular))
                                    .foregroundColor(.gray)
                                
                                Text("156") //placeholder
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.checkmarkBgcolor)
                            }
                            .frame(width: 75, height: 40)
                            .background(Color.inputBgcolor)
                            .cornerRadius(7)
                            
                        }
                        Text("Stayed safe the whole race!")
                            .font(.system(size: 10, weight: .regular))
                            .foregroundStyle(.color1)
                    }
                    
                    Button {
                        // Aksi Button akan kembali ke page awal
                    } label: {
                        Text("Confirm")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .frame(width: 168, height: 52)
                    .buttonStyle(.borderedProminent)
                    .tint(.color1)
                }
            } else if FinishState == .finishwithalert {
                
                VStack(spacing: 10) {
                    VStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .frame(width: 90, height: 90)
                                .foregroundColor(.inputBgcolor)
                            Image(systemName: "trophy.fill")
                                .font(.system(size: 42))
                                .foregroundStyle(.color1)
                        }
                        VStack(spacing: 0) {
                            Text("You did it!")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundStyle(.white)
                            Text("BTN JAKIM 2027")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.color1)
                        }
                    }
                    
                    VStack(spacing: 5) {
                        HStack (spacing: 5) {
                            VStack(alignment: .center) {
                                Text("Finish time")
                                    .font(.system(size: 11, weight: .regular))
                                    .foregroundColor(.gray)
                                
                                Text("2:30:08") //placeholder
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.checkmarkBgcolor)
                            }
                            .frame(width: 75, height: 40)
                            .background(Color.inputBgcolor)
                            .cornerRadius(7)
                            
                            VStack(alignment: .center) {
                                Text("Risk Hits")
                                    .font(.system(size: 11, weight: .regular))
                                    .foregroundColor(.gray)
                                
                                Text("2x") //placeholder
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.checkmarkBgcolor)
                            }
                            .frame(width: 75, height: 40)
                            .background(Color.inputBgcolor)
                            .cornerRadius(7)
                            
                        }
                        Text("Made it, but heat risk rose twice. Rest and hydrate well.")
                            .font(.system(size: 10, weight: .regular))
                            .foregroundStyle(.yellow)
                            .multilineTextAlignment(.center)
                    }
                    
                    Button {
                        // Aksi Button akan kembali ke page awal
                    } label: {
                        Text("Confirm")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .frame(width: 168, height: 52)
                    .buttonStyle(.borderedProminent)
                    .tint(.color1)
                }
            } else if FinishState == .stopearly {
                
                VStack(spacing: 10) {
                    VStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .frame(width: 90, height: 90)
                                .foregroundColor(.finish)
                            Image(systemName: "square")
                                .font(.system(size: 42))
                                .foregroundStyle(.red)
                        }
                        VStack(spacing: 0) {
                            Text("Stopped early")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundStyle(.white)
                            Text("BTN JAKIM 2027")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.red)
                        }
                    }
                    
                    VStack(spacing: 5) {
                        HStack (spacing: 5) {
                            VStack(alignment: .center) {
                                Text("Distance")
                                    .font(.system(size: 11, weight: .regular))
                                    .foregroundColor(.gray)
                                
                                Text("14.4 KM") //placeholder
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.checkmarkBgcolor)
                            }
                            .frame(width: 75, height: 40)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(7)
                            
                            VStack(alignment: .center) {
                                Text("Risk Hits")
                                    .font(.system(size: 11, weight: .regular))
                                    .foregroundColor(.gray)
                                
                                Text("Danger") //placeholder
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.checkmarkBgcolor)
                            }
                            .frame(width: 75, height: 40)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(7)
                            
                        }
                        Text("Good call stopping. Rest, hydrate, see medical if needed.")
                            .font(.system(size: 10, weight: .regular))
                            .foregroundStyle(.red)
                            .multilineTextAlignment(.center)
                    }
                    
                    Button {
                        // Aksi Button akan kembali ke page awal
                    } label: {
                        Text("Confirm")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .frame(width: 168, height: 52)
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                }
            }
        }
    }
}

#Preview {
    FinishView()
}


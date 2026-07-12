//
//  EmergencyView.swift
//  HeatStroke
//
//  Created by Vannya Ade Gunawan on 07/07/26.
//

import SwiftUI

struct EmergencyView: View {
    
    var viewModel: RunningViewModel
    
    var body: some View {
        VStack(spacing: 18) {
            VStack{
                Image(systemName: "sensor.radiowaves.left.and.right.fill")
                    .font(.system(size: 48, weight: .medium))
                    .foregroundColor(.red)
                
                Text("Sending Help")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.red)
                
                Text("Live location shared")
                    .font(.system(size: 12, weight: .light))
                    .foregroundColor(.white)

            }
            
            Button {
                viewModel.resolveEmergency()
            } label: {
                Text("I'm okay now")
                    .font(.system(size: 14, weight: .semibold))
            }
            .frame(width: 168, height: 52)
            .buttonStyle(.borderedProminent)
            .tint(.color1)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}

#Preview {
    EmergencyView(viewModel: RunningViewModel())
}

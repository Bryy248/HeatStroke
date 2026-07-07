//
//  EventRowView.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 06/07/26.
//

import SwiftUI
 
struct EventRowView: View {
    let event: Event
    let runner: Runner
 
    var body: some View {
        VStack(alignment: .leading) {
            Text(event.name)
                .font(.system(size: 14, weight: .semibold))
 
            HStack {
                Text("BIB:")
                    .fontWeight(.light)
                Text(runner.bibNumber)
                    .fontWeight(.medium)
            }
            .font(.system(size: 12))
 
//            Text(event.formattedDate)
//                .font(.system(size: 12, weight: .light))
        }
        .listRowInsets(EdgeInsets(top: 11, leading: 11, bottom: 11, trailing: 11))
    }
}
 
//#Preview {
//    List {
//        EventRowView(
//            event: Events(name: "BTN JAKIM 2027", bib: "M12345", date: .now)
//        )
//    }
//}

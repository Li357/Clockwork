//
//  TimesheetView.swift
//  Clockwork
//
//  Created by Andrew Li on 1/4/22.
//

import SwiftUI

struct DayEntry: View {
    var entry: EntryWithId
    var body: some View {
        HStack {
            Text(entry.date.formatted(date: .numeric, time: .omitted))
            Spacer()
            Text(formatDuration(entry.duration))
            Button(role: .destructive, action: removeEntry) {
                Image(systemName: "trash.fill")
            }
            .buttonStyle(.borderless)
        }
    }
    
    private func formatDuration(_ duration: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .full
        return formatter.string(from: TimeInterval(duration))!
    }
    
    private func removeEntry() {
        // TODO
    }
}

struct TimesheetView: View {
    var entries: [EntryWithId]
    var header: some View {
        HStack {
            Text("Date").bold()
            Spacer()
            Text("Duration").bold()
        }
    }
    
    var body: some View {
        
        List {
            Section(header: header) {
                ForEach(entries.indices) { index in
                    DayEntry(entry: self.entries[index])
                    Divider()
                }
            }
        }
    }
}

struct TimesheetView_Previews: PreviewProvider {
    static var previews: some View {
        TimesheetView(entries: [EntryWithId(id: 0, date: Date(), duration: 280)])
    }
}

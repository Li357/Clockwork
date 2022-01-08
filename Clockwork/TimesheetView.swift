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
        }
    }
}

struct TimesheetView: View {
    var entries: [EntryWithId]
    var body: some View {
        List(entries, id: \.id) { entry in
            DayEntry(entry: entry)
        }
    }
}

struct TimesheetView_Previews: PreviewProvider {
    static var previews: some View {
        TimesheetView(entries: [])
    }
}

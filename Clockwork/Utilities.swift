//
//  Utils.swift
//  Clockwork
//
//  Created by Andrew Li on 1/4/22.
//

func zeroPad(_ seconds: Int) -> String {
    return String(format: "%02d", seconds)
}

func convertToTimeString(_ seconds: Int) -> String {
    guard seconds > 60 else {
        return "00:\(zeroPad(seconds))"
    }
    
    let reducedSeconds = seconds % 60
    let minutes = (seconds - reducedSeconds) / 60
    guard minutes > 60 else {
        return "\(minutes):\(zeroPad(reducedSeconds))"
    }
    
    let reducedMinutes = minutes % 60
    let hours = (minutes - reducedMinutes) / 60
    return "\(hours):\(zeroPad(reducedMinutes)):\(zeroPad(reducedSeconds))"
}

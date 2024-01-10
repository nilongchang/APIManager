//
//  DateTool.swift
//  JianxiaozhiAI
//
//  Created by Jie on 2021/6/22.
//  Copyright © 2021 Jie. All rights reserved.
//

import UIKit

public class DateTool: NSObject {
    // caches
    private var cachedDateFormatters: [String: DateFormatter] = [:]
    // instance
    static let share: DateTool = {
        let manager = DateTool()
        return manager
    }()
    
    // get or create one DateFormatter
    func dateFormatter(withFormat format: String) -> DateFormatter {
        if let formatter = cachedDateFormatters[format] {
            return formatter
        }
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = format
        cachedDateFormatters[format] = newFormatter
        return newFormatter
    }
    
    // MARK: - Base ----------------------------
    // 当前日期
    static var currentDate: Date {
        return Date()
    }
    
    // 当前日期的时间戳
    static var currentTimeInterval: TimeInterval {
        return Date().timeIntervalSince1970
    }
    
    // MARK: - NSDate, NSString , 时间戳的转换 ----------------------------
    /*--------- To Date ---------*/
    // 字符串时间 --> 转Date (如："2020/4/14 11:7:43" -> Date
    static func dateFrom(stringDate: String, forrmat: String) -> Date? {
        let formatter = DateTool.share.dateFormatter(withFormat: forrmat)
        return formatter.date(from: stringDate)
    }
    
    // 时间戳 --> Date (如：1586833663 -> Date
    static func dateForm(timeInterval: TimeInterval) -> Date {
        return Date(timeIntervalSince1970: timeInterval)
    }
    
    /*--------- To String ---------*/
    // Date --> 转字符串时间 (如：Date对象 -> "2020/4/14 11:7:43"
    static func stringForm(date: Date, forrmat: String) -> String {
        let formatter = DateTool.share.dateFormatter(withFormat: forrmat)
        return formatter.string(from: date)
    }
    
    // TimeInterval --> 转字符串时间 (如：1624344850 -> "2020/4/14 11:7:43"
    static func stringForm(timeInterval: TimeInterval, forrmat: String) -> String {
        let formatter = DateTool.share.dateFormatter(withFormat: forrmat)
        let date = DateTool.dateForm(timeInterval: timeInterval)
        return formatter.string(from: date)
    }
    
    /*--------- To TimeInterval ---------*/
    // Date --> 转TimeInterval (如：Date对象 -> 1624344850
    static func timeIntervalForm(date: Date) -> TimeInterval {
        return date.timeIntervalSince1970
    }
    
    // 字符串 --> 转TimeInterval (如："2020/4/14 11:7:43" -> 1624344850
    static func timeIntervalForm(stringDate: String,forrmat: String? = "yyyy-MM-dd HH:mm:ss") -> TimeInterval {
        if let date = DateTool.dateFrom(stringDate: stringDate, forrmat: forrmat!) {
            return date.timeIntervalSince1970
        }
        return 0
    }
    
    /// 时长字符串转秒
    /// - Parameter audioText: "00:01:41"
    /// - Returns: 101
    static func audioToInt(with audioText: String?) -> TimeInterval {
        guard let text = audioText else { return 1 }
        let array = text.components(separatedBy: ":")
        let hourText = array.first ?? "0"
        let hour = Int(hourText) ?? 0
        let minuteText = array[safe: 1] ?? "0"
        let minute = Int(minuteText) ?? 0
        let secondText = array.last ?? "0"
        let second = Int(secondText) ?? 0
        return (Double(hour) * 3600.0) + (Double(minute) * 60.0) + Double(second)
    }
    
    /// 秒转时长字符串
    /// - Parameter audioText: 101
    /// - Returns: "01:41"
    static func durationToString(with time: Int?) -> String {
        let audioTime = time ?? 0
        if audioTime <= 0 {
            return "00:00"
        }
        
        let hours = audioTime/3600
        let minutes = (audioTime-hours*3600)/60
        let seconds = (audioTime-hours*3600-minutes*60)
        
        // 分
        var minuteText = ""
        if minutes > 9 {
            minuteText = "\(minutes)"
        }else {
            minuteText = "0\(minutes)"
        }
        // 秒
        var secondsText = ""
        if seconds > 9 {
            secondsText = "\(seconds)"
        }else {
            secondsText = "0\(seconds)"
        }
        return "\(minuteText):\(secondsText)"
    }
    
    /// 时间分隔显示
    /// - Parameter time: 时间戳
    /// - Returns: (hour,minute,seconds)
    static func formatTimeText(with time: Int) -> (hour: String, minute: String, second: String) {
        let hours = time/3600
        let minutes = (time-hours*3600)/60
        let seconds = (time-hours*3600-minutes*60)
        // 时
        var hourText = ""
        if hours > 9 {
            hourText = "\(hours)"
        }else {
            hourText = "0\(hours)"
        }
        // 分
        var minuteText = ""
        if minutes > 9 {
            minuteText = "\(minutes)"
        }else {
            minuteText = "0\(minutes)"
        }
        // 秒
        var secondsText = ""
        if seconds > 9 {
            secondsText = "\(seconds)"
        }else {
            secondsText = "0\(seconds)"
        }
        return (hourText,minuteText,secondsText)
    }
}

//
//  NSDate+Extension.swift
//  ZJCustomCalendar
//
//  Created by 张江 on 2018/11/21.
//  Copyright © 2018 张江. All rights reserved.
//

import Foundation

extension Date {
    
    /// 年
    var year:Int?{
        get{
            return self.convertDate().year
        }
    }
    /// 月
    var month:Int?{
        get{
            return self.convertDate().month
        }
    }
    /// 日
    var day:Int?{
        get{
            return self.convertDate().day
        }
    }
    /// 时
    var hour:Int?{
        get{
            return self.convertDate().hour
        }
    }
    /// 分
    var minute:Int?{
        get{
            return self.convertDate().minute
        }
    }
    /// 秒
    var second:Int?{
        get{
            return self.convertDate().second
        }
    }
    
    /// 格式化s日期
    ///
    /// - Parameter format: 字符串格式 默认是yyyy-MM-dd HH:mm:ss
    /// - Returns: 返回日期时间字符串
    func stringWithFormat(_ format:String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func convertDate() -> DateComponents {
        return Calendar.current.dateComponents([Calendar.Component.year,
                                                Calendar.Component.month,
                                                Calendar.Component.day,
                                                Calendar.Component.hour,
                                                Calendar.Component.minute,
                                                Calendar.Component.second,
                                                Calendar.Component.weekday], from: self)
    }
    
    
}

/// 比较日期是否是小于等于
func <=(lhs: Date, rhs: Date) -> Bool {
    return lhs.timeIntervalSince1970 <= rhs.timeIntervalSince1970
}
/// 比较日期是否是大于等于
func >=(lhs: Date, rhs: Date) -> Bool {
    return lhs.timeIntervalSince1970 >= rhs.timeIntervalSince1970
}
/// 比较日期是否是大于
func >(lhs: Date, rhs: Date) -> Bool {
    return lhs.timeIntervalSince1970 > rhs.timeIntervalSince1970
}
/// 比较日期是否是小于
func <(lhs: Date, rhs: Date) -> Bool {
    return lhs.timeIntervalSince1970 < rhs.timeIntervalSince1970
}


///  日期加一段时间，单位秒
func +(lhs: Date, rhs: TimeInterval) -> Date {
    return Date(timeInterval: rhs, since:lhs)
}
///  日期减一段时间，单位秒
func -(lhs: Date, rhs: TimeInterval) -> Date {
    return Date(timeInterval: -rhs, since:lhs)
}
///  日期加一段时间，单位秒
func +(lhs: TimeInterval, rhs: Date) -> Date {
    return Date(timeInterval: lhs, since:rhs)
}
///  日期减一段时间，单位秒
func -(lhs: TimeInterval, rhs: Date) -> Date {
    return Date(timeInterval: -lhs, since:rhs)
}

/// 日期加一段时间，单位秒
func +=( lhs: inout Date, rhs: TimeInterval) {
    return lhs = Date(timeInterval: rhs, since:lhs)
}
///  日期减一段时间，单位秒
func -=( lhs: inout Date, rhs: TimeInterval) {
    return lhs = Date(timeInterval: -rhs, since:lhs)
}

extension Date {}


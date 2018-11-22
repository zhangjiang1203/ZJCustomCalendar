//
//  ZJCalendarTools.swift
//  ZJCustomCalendar
//
//  Created by 张江 on 2018/11/21.
//  Copyright © 2018 张江. All rights reserved.
//

import UIKit

class ZJCalendarTools: NSObject {
    fileprivate lazy var calendar:Calendar? = {
        var tempCalendar = Calendar(identifier: .gregorian)
        tempCalendar.timeZone = NSTimeZone.system
        return tempCalendar
    }()
    
    fileprivate lazy var formatter:DateFormatter? = {
        let tempFor = DateFormatter()
        tempFor.timeZone = NSTimeZone.system
        tempFor.dateFormat = "yyyy-MM-dd"
        return tempFor
    }()
    
    override init() {
        super.init()
    }
    
    /// 获取当前日期的天数
    ///
    /// - Parameter date: 返回当月的天数
    open func getNumberOfDaysInMonth(_ date:Date) -> Int {
        let range = self.calendar?.range(of: .day, in: .month, for: date)
        return (range?.count)!
    }
    
    /// 获取日期当天周几
    ///
    /// - Parameter date: 传入的日期
    /// - Returns: 返回周几
    open func getWeekdayWithDate(_ date:Date) -> Int{
        let comp = self.calendar?.component(.weekday, from: date)
        ///1 周日 2 周一 3 周二 一次类推 1-7 改为 0-6方便计算
        return comp! - 1
    }
    
    
    /// 根据date获取指定偏移天数的date
    ///
    /// - Parameters:
    ///   - date: 指定的日期
    ///   - offSetDays: 偏移的天数 负数向前 正数向后
    /// - Returns: 返回偏移后的日期
    open func getDateFrom(_ date:Date,offSetDays:Int) ->Date{
        var lastMonthComps = DateComponents()
        lastMonthComps.day = offSetDays
        return (self.calendar?.date(byAdding: lastMonthComps, to: date))!
    }
    
    /// 根据date获取指定偏移月数的date
    ///
    /// - Parameters:
    ///   - date: 指定的日期
    ///   - offSetDays: 偏移的月数 负数向前 正数向后
    /// - Returns: 返回偏移后的日期
    open func getDateFrom(_ date:Date,offSetMonths:Int) ->Date{
        
        var lastMonthComps = DateComponents()
        lastMonthComps.month = offSetMonths
        return (self.calendar?.date(byAdding: lastMonthComps, to: date))!
    }
    
    /// 根据date获取指定偏移年数的date
    ///
    /// - Parameters:
    ///   - date: 指定的日期
    ///   - offSetDays: 偏移的年数 负数向前 正数向后
    /// - Returns: 返回偏移后的日期
    open func getDateFrom(_ date:Date,offSetYears:Int) ->Date{
        
        var lastMonthComps = DateComponents()
        lastMonthComps.year = offSetYears
        return (self.calendar?.date(byAdding: lastMonthComps, to: date))!
    }
    
    
    /// 获取每月的第一天周几
    ///
    /// - Parameter date: 传入日期
    /// - Returns: 返回这个月第一天周几
    func convertDateToFirstWeek(_ date:Date) -> Int {
        let firstDayOfMonthDate = getFirstDayOfMonth(date)
        let firstWeekday = getWeekdayWithDate(firstDayOfMonthDate)
        return firstWeekday
    }
    
    
    /// 根据传入的日期获取日期中月份的第一天
    ///
    /// - Parameter date: 日期
    /// - Returns: 返回第一天的日期
    func getFirstDayOfMonth(_ date:Date) -> Date {
        self.calendar?.firstWeekday = 1
        var comp = self.calendar?.dateComponents([Calendar.Component.year,Calendar.Component.month,Calendar.Component.day,Calendar.Component.hour,Calendar.Component.minute,Calendar.Component.second,Calendar.Component.weekday], from: date)
        comp?.day = 1
        let firstDayOfMonthDate = self.calendar?.date(from: comp!)
        return firstDayOfMonthDate!

    }
    
    /// 根据q日期返回这一个月的日期
    ///
    /// - Parameter date: 传入的日期
    /// - Returns: 返回的这个月的日期
    func getAllMonthDays(_ date:Date) -> [ZJCalendarModel] {
        //本月总天数
        let currentMonthDays = getNumberOfDaysInMonth(date)
        //本月第一天周几
        let firstWeekDay = convertDateToFirstWeek(date)
        //本月的第一天
        let firstDay = getFirstDayOfMonth(date)
        
        //上个月的同一天日期
        let lastMonthDate = getDateFrom(date, offSetMonths: -1)
        //上个月的天数
        let lastMonthDays = getNumberOfDaysInMonth(lastMonthDate)
        //这个月要保留几天上个月的位置
        
        var rang = [Int]()
        if firstWeekDay != 0{
            rang = Array((lastMonthDays-firstWeekDay+1)...lastMonthDays)
        }
        
        //日期固定为42个，一共要添加多少按着下面的计算
        var timeArr = [Date]()
        //获取上月要显示的日期
        if rang.count > 0 {
            for i in 1...rang.count {
                let tempDate = getDateFrom(firstDay, offSetDays: -i)
                timeArr.insert(tempDate, at: 0)
            }
        }
        //获取本月的所有日期
        for i in 0..<currentMonthDays{
            let tempDate = getDateFrom(firstDay, offSetDays: i)
            timeArr.append(tempDate)
        }
        
        //下个月的日期,默认展示42个方格，6*7
        let futureDays = 42 - (rang.count + currentMonthDays)
        let futureFirstDate = timeArr.last!
        for i in 1...futureDays{
            let tempDate = getDateFrom(futureFirstDate, offSetDays: i)
            timeArr.append(tempDate)
        }
        //获取的数据，模型转化
        var modelArr = [ZJCalendarModel]()
        for time in timeArr {
            var model = ZJCalendarModel()
            model.date = time
            model.dateStr = time.stringWithFormat()
            model.year = time.year!
            model.month = time.month!
            model.day = time.day!
            //判断是否是当天
            if calendar!.isDate(time, inSameDayAs: Date()){
                model.isToday = true
            }
            //是否是本月
            model.isCurrentMonth = model.month == date.month!
            modelArr.append(model)
        }
        return modelArr
    }
}

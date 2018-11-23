//
//  ViewController.swift
//  ZJCustomCalendar
//
//  Created by 张江 on 2018/11/21.
//  Copyright © 2018 张江. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let calendarView = ZJCustomCalendar.init(frame: .zero)
        calendarView.minDate = ZJCalendarTools().getDateFrom(Date(), offSetMonths: -5)
        calendarView.maxDate = ZJCalendarTools().getDateFrom(Date(), offSetDays: 20)
        calendarView.selectedBlcok = { model in
            print("选中的日期===\(model.dateStr)")
        }
        self.view.addSubview(calendarView)
        
        calendarView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(80)
            make.height.equalTo(340)
        }
    }
    
    func getAllMonthDays(_ date:Date = Date())  {
        let calendar = ZJCalendarTools()
        let date = Date()
        //本月总天数
        let currentMonthDays = calendar.getNumberOfDaysInMonth(date)
        //本月第一天周几
        let firstWeekDay = calendar.convertDateToFirstWeek(date)
        //本月的第一天
        let firstDay = calendar.getFirstDayOfMonth(date)
        
        //上个月的同一天日期
        let lastMonthDate = calendar.getDateFrom(date, offSetMonths: -1)
        //上个月的天数
        let lastMonthDays = calendar.getNumberOfDaysInMonth(lastMonthDate)
        //这个月要保留几天上个月的位置
        let rang = Array((lastMonthDays-firstWeekDay+1)...lastMonthDays)
        
        //日期固定为42个，一共要添加多少按着下面的计算
        var timeArr = [Date]()
        //获取上月要显示的日期
        for i in 1...rang.count {
            let tempDate = calendar.getDateFrom(firstDay, offSetDays: -i)
            timeArr.insert(tempDate, at: 0)
        }
        //获取本月的所有日期
        for i in 0..<currentMonthDays{
            let tempDate = calendar.getDateFrom(firstDay, offSetDays: i)
            timeArr.append(tempDate)
        }
        
        //下个月的日期
        let futureDays = 42 - (rang.count + currentMonthDays)
        let futureFirstDate = timeArr.last!
        for i in 1...futureDays{
            let tempDate = calendar.getDateFrom(futureFirstDate, offSetDays: i)
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
            if Calendar.current.isDate(time, inSameDayAs: Date()){
                model.isToday = true
            }
            //是否是本月
            model.isCurrentMonth = model.month == date.month!
            modelArr.append(model)
        }
        for model in modelArr {
            print(model)
        }
    }
}


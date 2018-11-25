//
//  ViewController.swift
//  ZJCustomCalendar
//
//  Created by 张江 on 2018/11/21.
//  Copyright © 2018 张江. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation

class ViewController: UIViewController {
    //一定要设置为全局的
    var player:AVAudioPlayer?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let calendarView = ZJCustomCalendar(frame: .zero)
//        calendarView.minDate = ZJCalendarTools.getDateFrom(Date(), offSetMonths: -5)
//        calendarView.maxDate = ZJCalendarTools.getDateFrom(Date(), offSetDays: 20)
        calendarView.isShowlunar = false
        calendarView.selectedBlcok = { model in
            print("选中的日期===\(model.dateStr)")
        }
        self.view.addSubview(calendarView)

        calendarView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(80)
            make.height.equalTo(340)
        }
//
//        let path = Bundle.main.url(forResource: "paybackMoney.wav", withExtension: nil)
//        player = try! AVAudioPlayer.init(contentsOf: path!)
//        player?.volume = 1
//        player?.numberOfLoops = 0
//        player?.currentTime = 0
//        player?.prepareToPlay()
//        player?.play()
//        getAllMonthDays()
    }
    
    func getAllMonthDays(_ date:Date = Date())  {
        //本月总天数
        let currentMonthDays = ZJCalendarTools.getNumberOfDaysInMonth(date)
        //本月第一天周几
        let firstWeekDay = ZJCalendarTools.convertDateToFirstWeek(date)
        //本月的第一天
        let firstDay = ZJCalendarTools.getFirstDayOfMonth(date)
        
        //上个月的同一天日期
        let lastMonthDate = ZJCalendarTools.getDateFrom(date, offSetMonths: -1)
        //上个月的天数
        let lastMonthDays = ZJCalendarTools.getNumberOfDaysInMonth(lastMonthDate)
        //这个月要保留几天上个月的位置
        let rang = Array((lastMonthDays-firstWeekDay+1)...lastMonthDays)
        
        //日期固定为42个，一共要添加多少按着下面的计算
        var timeArr = [Date]()
        //获取上月要显示的日期
        for i in 1...rang.count {
            let tempDate = ZJCalendarTools.getDateFrom(firstDay, offSetDays: -i)
            timeArr.insert(tempDate, at: 0)
        }
        //获取本月的所有日期
        for i in 0..<currentMonthDays{
            let tempDate = ZJCalendarTools.getDateFrom(firstDay, offSetDays: i)
            timeArr.append(tempDate)
        }
        
        //下个月的日期
        let futureDays = 42 - (rang.count + currentMonthDays)
        let futureFirstDate = timeArr.last!
        for i in 1...futureDays{
            let tempDate = ZJCalendarTools.getDateFrom(futureFirstDate, offSetDays: i)
            timeArr.append(tempDate)
        }
        let days =
            ["初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十","十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十","廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十"];
        //获取的数据，模型转化
        var modelArr = [ZJCalendarModel]()
        for time in timeArr {
            var model = ZJCalendarModel()
            model.date = time
            model.dateStr = time.stringWithFormat()
            let chineseCal = Calendar.init(identifier: .chinese)
            let localComp =  chineseCal.dateComponents([.year,.month,.day,.hour,.minute,.second], from: time)
            model.year = time.year!
            model.month = time.month!
            model.day = time.day!
            model.lunarDay = days[localComp.day!-1]
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


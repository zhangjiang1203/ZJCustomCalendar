//
//  ZJCalendarModel.swift
//  ZJCustomCalendar
//
//  Created by 张江 on 2018/11/21.
//  Copyright © 2018 张江. All rights reserved.
//

import UIKit

struct ZJCalendarModel {
    
    var dateStr = ""
    var date:Date?
    var year = 0
    var month = 0
    var day = 0
    /// 阴历年
    var lunarYear = ""
    /// 阴历月
    var lunarMonth = ""
    /// 阴历日
    var lunarDay = ""
    /// 十二生肖
    var zodiac = ""
    /// 是否可以选,默认是不可选的
    var isCanSelected = false
    /// 是否是当天
    var isToday = false
    /// 是否展示阴历
    //MARK:TODO 下一步完善功能
    var isShowLunar = false
    /// 是否是本月的数据,默认false
    var isCurrentMonth = false
}

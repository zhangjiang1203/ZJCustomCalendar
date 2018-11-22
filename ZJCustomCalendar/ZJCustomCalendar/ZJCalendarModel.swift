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
    
    /// 阴历
    var lunar = ""
    
    /// 是否可以选
    var isCanSelected = true
    
    /// 是否是当天
    var isToday = false
    
    /// 是否展示阴历
    //MARK:TODO 下一步完善功能
    var isShowLunar = false

    /// 是否是本月的天数
    var isCurrentMonth = true

}

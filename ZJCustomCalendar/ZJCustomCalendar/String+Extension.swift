//
//  String+Extension.swift
//  ZJCustomCalendar
//
//  Created by 张江 on 2018/11/21.
//  Copyright © 2018 张江. All rights reserved.
//

import Foundation

extension String {
    
    /// 字符串转化为日期
    ///
    /// - Parameter formatStr: 转化格式 默认为yyyy-MM-dd HH:mm:ss，根据字符串的格式进行设置
    /// - Returns: 返回的日期
    func toDate(_ formatStr: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let format = DateFormatter()
        format.dateFormat = formatStr
        return format.date(from: self)
    }
}

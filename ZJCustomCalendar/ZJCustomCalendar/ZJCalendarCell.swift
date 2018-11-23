//
//  ZJCalendarCell.swift
//  ZJCustomCalendar
//
//  Created by 张江 on 2018/11/21.
//  Copyright © 2018 张江. All rights reserved.
//

import UIKit
import SnapKit

fileprivate let notCurrentMonthColor = HEXCOLOR("9b9b9b")
fileprivate let normalColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1.0)

class ZJCalendarCell: UICollectionViewCell {
    ///显示天数
    var dayInfoLabel:UILabel?
    ///显示阴历
    var lunarInfoLabel:UILabel?
    ///优先设置默认日期
    var setDefaultDate:Date?
    
    ///设置日期数据
    var calendarModel:ZJCalendarModel?{
        didSet{
            guard let model = calendarModel else {
                return
            }
            lunarInfoLabel?.text = model.lunar
            lunarInfoLabel?.isHidden = !model.isShowLunar
            if !model.isShowLunar {
                dayInfoLabel!.snp.remakeConstraints { (make) in
                    make.center.equalToSuperview()
                    make.size.equalTo(CGSize(width: 36, height: 36))
                }
            }
//            优先级排列 1是否可选 2是否今天 3是否本月
            if model.isCanSelected{
                dayInfoLabel?.isHidden = !model.isCurrentMonth
                dayInfoLabel?.text = model.isToday ? "今天" :"\(model.day)"
                dayInfoLabel?.textColor = normalColor
                dayInfoLabel?.backgroundColor = .white
                if setDefaultDate != nil {
                    if Calendar.current.isDate(model.date!, inSameDayAs: setDefaultDate!) {
                        dayInfoLabel?.textColor = .white
                        dayInfoLabel?.layer.cornerRadius = 18
                        dayInfoLabel?.layer.masksToBounds = true
                        dayInfoLabel?.backgroundColor = HEXCOLOR("f2596c")
                    }else{
                        dayInfoLabel?.textColor = normalColor
                        dayInfoLabel?.layer.cornerRadius = 0
                        dayInfoLabel?.layer.masksToBounds = false
                        dayInfoLabel?.backgroundColor = .white
                    }
                }
            }else{
                dayInfoLabel?.isHidden = !model.isCurrentMonth
                dayInfoLabel?.text = model.isToday ? "今天" :"\(model.day)"
                dayInfoLabel?.textColor = notCurrentMonthColor
                dayInfoLabel?.backgroundColor = .white
                dayInfoLabel?.layer.cornerRadius = 0
                dayInfoLabel?.layer.masksToBounds = false
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setInfoLabel()
    }
    
    fileprivate func setInfoLabel() {
        dayInfoLabel = UILabel()
        dayInfoLabel?.textAlignment = .center
        dayInfoLabel?.textColor = normalColor
        dayInfoLabel?.font = UIFont.systemFont(ofSize:16)
        self.contentView.addSubview(dayInfoLabel!)
        
        lunarInfoLabel = UILabel()
        lunarInfoLabel?.textAlignment = .center
        lunarInfoLabel?.textColor = normalColor
        lunarInfoLabel?.font = UIFont.systemFont(ofSize: 14)
        self.contentView.addSubview(lunarInfoLabel!)

        dayInfoLabel!.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10)
            make.height.equalTo(20)
        }
        lunarInfoLabel!.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview().offset(10)
            make.height.equalTo(20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//
//  ZJCalendarCell.swift
//  ZJCustomCalendar
//
//  Created by 张江 on 2018/11/21.
//  Copyright © 2018 张江. All rights reserved.
//

import UIKit
import SnapKit

fileprivate let todayColor = UIColor(red: 180/255.0, green: 180/255.0, blue: 180/255.0, alpha: 1)
fileprivate let normalColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1.0)

class ZJCalendarCell: UICollectionViewCell {
    ///显示天数
    var dayInfoLabel:UILabel?
    ///显示阴历
    var lunarInfoLabel:UILabel?
    ///设置日期数据
    var calendarModel:ZJCalendarModel?{
        didSet{
            guard let model = calendarModel else {
                return
            }
            dayInfoLabel?.text = "\(model.day)"
            lunarInfoLabel?.text = model.lunar
            lunarInfoLabel?.isHidden = !model.isShowLunar
            if !model.isShowLunar {
                dayInfoLabel!.snp.remakeConstraints { (make) in
                    make.center.equalToSuperview()
                    make.size.equalTo(CGSize(width: 30, height: 30))
                }
            }
            if model.isToday {
                dayInfoLabel?.textColor = .white
                dayInfoLabel?.backgroundColor = .blue
                dayInfoLabel?.layer.cornerRadius = 15
                dayInfoLabel?.layer.masksToBounds = true
            }else{
                if !model.isCurrentMonth {
                    dayInfoLabel?.textColor = todayColor
                }else{
                    dayInfoLabel?.textColor = normalColor
                }
                dayInfoLabel?.backgroundColor = .white
                dayInfoLabel?.layer.cornerRadius = 0
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
        dayInfoLabel?.font = UIFont.systemFont(ofSize: 16)
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

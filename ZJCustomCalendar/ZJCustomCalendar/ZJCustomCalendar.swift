//
//  ZJCustomCalendar.swift
//  ZJCustomCalendar
//
//  Created by 张江 on 2018/11/21.
//  Copyright © 2018 张江. All rights reserved.
//

import UIKit

fileprivate let cellIden = "CalendarCell"
fileprivate let normalColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1.0)

class ZJCustomCalendar: UIView {
    ///所有视图都是加载视图立即使用没有必要使用懒加载
    fileprivate var myCollection:UICollectionView!
    fileprivate var leftBtn:UIButton!
    fileprivate var rightBtn:UIButton!
    fileprivate var timeLabel:UILabel!
    fileprivate var calendarTool = ZJCalendarTools()
    fileprivate var selectedDate:Date?
    ///添加日历数据源
    fileprivate var calendarDataArr:[ZJCalendarModel]?{
        didSet{
            //设置数据刷新界面
            guard let _ = calendarDataArr else {
                return
            }
            myCollection.reloadData()
        }
    }
    
    /// 设置默认日期
    var setDefaultDate:Date?{
        didSet{
            guard let date = setDefaultDate else {
                return
            }
            //设置默认显示的日期
            selectedDate = date
            //重新生成数据展示出来
            calendarDataArr = calendarTool.getAllMonthDays(selectedDate!)
        }
    }
    ///展示最小日期
    var minDate:Date?{
        didSet{
            guard let min = minDate else {
                return
            }
//            var timeArr = calendarDataArr
//            timeArr = timeArr!.filter { $0.isCurrentMonth}
//            //判断最大日期是否在这个数据中
//            let maxTimeArr = timeArr!.filter { (model) -> Bool in
//                return Calendar.current.isDate(model.date!, inSameDayAs: min)
//            }
//            leftBtn.isEnabled = !(maxTimeArr.count > 0)
            judgeMaxDateAvailable(dateArr: calendarDataArr!, compDate: min, button: leftBtn)
        }
    }
    ///展示的最大日期范围
    var maxDate:Date?{
        didSet{
            guard let max = maxDate else {
                return
            }
//            var timeArr = calendarDataArr
//            timeArr = timeArr!.filter { $0.isCurrentMonth}
//            //判断最大日期是否在这个数据中
//            let maxTimeArr = timeArr!.filter { (model) -> Bool in
//                return Calendar.current.isDate(model.date!, inSameDayAs: max)
//            }
//            rightBtn.isEnabled = !(maxTimeArr.count > 0)
            judgeMaxDateAvailable(dateArr: calendarDataArr!, compDate: max, button: rightBtn)

        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpMyCalendarUI()
        //初始化数据
        selectedDate = Date()
        calendarDataArr = calendarTool.getAllMonthDays(selectedDate!)
    }
    
    fileprivate func setUpMyCalendarUI() {
        let itemW = self.frame.size.width / 7

        let topBackView = UIView()
        topBackView.backgroundColor = .white
        self.addSubview(topBackView)
        
        leftBtn = UIButton()
        leftBtn.tag = 1
        leftBtn.setImage(UIImage(named: "time_choose_left_nor"), for: .normal)
        leftBtn.setImage(UIImage(named: "time_choose_left_dis"), for: .disabled)
        leftBtn.addTarget(self, action: #selector(changeMonthAction(sender:)), for: .touchUpInside)
        topBackView.addSubview(leftBtn)
        
        rightBtn = UIButton()
        rightBtn.tag = 2
        rightBtn.setImage(UIImage(named: "time_choose_right_nor"), for: .normal)
        rightBtn.setImage(UIImage(named: "time_choose_right_dis"), for: .disabled)
        rightBtn.addTarget(self, action: #selector(changeMonthAction(sender:)), for: .touchUpInside)
        topBackView.addSubview(rightBtn)
        
        timeLabel = UILabel()
        timeLabel.textAlignment = .center
        timeLabel.text = Date().stringWithFormat("yyyy月MM日")
        timeLabel.textColor = normalColor
        timeLabel.font = UIFont.systemFont(ofSize: 16)
        topBackView.addSubview(timeLabel)
        //设置上部的视图展示
        topBackView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        leftBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.left.top.equalToSuperview()
        }
        
        rightBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.right.top.equalToSuperview()
        }
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.leftBtn.snp.right)
            make.right.equalTo(self.rightBtn.snp.left)
            make.bottom.top.equalToSuperview()
        }
        
        //添加星期
        let weekView = UIView()
        weekView.backgroundColor = .white
        self.addSubview(weekView)
        weekView.snp.makeConstraints { (make) in
            make.top.equalTo(topBackView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        let tempArr = ["日","一","二","三","四","五","六"]
        var tempWeekLabel:UILabel?
        for i in 0..<tempArr.count {
            let infoLabel = UILabel()
            infoLabel.text = tempArr[i]
            infoLabel.textAlignment = .center
            infoLabel.textColor = normalColor
            infoLabel.font = UIFont.systemFont(ofSize: 16)
            weekView.addSubview(infoLabel)
            
            infoLabel.snp.makeConstraints { (make) in
                make.size.equalTo(CGSize.init(width: itemW, height: 40))
                make.top.equalToSuperview()
                if tempWeekLabel == nil {
                    make.left.equalToSuperview()
                }else{
                    make.width.equalTo(tempWeekLabel!)
                    make.left.equalTo((tempWeekLabel?.snp.right)!)
                }
                if i == (tempArr.count-1){
                    make.right.equalToSuperview()
                }
            }
            tempWeekLabel = infoLabel
        }
        //collectionView
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize.init(width: itemW, height:50)
        myCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        myCollection.delegate = self
        myCollection.dataSource = self
        myCollection.register(ZJCalendarCell.self, forCellWithReuseIdentifier: cellIden)
        myCollection.showsVerticalScrollIndicator = false
        myCollection.showsHorizontalScrollIndicator = false
        myCollection.backgroundColor = .white
        self.addSubview(myCollection)
        
        myCollection.snp.makeConstraints { (make) in
            make.top.equalTo(weekView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }

    
    ///按钮点击设置
    @objc func changeMonthAction(sender:UIButton) {
        selectedDate = calendarTool.getDateFrom(selectedDate!, offSetMonths: sender.tag == 1 ? -1 : 1)
        //比较当前的日期是否在最大和最小日期之间
        let timeArr = calendarTool.getAllMonthDays(selectedDate!)
        if maxDate != nil {
            judgeMaxDateAvailable(dateArr: timeArr, compDate: maxDate!, button: rightBtn)
        }
        
        if minDate != nil {
            judgeMaxDateAvailable(dateArr: timeArr, compDate: minDate!, button: leftBtn)
        }
        timeLabel.text = selectedDate!.stringWithFormat("yyyy月MM日")
        calendarDataArr = timeArr
    }
    
    ///重新设置itemsize大小
    override func layoutSubviews() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize.init(width: self.bounds.size.width/7.0, height:40)
        myCollection.collectionViewLayout.invalidateLayout()
        myCollection.collectionViewLayout = layout
    }
    
    
    /// 判断最大和最小日期
    ///
    /// - Parameters:
    ///   - dateArr: 日期数组
    ///   - compDate: 比较时间
    ///   - button: 按钮控件
    fileprivate func judgeMaxDateAvailable(dateArr:[ZJCalendarModel],compDate:Date,button:UIButton) {
        var timeArr = dateArr
        timeArr = timeArr.filter { $0.isCurrentMonth}
        //判断最大日期是否在这个数据中
        let maxTimeArr = timeArr.filter { (model) -> Bool in
            return Calendar.current.isDate(model.date!, inSameDayAs: compDate)
        }
        //当maxTimeArr有值 就说明最大或者最小日期在这个数组中，禁止按钮
        button.isEnabled = !(maxTimeArr.count > 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ZJCustomCalendar:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIden, for: indexPath) as! ZJCalendarCell
        cell.calendarModel = calendarDataArr![indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let model = calendarDataArr![indexPath.row]
        print(model.dateStr)
    }
    
    
}

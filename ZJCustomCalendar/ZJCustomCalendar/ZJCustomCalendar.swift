//
//  ZJCustomCalendar.swift
//  ZJCustomCalendar
//
//  Created by 张江 on 2018/11/21.
//  Copyright © 2018 张江. All rights reserved.
//

import UIKit

fileprivate let cellIden = "CalendarCell"
fileprivate let normalColor = HEXCOLOR("4a4a4a")

class ZJCustomCalendar: UIView {
    fileprivate var totalBackView:UIView!
    ///所有视图都是加载视图立即使用没有必要使用懒加载
    fileprivate var monthLabel:UILabel!
    fileprivate var myCollection:UICollectionView!
    fileprivate var leftBtn:UIButton!
    fileprivate var rightBtn:UIButton!
    //MARK:手势
    fileprivate var leftSwipe:UISwipeGestureRecognizer!
    fileprivate var rightSwipe:UISwipeGestureRecognizer!
    
    fileprivate var timeLabel:UILabel!
    fileprivate var selectedDate:Date?
    ///是否可以滑动日历
    fileprivate var isScrollCalendar = true
    ///选中日期的回调
    var selectedBlcok:((ZJCalendarModel)->Void)?
    ///是否展示阴历 默认展示
    var isShowlunar = true{
        didSet{
            //刷新数据
            dealMiddleDate(calendarDataArr!)
        }
    }
    ///是否展示非本月s日历 默认不展示
    var isShowNotCurrentMonth = true{
        didSet{
            //刷新数据
            dealMiddleDate(calendarDataArr!)
        }
    }


    ///添加日历数据源
    fileprivate var calendarDataArr:[ZJCalendarModel]?{
        didSet{
            //设置数据刷新界面
            guard let _ = calendarDataArr else {return}
            myCollection.reloadData()
        }
    }
    
    /// 设置默认日期
    var setDefaultDate:Date?{
        didSet{
            guard let date = setDefaultDate else {return}
            //设置默认显示的日期
            selectedDate = date
            //重新生成数据展示出来
            let tempArr = ZJCalendarTools.getAllMonthDays(selectedDate!)
            dealMiddleDate(tempArr)
        }
    }
    ///展示最小日期
    var minDate:Date?{
        didSet{
            guard let min = minDate else {return}
            judgeMaxDateAvailable(dateArr: calendarDataArr!, compDate: min, button: leftBtn)
            //处理数组
            dealMiddleDate(calendarDataArr!)
        }
    }
    ///展示的最大日期范围
    var maxDate:Date?{
        didSet{
            guard let max = maxDate else {return}
            judgeMaxDateAvailable(dateArr: calendarDataArr!, compDate: max, button: rightBtn)
            //处理数组
            dealMiddleDate(calendarDataArr!)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = RGBA(0, 0, 0, 0.3)
        setUpMyCalendarUI()
        //初始化数据
        selectedDate = Date()
        let tempArr = ZJCalendarTools.getAllMonthDays(selectedDate!)
        dealMiddleDate(tempArr)
    }
    
    fileprivate func setUpMyCalendarUI() {
        
        totalBackView = UIView()
        totalBackView.backgroundColor = .white
        self.addSubview(totalBackView)
        totalBackView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(340)
        }
        
        let topBackView = UIView()
        topBackView.backgroundColor = HEXCOLOR("f9f9f9")
        totalBackView.addSubview(topBackView)
        
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
        timeLabel.text = Date().stringWithFormat("yyyy年MM月")
        timeLabel.textColor = normalColor
        timeLabel.font = UIFont.systemFont(ofSize: 16)
        topBackView.addSubview(timeLabel)
        //设置上部的视图展示
        topBackView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        leftBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 40, height: 50))
            make.left.top.equalToSuperview()
        }
        
        rightBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 40, height: 50))
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
        totalBackView.addSubview(weekView)
        weekView.snp.makeConstraints { (make) in
            make.top.equalTo(topBackView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        let tempArr = ["日","一","二","三","四","五","六"]
        for i in 0..<tempArr.count {
            let infoLabel = UILabel()
            infoLabel.tag = 100 + i
            infoLabel.text = tempArr[i]
            infoLabel.textAlignment = .center
            infoLabel.textColor = normalColor
            infoLabel.font = UIFont.systemFont(ofSize: 16)
            weekView.addSubview(infoLabel)
        }
    
        //collectionView
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize.init(width: 0, height:50)
        myCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        myCollection.delegate = self
        myCollection.dataSource = self
        myCollection.register(ZJCalendarCell.self, forCellWithReuseIdentifier: cellIden)
        myCollection.showsVerticalScrollIndicator = false
        myCollection.showsHorizontalScrollIndicator = false
        myCollection.backgroundColor = .white
        totalBackView.addSubview(myCollection)
        
        monthLabel = UILabel()
        monthLabel.textColor = UIColor.init(red: 210/250.0, green: 210/250.0, blue: 210/250.0, alpha: 100/255.0)
        monthLabel.text = Date().stringWithFormat("M")
        monthLabel.textAlignment = .center
        monthLabel.font = UIFont.systemFont(ofSize: 80)
        totalBackView.addSubview(monthLabel)
        
        //collectionView添加滑动手势
        leftSwipe = UISwipeGestureRecognizer.init(target: self, action: #selector(swipteToChangeDate(gesture:)))
        leftSwipe.direction = .left
        myCollection.addGestureRecognizer(leftSwipe)
        
        rightSwipe = UISwipeGestureRecognizer.init(target: self, action: #selector(swipteToChangeDate(gesture:)))
        rightSwipe.direction = .right
        myCollection.addGestureRecognizer(rightSwipe)
        
        myCollection.snp.makeConstraints { (make) in
            make.top.equalTo(weekView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        monthLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.size.equalTo(self.myCollection)
        }
        
    }

    @objc fileprivate func swipteToChangeDate(gesture:UISwipeGestureRecognizer)  {
        if(gesture.direction == .left){
            changeMonthAction(sender: rightBtn)
        }else if(gesture.direction == .right){
              changeMonthAction(sender: leftBtn)
        }
    }
    
    ///按钮点击设置
    @objc fileprivate func changeMonthAction(sender:UIButton) {
        selectedDate = ZJCalendarTools.getDateFrom(selectedDate!, offSetMonths: sender.tag == 1 ? -1 : 1)
        addTranstion(isUp: sender.tag != 1)
        //比较当前的日期是否在最大和最小日期之间
        let timeArr = ZJCalendarTools.getAllMonthDays(selectedDate!)
        if maxDate != nil {
            judgeMaxDateAvailable(dateArr: timeArr, compDate: maxDate!, button: rightBtn)
        }
        
        if minDate != nil {
            judgeMaxDateAvailable(dateArr: timeArr, compDate: minDate!, button: leftBtn)
        }
        //处理时间
        dealMiddleDate(timeArr)
    }
    
    ///重新设置itemsize大小
    override func layoutSubviews() {
        let itemW = self.bounds.size.width / 7
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize.init(width: itemW, height:40)
        myCollection.collectionViewLayout.invalidateLayout()
        myCollection.collectionViewLayout = layout
        //设置约束
        var tempWeekLabel:UILabel?
        for i in 0..<7 {
            let infoLabel = self.viewWithTag(100+i) as! UILabel
            infoLabel.snp.makeConstraints { (make) in
                make.size.equalTo(CGSize(width: itemW, height: 50))
                make.top.equalToSuperview()
                if tempWeekLabel == nil {
                    make.left.equalToSuperview()
                }else{
                    make.width.equalTo(tempWeekLabel!)
                    make.left.equalTo((tempWeekLabel?.snp.right)!)
                }
                if i == 6 {
                    make.right.equalToSuperview()
                }
            }
            tempWeekLabel = infoLabel
        }
    }
    
    /// 处理最大值和最小值,是否展示阴历等问题
    func dealMiddleDate(_ dateArr:[ZJCalendarModel])  {
        var tempArr = [ZJCalendarModel]()
        if let max = maxDate,let min = minDate {
            for var item in dateArr{
                if item.date! >= min && item.date! <= max {
                    item.isCanSelected = true
                }
                tempArr.append(item)
            }
        }else if let max = maxDate {
            for var item in dateArr{
                if item.date! <= max {
                    item.isCanSelected = true
                }
                tempArr.append(item)
            }
        }else if let min = minDate{
            for var item in dateArr{
                if item.date! >= min{
                    item.isCanSelected = true
                }
                tempArr.append(item)
            }
        }else{
            for var item in dateArr{
                item.isCanSelected = true
                tempArr.append(item)
            }
        }
        
        tempArr = tempArr.map { (model)-> ZJCalendarModel in
            var lunarModel = model
            lunarModel.isShowLunar = self.isShowlunar
            return lunarModel
        }
        //修改展示时间
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.timeLabel.text = self.selectedDate!.stringWithFormat("yyyy年MM月")
            self.monthLabel.text = self.selectedDate!.stringWithFormat("M")
        }
        
        calendarDataArr = tempArr
    }
    
    /// 判断最大和最小日期,设置按钮和手势是否可用
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
        if maxTimeArr.count > 0 {
            if button == leftBtn{
                myCollection.addGestureRecognizer(leftSwipe)
                myCollection.removeGestureRecognizer(rightSwipe)
            }else{
                myCollection.removeGestureRecognizer(leftSwipe)
                myCollection.addGestureRecognizer(rightSwipe)
            }
            isScrollCalendar = false
        }else{
            if isScrollCalendar{
                myCollection.addGestureRecognizer(leftSwipe)
                myCollection.addGestureRecognizer(rightSwipe)
            }
            isScrollCalendar = true
        }
        button.isEnabled = !(maxTimeArr.count > 0)
    }
    
    /// 设置动画
    func addTranstion(isUp:Bool) {
        //fade，reveal，moveIn，cube，suckEffect，oglFlip，rippleEffect，pageCurl，pageCurl，cameraIrisHollowOpen，cameraIrisHollowClose，pageUnCurl，pageCurl，pageCurl，pageCurl
        let transtion = CATransition()
        transtion.type = isUp ? "pageCurl" : "pageUnCurl"//CATransitionType(rawValue: isUp ? "pageCurl" : "pageUnCurl")
        transtion.duration = 0.4
        transtion.subtype = CATransitionSubtype.init(string: "fromRight") as String
        myCollection.layer.add(transtion, forKey: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = ((touches as NSSet).anyObject() as! UITouch)     //进行类  型转化
        let point = touch.location(in: self)     //获取当前点击位置
        if point.y > (self.totalBackView.bounds.height) {
            self.removeSelf()
        }
    }
    
    fileprivate func removeSelf()  {
        UIView.animate(withDuration: 0.1, animations: {
        }) { (com) in
            self.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZJCustomCalendar:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIden, for: indexPath) as! ZJCalendarCell
        cell.setDefaultDate = setDefaultDate
        cell.calendarModel = calendarDataArr![indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if selectedBlcok != nil {
            let model = calendarDataArr![indexPath.row]
            if model.isCurrentMonth {
                selectedBlcok!(model)
            }
        }
    }
}

//
//  WaterPickerView.swift
//  Animations
//
//  Created by fly on 7/26/16.
//  Copyright © 2016 fly. All rights reserved.
//

import UIKit

class WaterPickerView: UIView,UIPickerViewDataSource,UIPickerViewDelegate {
    let pickerView = UIPickerView()
    var dataSource : [String] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(pickerView)
        pickerView.frame = self.bounds
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    func drinkWater(time : String) {
        dataSource.append(time)
        pickerView.reloadAllComponents()
        pickerView.selectRow(dataSource.count - 1, inComponent: 0, animated: true)
    }
    
    // MARK:- UIPickerViewDelegate,UIPickerViewDataSource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    
//    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return dataSource[row]
//    }
    
    let selectedColor = UIColor(red:0.42, green:0.61, blue:0.65, alpha:1.00)
    let normalColor = UIColor(red:0.74, green:0.99, blue:1.00, alpha:1.00)
    
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = dataSource[row]
        let range = NSMakeRange(0, title.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        
        
        let attributedText = NSMutableAttributedString.init(string: dataSource[row])
//        print(pickerView.selectedRowInComponent(component),row,component)
        
        if row == pickerView.selectedRowInComponent(component) {
            attributedText.setAttributes([NSForegroundColorAttributeName:selectedColor], range:range )
        }else{
            attributedText.setAttributes([NSForegroundColorAttributeName:normalColor], range:range)
        }
        return attributedText
    }

}

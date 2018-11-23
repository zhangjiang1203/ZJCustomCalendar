//
//  UIColor+Extension.swift
//  ZJCustomCalendar
//
//  Created by zxd on 2018/11/23.
//  Copyright © 2018 张江. All rights reserved.
//

import UIKit

/*
 默认颜色
 */
func RGBA(_ r :CGFloat ,_ g:CGFloat,_ b:CGFloat,_ a:CGFloat) ->UIColor{
    
    if #available(iOS 10.0, *) {
        return UIColor(displayP3Red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a )
    } else {
        // Fallback on earlier versions
        return UIColor.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
}

/// 十六进制颜色值
///
/// - Parameters:
///   - h: 十六制
///   - a: 透明度
/// - Returns: 返回颜色值
func HEXACOLOR(_ h:String,_ a:Float) ->UIColor {
    return UIColor.init(hexString: h, alpha: a)!
}

/// 十六进制颜色值
///
/// - Parameters:
///   - h: 十六制
/// - Returns: 返回颜色值
func HEXCOLOR(_ h:String) ->UIColor {
    return UIColor.init(hexString: h)!
}



private extension Int {
    func duplicate4bits() -> Int {
        return (self << 4) + self
    }
}

/// An extension of UIColor (on iOS) or NSColor (on OSX) providing HEX color handling.
public extension UIColor {
    @objc public func test(){
        
    }
    /**
     Create non-autoreleased color with in the given hex string. Alpha will be set as 1 by default.
     
     - parameter hexString: The hex string, with or without the hash character.
     - returns: A color with the given hex string.
     */
    public convenience init?(hexString: String) {
        self.init(hexString: hexString, alpha: 1.0)
    }
    
    fileprivate convenience init?(hex3: Int, alpha: Float) {
        self.init(red:   CGFloat( ((hex3 & 0xF00) >> 8).duplicate4bits() ) / 255.0,
                  green: CGFloat( ((hex3 & 0x0F0) >> 4).duplicate4bits() ) / 255.0,
                  blue:  CGFloat( ((hex3 & 0x00F) >> 0).duplicate4bits() ) / 255.0, alpha: CGFloat(alpha))
    }
    
    fileprivate convenience init?(hex6: Int, alpha: Float) {
        self.init(red:   CGFloat( (hex6 & 0xFF0000) >> 16 ) / 255.0,
                  green: CGFloat( (hex6 & 0x00FF00) >> 8 ) / 255.0,
                  blue:  CGFloat( (hex6 & 0x0000FF) >> 0 ) / 255.0, alpha: CGFloat(alpha))
    }
    
    /**
     Create non-autoreleased color with in the given hex string and alpha.
     
     - parameter hexString: The hex string, with or without the hash character.
     - parameter alpha: The alpha value, a floating value between 0 and 1.
     - returns: A color with the given hex string and alpha.
     */
    public convenience init?(hexString: String, alpha: Float) {
        var hex = hexString
        
        // Check for hash and remove the hash
        if hex.hasPrefix("#") {
            let startIndex = hex.index(hex.startIndex, offsetBy: 1)
            let range = startIndex ..< hex.endIndex
            hex = String(hex[range])
        }
        
        guard let hexVal = Int(hex, radix: 16) else {
            self.init()
            return nil
        }
        
        switch hex.count {
        case 3:
            self.init(hex3: hexVal, alpha: alpha)
        case 6:
            self.init(hex6: hexVal, alpha: alpha)
        default:
            // Note:
            // The swift 1.1 compiler is currently unable to destroy partially initialized classes in all cases,
            // so it disallows formation of a situation where it would have to.  We consider this a bug to be fixed
            // in future releases, not a feature. -- Apple Forum
            self.init()
            return nil
        }
    }
    
    /**
     Create non-autoreleased color with in the given hex value. Alpha will be set as 1 by default.
     
     - parameter hex: The hex value. For example: 0xff8942 (no quotation).
     - returns: A color with the given hex value
     */
    public convenience init?(hex: Int) {
        self.init(hex: hex, alpha: 1.0)
    }
    
    /**
     Create non-autoreleased color with in the given hex value and alpha
     
     - parameter hex: The hex value. For example: 0xff8942 (no quotation).
     - parameter alpha: The alpha value, a floating value between 0 and 1.
     - returns: color with the given hex value and alpha
     */
    public convenience init?(hex: Int, alpha: Float) {
        if (0x000000 ... 0xFFFFFF) ~= hex {
            self.init(hex6: hex , alpha: alpha)
        } else {
            self.init()
            return nil
        }
    }
    
    
    @objc public static func hexColor(_ string: String) -> UIColor? {
        return UIColor.init(hexString: string)
    }
}


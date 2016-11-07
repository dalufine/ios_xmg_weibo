//
//  ProgressView.swift
//  weibo
//
//  Created by dalu on 2016/11/7.
//  Copyright © 2016年 dalu. All rights reserved.
//

import UIKit

class ProgressView: UIView {
    var progress : CGFloat = 0 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //
        let center = CGPoint(x: rect.width*0.5, y: rect.height*0.5)
        let radius = rect.width * 0.5 - 3
        let startAngle = CGFloat(-M_PI_2)
        let endAngle = CGFloat(2 * M_PI) * progress + startAngle
        //贝塞尔曲线
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        //绘制一条中心点的线
        path.addLine(to: center)
        path.close()
        UIColor(white: 1.0, alpha: 0.8).setFill()
        //path.stroke()//空心
        path.fill()
    }
}

//
//  HueColorPickerView.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 11/02/2018.
//  Inspired by: https://stackoverflow.com/a/34142316/862095
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import UIKit

internal protocol HueColorPickerDelegate : NSObjectProtocol {
    func hueColorPickerChanged(sender: HueColorPickerView, hue: CGFloat, point: CGPoint, state: UIGestureRecognizerState)
}

@IBDesignable
class HueColorPickerView: UIView {
    
    weak internal var delegate: HueColorPickerDelegate?
    
    @IBInspectable var colors: Int = 8 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var elementSize: CGFloat {
        return bounds.width / CGFloat(colors)
    }
    
    private func initialize() {
        self.clipsToBounds = true
        let touchGesture = UILongPressGestureRecognizer(target: self, action: #selector(touchedColor))
        touchGesture.minimumPressDuration = 0
        touchGesture.allowableMovement = CGFloat.greatestFiniteMagnitude
        self.addGestureRecognizer(touchGesture)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
//        let elementSize = rect.width / CGFloat(colors)

        for x in stride(from: 0, to: rect.width, by: elementSize) {
            let hue = x / rect.width
            let color = UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 1)
            context!.setFillColor(color.cgColor)
            context!.fill(CGRect(x: x, y: 0, width: elementSize, height: rect.height))
        }
    }
    
    func getHue(at point: CGPoint) -> CGFloat {
        let roundedPoint = CGPoint(x: elementSize * CGFloat(Int(point.x / elementSize)), y: 0)
        let hue = roundedPoint.x / self.bounds.width
        return hue
    }
    
    func getPoint(for color: UIColor) -> CGPoint {
        var hue: CGFloat = 0;
        color.getHue(&hue, saturation: nil, brightness: nil, alpha: nil);
        
        let xPos = hue * self.bounds.width
        let yPos: CGFloat = self.bounds.height / 2
        
        return CGPoint(x: xPos, y: yPos)
    }
    
    @objc func touchedColor(gestureRecognizer: UILongPressGestureRecognizer){
        if (gestureRecognizer.state == .began || gestureRecognizer.state == .changed) {
            let point = gestureRecognizer.location(in: self)
            let hue = getHue(at: point)
            
            self.delegate?.hueColorPickerChanged(sender: self, hue: hue, point: point, state: gestureRecognizer.state)
        }
        
    }
}


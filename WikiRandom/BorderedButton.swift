//
//  BorderedButton.swift
//  WikiRandom
//
//  Created by Team Hurrange on 12/04/2017.
//  Copyright © 2017 WikiRandom inc. All rights reserved.
//

import UIKit

class MultilineButton : UIButton
{
    // From storyboard
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // From code
    override init(frame : CGRect)
    {
        super.init(frame: frame)
        setup()
    }
    
    func setup()
    {
        titleLabel?.numberOfLines = 1
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.minimumScaleFactor = 0.75
        titleLabel?.textAlignment = .center
    }
}

@IBDesignable class BorderedButton: MultilineButton
{
    @IBInspectable var borderWidth : CGFloat
        {
        get
        {
            return layer.borderWidth
        }
        
        set
        {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor : UIColor?
        {
        get{
            if let color = layer.borderColor
            {
                return UIColor(cgColor: color)
            }
            else
            {
                return nil
            }
        }
        set
        {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var cornerRadius : CGFloat
        {
        get
        {
            return layer.cornerRadius
        }
        set
        {
            layer.cornerRadius = newValue
        }
    }
    
    override func setup()
    {
        super.setup()
        
        titleLabel?.numberOfLines = 2
        
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        setTitleColor(.red, for: .disabled)
    }
    
    override func prepareForInterfaceBuilder()
    {
        setup()
        
        super.prepareForInterfaceBuilder()
    }
}

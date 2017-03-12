//
//  UIImage+Color.swift
//  EssentialElements
//
//  Created by Holly Schilling on 3/11/17.
//  Copyright © 2017 Better Practice Solutions. All rights reserved.
//

import Foundation

// Adapted from http://stackoverflow.com/questions/26542035/create-uiimage-with-solid-color-in-swift
public extension UIImage {
    
    /**
     Generate an image of the specified color and size. 
    */
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

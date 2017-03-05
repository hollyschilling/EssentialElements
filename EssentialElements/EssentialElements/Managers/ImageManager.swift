//
//  ImageManager.swift
//  EssentialElements
//
//  Created by Holly Schilling on 2/26/17.
//  Copyright © 2017 Better Practice Solutions. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation
import UIKit
import Dispatch

open class ImageManager {
    
    public static var shared: ImageManager = ImageManager()
    
    private var activeTasks: [UIImageView: URLSessionTask] = [:]
    
    private let syncQueue: DispatchQueue = DispatchQueue(label: "ImageManager SyncQueue")
    public let session: URLSession
    
    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    open func cancelTask(for imageView: UIImageView?) {
        guard let imageView = imageView else {
            return
        }
        syncQueue.sync {
            guard let task = activeTasks.removeValue(forKey: imageView) else {
                return
            }
            task.cancel()
        }
        
    }
    
    open func load(url: NSURL?, for imageView: UIImageView?) {
        load(url: url as URL?, for: imageView)
    }
    
    open func load(url: URL?, for imageView: UIImageView?) {
        guard let imageView = imageView else {
            return
        }
        
        guard let url = url else {
            cancelTask(for: imageView)
            ImageManager.updateImage(nil, for: imageView)
            return
        }
        
        syncQueue.sync {
            if let task = activeTasks.removeValue(forKey: imageView) {
                task.cancel()
            }
            
            let task = session.dataTask(with: url) { (data, response, error) in
                self.syncQueue.sync {
                    self.activeTasks[imageView] = nil
                }
                if let error = error {
                    print("Error loading image from URL (\(url)): \(error)")
                    ImageManager.updateImage(nil, for: imageView)
                } else if let image = data.map({ UIImage(data: $0) }) {
                    ImageManager.updateImage(image, for: imageView)
                } else {
                    print("Could not load image from URL (\(url)).")
                    ImageManager.updateImage(nil, for: imageView)
                }
            }
            
            activeTasks[imageView] = task
            task.resume()
        }
    }
    
    private class func updateImage(_ image: UIImage?, for imageView: UIImageView) {
        if OperationQueue.current == OperationQueue.main {
            imageView.image = image
        } else {
            DispatchQueue.main.sync {
                imageView.image = image
            }
        }
    }
    
}

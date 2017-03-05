//
//  TrivialItemView.swift
//  EssentialElementsDemo
//
//  Created by Holly Schilling on 3/5/17.
//  Copyright © 2017 BetterPractice. All rights reserved.
//

import Foundation
import UIKit
import EssentialElements

class TrivialItemView: ItemView<TrivialObject> {
    
    static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .long
        df.timeStyle = .medium
        return df
    }()
    
    var label: UILabel = UILabel(frame: CGRect.zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.textAlignment = .center
        label.frame = self.bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        label.textAlignment = .center
        label.frame = self.bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(label)
    }
    
    override func updateElements() {
        label.text = item?.creationDate.map({ TrivialItemView.dateFormatter.string(from: $0 as Date) })
    }
    
}

//
//  Box.swift
//  MiddleMe
//
//  Created by Mikhail Vyrtsev on 26.05.2022.
//

import Foundation

class Box<T> {
    var value: T
    
    init(_ value: T) {
        self.value = value
    }
}

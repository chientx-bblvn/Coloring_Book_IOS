//  
//  ChooseDateVM.swift
//  BloodPresure
//
//  Created by BloodPresure on 12/31/19.
//  Copyright © 2019 BloodPresure. All rights reserved.
//

import Foundation
import RxSwift

protocol EventWhenChooseDateVMType {
    var eventApply: BehaviorSubject<Int> { get }
}

class ChooseDateVM: EventWhenChooseDateVMType {
    var eventApply: BehaviorSubject<Int>
    
    init() {
        eventApply = BehaviorSubject<Int>(value: 0)
    }
    
}

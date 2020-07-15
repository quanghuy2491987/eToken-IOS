//
//  GenericHandler.swift
//  VAB eToken
//
//  Created by Pham Huy on 6/12/20.
//  Copyright © 2020 Pham Huy. All rights reserved.
//

import Foundation

public protocol GenericHandler {
    func onFinished( success : Bool, result : String)
}

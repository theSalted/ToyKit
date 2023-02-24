//
//  Entity.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 2/23/23.
//

import GameplayKit

// TODO: Custom Entity class in the future
class Entity: GKEntity {
    
    public var name : String?
    
    public init(name: String? = nil) {
        self.name = name
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

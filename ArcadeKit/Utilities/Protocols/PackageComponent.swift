//
//  PackageComponent.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 3/1/23.
//

import GameplayKit

protocol PackageComponent {
    var dependentComponents: [GKComponent.Type] { get set }
}

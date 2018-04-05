//
//  Tree.swift
//  ProbabilisticLearning
//
//  Created by Bryce Sandlund on 3/28/18.
//  Copyright © 2018 Bryce Sandlund. All rights reserved.
//

import SpriteKit
import GameplayKit

class Tree: SKSpriteNode {

    init(texture: SKTexture?, size: CGSize) {
        super.init(texture: texture, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

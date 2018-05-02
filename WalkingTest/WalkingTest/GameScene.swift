//
//  GameScene.swift
//  WalkingTest
//
//  Created by 奥井雄一郎 on 2018/05/01.
//  Copyright © 2018年 奥井雄一郎. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    
    var images_stand_witch: [SKTexture] = []
    
    var witch_sprite : SKSpriteNode!
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        
        // load witch
        let image_witch_stand_001 = SKTexture(imageNamed: "witch_stand_1")
        let image_witch_rwalk_001 = SKTexture(imageNamed: "witch_rwalk_1")
        let image_witch_rwalk_002 = SKTexture(imageNamed: "witch_rwalk_2")
        let image_witch_lwalk_001 = SKTexture(imageNamed: "witch_lwalk_1")
        let image_witch_lwalk_002 = SKTexture(imageNamed: "witch_lwalk_2")
        
        witch_sprite = SKSpriteNode(texture: image_witch_lwalk_001)
        witch_sprite.xScale = 0.5
        witch_sprite.yScale = 0.5
        self.addChild(witch_sprite)
        
        images_stand_witch.append(image_witch_stand_001)
        images_stand_witch.append(image_witch_rwalk_001)
        images_stand_witch.append(image_witch_rwalk_002)
        images_stand_witch.append(image_witch_rwalk_001)
        images_stand_witch.append(image_witch_stand_001)
        images_stand_witch.append(image_witch_lwalk_001)
        images_stand_witch.append(image_witch_lwalk_002)
        images_stand_witch.append(image_witch_lwalk_001)
        images_stand_witch.append(image_witch_stand_001)
    }
    
    /*
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches {
            let location = t.location(in: self)
            
            
            
            //let sprite = SKSpriteNode(texture: self.images_stand_witch[0])
        
            //sprite.position = location
            
            //self.images_stand_witch[0].position = CGPoint(x : 0.0, y : 0.0)
            // 上&下タップ
            if( location.x > (witch_sprite.position.x - (witch_sprite.size.width * 5 / 2)) && (location.x < witch_sprite.position.x + (witch_sprite.size.width * 5 / 2))) {
                
                
                let moveaction = SKAction.move(to: CGPoint(x:witch_sprite.position.x, y:location.y), duration: 1)
                
                witch_sprite.run(moveaction)
                
                
            }
            else {
                // それ以外
                if( (location.x - witch_sprite.position.x) > 0)
                {
                    if( witch_sprite.xScale < 0 ) {
                        witch_sprite.xScale *= -1
                    }
                }
                else
                {
                    if( witch_sprite.xScale > 0 )
                    {
                        witch_sprite.xScale *= -1
                    }
                }
                
                let animation = SKAction.animate(with: (self.images_stand_witch), timePerFrame: (1.0 / Double(images_stand_witch.count)) )
                let moveAction = SKAction.move(to: CGPoint(x:location.x, y:witch_sprite.position.y), duration: 1)
                
                //SKAction.ani
                witch_sprite.run(animation)
                witch_sprite.run(moveAction)
            }

            
            
            
            
            
            
        }

        
        
/*        UIView.animate(withDuration: 5.0, delay: 2.0, animations: {
            self.images_stand_witch[0].position.x += 100.0
        }) { _ in
            self.images_stand_witch[0].position.x -= 50.0
         
        }
        
*/
        /*
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
 */
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
 */
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
 */
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
/*        for t in touches { self.touchUp(atPoint: t.location(in: self)) }*/
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

//
//  GameScene.swift
//  WalkingTest
//
//  Created by 奥井雄一郎 on 2018/05/01.
//  Copyright © 2018年 奥井雄一郎. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate  {
    
    private enum MoveStateWitch
    {
        case STAND
        case JUMPING
    }
    
    private var wstate = MoveStateWitch.STAND
    
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    
    var images_stand_witch: [SKTexture] = []
    
    var witch_sprite : SKSpriteNode!
    var floor_sprite : SKSpriteNode!
    var floor_sprite2 : SKSpriteNode!
    var floor_sprite2_2 : SKSpriteNode!
    var floor_sprite2b : SKSpriteNode!
    
    var targetposition_sprite : SKShapeNode!
    var targetposition_isexists : Bool = false

    
    var pass_boundary : Bool = false
    
    var animator: UIDynamicAnimator?
    
    var witch_current_plane : String!
    
    
    let available_winsize : CGSize = CGSize(width:768, height:1024)
    
    let stageworld_category : UInt32 = 0b00001
    let witch_category : UInt32 = 0b00010
    let floor_category : UInt32 = 0b00100
    let floor_transparent_category : UInt32 = 0b01000
    let targetposition_category : UInt32 = 0b100000
    
    
    
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
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
        

        
        self.images_stand_witch.append(image_witch_stand_001)
        self.images_stand_witch.append(image_witch_rwalk_001)
        self.images_stand_witch.append(image_witch_rwalk_002)
        self.images_stand_witch.append(image_witch_rwalk_001)
        self.images_stand_witch.append(image_witch_stand_001)
        self.images_stand_witch.append(image_witch_lwalk_001)
        self.images_stand_witch.append(image_witch_lwalk_002)
        self.images_stand_witch.append(image_witch_lwalk_001)
        self.images_stand_witch.append(image_witch_stand_001)
       
        
        
        let winsize = available_winsize
       
        
        let testview = SKSpriteNode( color:UIColor.white, size : CGSize(width:winsize.width, height:winsize.height))
        self.addChild(testview)
        
        // background
        let background = SKSpriteNode(imageNamed: "background-1")
        background.position = CGPoint(x:0,y:0)
        background.zPosition = 0
        background.size = self.available_winsize
        self.addChild(background)
        
        
        
        self.witch_sprite = SKSpriteNode(texture: image_witch_stand_001)
        self.witch_sprite.xScale = 1
        self.witch_sprite.yScale = 1
        self.witch_sprite.zPosition = 1
        self.witch_sprite.physicsBody = SKPhysicsBody(rectangleOf: self.witch_sprite.size)
        self.witch_sprite.physicsBody?.allowsRotation = false
        self.witch_sprite.physicsBody?.categoryBitMask = witch_category
        self.witch_sprite.physicsBody?.contactTestBitMask = stageworld_category | floor_transparent_category
        self.witch_sprite.physicsBody?.collisionBitMask = ~(floor_transparent_category)
        self.witch_sprite.name = "witch"
        self.addChild(witch_sprite)
        
        
        
        self.floor_sprite = SKSpriteNode( color:UIColor.green, size : CGSize(width: winsize.width, height: 20))
        self.floor_sprite.position = CGPoint( x : 0, y: -winsize.height / 2 + 10)//-self.frame.height / 4 + 50)
        self.floor_sprite.physicsBody = SKPhysicsBody(rectangleOf: self.floor_sprite.size)
        self.floor_sprite.physicsBody?.categoryBitMask = stageworld_category
        self.floor_sprite.zPosition = 1
        //self.floor_sprite.physicsBody?.contactTestBitMask = floor_category
        self.floor_sprite.physicsBody?.affectedByGravity = false
        self.floor_sprite.physicsBody?.isDynamic = false
        self.floor_sprite.name = "floor_sprite_001"
        self.floor_sprite.physicsBody?.restitution = 0
        self.addChild(floor_sprite)
    
        
        self.floor_sprite2_2 = SKSpriteNode( color:UIColor.clear , size:CGSize(width : winsize.width, height:14+5*2))
        self.floor_sprite2_2.position = CGPoint( x : 0, y: -winsize.height / 2 + 200)
        self.floor_sprite2_2.zPosition = 1
        self.floor_sprite2_2.physicsBody = SKPhysicsBody(rectangleOf: self.floor_sprite2_2.size)
        self.floor_sprite2_2.physicsBody?.categoryBitMask = floor_transparent_category
        self.floor_sprite2_2.physicsBody?.affectedByGravity = false
        self.floor_sprite2_2.physicsBody?.isDynamic = false
        self.floor_sprite2_2.name = "transparentarea_002"

        self.addChild(floor_sprite2_2)

        
        
        self.floor_sprite2 = SKSpriteNode( color:UIColor.green, size : CGSize(width: 150, height: 14))
        self.floor_sprite2.position = CGPoint( x : 200, y: -winsize.height / 2 + 200)//-self.frame.height / 4 + 50)
        self.floor_sprite2.zPosition = 1
        self.floor_sprite2.physicsBody = SKPhysicsBody(rectangleOf: self.floor_sprite2.size)
        self.floor_sprite2.physicsBody?.categoryBitMask = stageworld_category
        self.floor_sprite2.physicsBody?.affectedByGravity = false
        self.floor_sprite2.physicsBody?.isDynamic = false
        self.floor_sprite2.name = "floor_sprite_002_1"
        self.floor_sprite2.physicsBody?.restitution = 0
        self.addChild(floor_sprite2)
        
        self.floor_sprite2b = SKSpriteNode( color:UIColor.green, size : CGSize(width: 150, height: 14))
        self.floor_sprite2b.position = CGPoint( x : -200, y: -winsize.height / 2 + 200)//-self.frame.height / 4 + 50)
        self.floor_sprite2b.zPosition = 1
        self.floor_sprite2b.physicsBody = SKPhysicsBody(rectangleOf: self.floor_sprite2b.size)
        self.floor_sprite2b.physicsBody?.categoryBitMask = stageworld_category
        self.floor_sprite2b.physicsBody?.affectedByGravity = false
        self.floor_sprite2b.physicsBody?.isDynamic = false
        self.floor_sprite2b.name = "floor_sprite_002_2"
        self.floor_sprite2_2.physicsBody?.restitution = 0
        self.addChild(floor_sprite2b)
        

        
        
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -3.0)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let vec = contact.contactNormal;
        
        // 床とキャラクターの衝突
        if( (contact.bodyA.categoryBitMask & stageworld_category) != 0) {
            if( (contact.bodyB.categoryBitMask & targetposition_category) != 0  ) {
                targetposition_sprite.removeFromParent()
                targetposition_isexists = false

                let strrrrr = contact.bodyA.node?.name
                
                if( witch_current_plane == contact.bodyA.node?.name) {
                    
                    let location = self.targetposition_sprite.position
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
                    //7let duration_velocity = fabs(800 / (witch_sprite.position.x - location.x))
                    let moveAction = SKAction.move(to: CGPoint(x:location.x, y:witch_sprite.position.y), duration: 1.0)
                    
                    witch_sprite.run(animation)
                    witch_sprite.run(moveAction)
                }
                
                
            } else if( (contact.bodyB.categoryBitMask & witch_category) != 0) {
                if( contact.contactNormal.dy < -0.1) {
                    wstate = MoveStateWitch.STAND
                    
                    witch_current_plane = contact.bodyA.node?.name
                }
            }
        }
        
        if( (contact.bodyA.categoryBitMask & floor_transparent_category) != 0  ) {
            if( contact.contactNormal.dy > 0.1) {
                if ( !pass_boundary ) {
                    self.floor_sprite2.physicsBody = nil
                    self.floor_sprite2b.physicsBody = nil
                    pass_boundary = true
                }
            }
            else if( contact.contactNormal.dy < 0.1) {
                if( pass_boundary ) {
                    self.floor_sprite2.physicsBody = SKPhysicsBody(rectangleOf: self.floor_sprite2.size)
                    self.floor_sprite2.physicsBody?.categoryBitMask = stageworld_category
                    self.floor_sprite2.physicsBody?.affectedByGravity = false
                    self.floor_sprite2.physicsBody?.isDynamic = false
                    
                    self.floor_sprite2b.physicsBody = SKPhysicsBody(rectangleOf: self.floor_sprite2b.size)
                    self.floor_sprite2b.physicsBody?.categoryBitMask = stageworld_category
                    self.floor_sprite2b.physicsBody?.affectedByGravity = false
                    self.floor_sprite2b.physicsBody?.isDynamic = false
                    
                    pass_boundary = false
                }
                
            }
        }
        
        // 床とキャラクターの衝突
        if( (contact.bodyB.categoryBitMask & stageworld_category) != 0) {
            if( (contact.bodyA.categoryBitMask & targetposition_category) != 0  ) {
                targetposition_sprite.removeFromParent()
                targetposition_isexists = false
                

                
                if( witch_current_plane == contact.bodyB.node?.name) {
                    
                    let location = self.targetposition_sprite.position
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
                    let duration_velocity = fabs(800 / (witch_sprite.position.x - location.x))
                    let moveAction = SKAction.move(to: CGPoint(x:location.x, y:witch_sprite.position.y), duration: Double(duration_velocity))
                    
                    witch_sprite.run(animation)
                    witch_sprite.run(moveAction)
                }
            } else if( (contact.bodyA.categoryBitMask & witch_category) != 0) {
                if( contact.contactNormal.dy < -0.1) {
                    wstate = MoveStateWitch.STAND
                    
                    witch_current_plane = contact.bodyB.node?.name
                }
            }
        }
        
        if( (contact.bodyB.categoryBitMask & floor_transparent_category) != 0 ) {
            if( contact.contactNormal.dy > 0.1) {
                if ( !pass_boundary ) {
                    self.floor_sprite2.physicsBody = nil
                    self.floor_sprite2b.physicsBody = nil
                    pass_boundary = true
                }
            } else if (contact.contactNormal.dy < -0.1 ) {
                if( pass_boundary) {
                    self.floor_sprite2.physicsBody = SKPhysicsBody(rectangleOf: self.floor_sprite2.size)
                    self.floor_sprite2.physicsBody?.categoryBitMask = stageworld_category
                    self.floor_sprite2.physicsBody?.affectedByGravity = false
                    self.floor_sprite2.physicsBody?.isDynamic = false
                    
                    self.floor_sprite2b.physicsBody = SKPhysicsBody(rectangleOf: self.floor_sprite2b.size)
                    self.floor_sprite2b.physicsBody?.categoryBitMask = stageworld_category
                    self.floor_sprite2b.physicsBody?.affectedByGravity = false
                    self.floor_sprite2b.physicsBody?.isDynamic = false
                    
                    pass_boundary = false
                }
            }
        }
        
        //self.witch_sprite.physicsBody?.affectedByGravity = false
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
            
            if( wstate == MoveStateWitch.STAND) {
                    // 上&下タップ
                    if( location.x > (witch_sprite.position.x - (witch_sprite.size.width * 2 / 2)) && (location.x < witch_sprite.position.x + (witch_sprite.size.width * 2 / 2))) {
                        
                        

                        
                        // 試し　下たっぷ？
                        if( location.y < witch_sprite.position.y) {
                            
                            if(  self.witch_current_plane == self.floor_sprite.name) {
                                return
                            }
                            
                            self.pass_boundary = true
                            
                            witch_sprite.position.y -= witch_sprite.size.height
                            
                        } else if ( location.y > witch_sprite.position.y){
                            self.pass_boundary = false
                            
                            witch_sprite.physicsBody?.velocity = CGVector(dx: 0, dy: 500.0)
                            let action = SKAction.applyForce(CGVector(dx:0.0, dy:9.0), duration: 2.0)
                            witch_sprite.run(action)
                            

                        }

                        wstate = MoveStateWitch.JUMPING
                        witch_sprite.removeAllActions()
                        
                        //let moveaction = SKAction.move(to: CGPoint(x:witch_sprite.position.x, y:location.y), duration: 1)
                
                        //witch_sprite.run(moveaction)
                
                
                    } else {
                        if( !targetposition_isexists) {
                            targetposition_sprite = SKShapeNode(circleOfRadius: 4.0)
                            targetposition_sprite.fillColor = UIColor.red
                            targetposition_sprite.zPosition = 1
                            targetposition_sprite.position.x = location.x
                            targetposition_sprite.position.y = witch_sprite.position.y
                            targetposition_sprite.physicsBody = SKPhysicsBody(circleOfRadius: 4.0)
                            targetposition_sprite.physicsBody?.velocity = CGVector(dx:0, dy:-400)
                            targetposition_sprite.physicsBody?.categoryBitMask = targetposition_category
                            targetposition_sprite.physicsBody?.contactTestBitMask = stageworld_category
                            targetposition_sprite.physicsBody?.collisionBitMask = ~(floor_transparent_category)
                            self.addChild(targetposition_sprite)
                            
                            targetposition_isexists = true
                        }
                       
                        
                        
                        /*
                        // それ以外
                        var movedir = 0
                        if( (location.x - witch_sprite.position.x) > 0)
                        {
                            movedir = 1
                            if( witch_sprite.xScale < 0 ) {
                                witch_sprite.xScale *= -1
                            }
                        }
                        else
                        {
                            movedir = -1
                            
                            if( witch_sprite.xScale > 0 )
                            {
                                witch_sprite.xScale *= -1
                            }
                        }
                
                        let animation = SKAction.animate(with: (self.images_stand_witch), timePerFrame: (1.0 / Double(images_stand_witch.count)) )
                        //witch_sprite.physicsBody?.velocity = CGVector(dx : movedir * 200, dy : 0)
                        //witch_sprite.physicsBody?.applyForce(CGVector(dx : Double(movedir) * 2.0, dy : 0))
                        let duration_velocity = fabs(800 / (witch_sprite.position.x - location.x))
                        let moveAction = SKAction.move(to: CGPoint(x:location.x, y:witch_sprite.position.y), duration: Double(duration_velocity))
                        
                        
                        
                        
                        //SKAction.ani
                        witch_sprite.run(animation)
                        //witch_sprite.run(animation)
                        witch_sprite.run(moveAction)
 */
                    }
            }
        }
    }
    
    override func didEvaluateActions() {
        
    }
    
    override func didSimulatePhysics() {
        
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

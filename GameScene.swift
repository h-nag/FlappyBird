//
//  GameScene.swift
//  FlappyBird
//
//  Created by Hilarion on 2016/05/31.
//  Copyright © 2016年 hidenori.nagasawa. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var scrollNode: SKNode!
    var wallNode: SKNode!
    var bird: SKSpriteNode!
    
    override func didMoveToView(view: SKView) {
        // 背景色の設定
        backgroundColor = UIColor(colorLiteralRed: 0.15, green: 0.75, blue: 0.90, alpha: 1)
        
        // スクロールする親ノード
        scrollNode = SKNode()
        addChild(scrollNode)
        
        // 壁ノード
        wallNode = SKNode()
        scrollNode.addChild(wallNode)
        
        setupGround()
        setupCloud()
        setupWall()
        setupBird()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // 鳥の速度を是おrにする
        bird.physicsBody?.velocity = CGVector.zero
        
        // 鳥に縦方向の力を加える
        bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 15))
    }
    
    
    func setupGround() {
        
        // 地面の画像を読み込む
        let groundTexture = SKTexture(imageNamed: "ground")
        groundTexture.filteringMode = SKTextureFilteringMode.Nearest
        
        // 必要な枚数を計算
        let needNumber = 2.0 + (frame.size.width / groundTexture.size().width)
        
        // スクロールするアクションを作成
        // 左方向に画面一枚分スクロールさせるアクション
        let moveGround = SKAction.moveByX(-groundTexture.size().width, y: 0, duration: 5.0)
        
        // 元の位置に戻すアクション
        let resetGround = SKAction.moveByX(groundTexture.size().width, y: 0, duration: 0.0)
        
        // スクロールを無限に繰り返すアクション
        let repeatScrollGround = SKAction.repeatActionForever(SKAction.sequence([moveGround, resetGround]))
        
        // groundのスプライトを配置する
        var i: CGFloat = 0
        while i < needNumber {
            let sprite = SKSpriteNode(texture: groundTexture)
        
            // スプライトを表示する位置を指定する
            sprite.position = CGPoint(x: i * sprite.size.width, y: groundTexture.size().height / 2)
            
            // スプライトにアクションを設定する
            sprite.runAction(repeatScrollGround)
            
            // スプライトに物理演算を設定する
            sprite.physicsBody = SKPhysicsBody(rectangleOfSize: groundTexture.size())
            
            // 衝突時に動かないように設定する
            sprite.physicsBody?.dynamic = false
            
            // シーンにスプライトを追加する
            addChild(sprite)
            
            i += 1
        }
    
    }
    
    func setupCloud() {
        // 雲の画像を読み込む
        let cloudTexture = SKTexture(imageNamed: "cloud")
        cloudTexture.filteringMode = SKTextureFilteringMode.Nearest
        
        // 必要な枚数を計算
        let needCloudNumber = 2.0 + (frame.size.width / cloudTexture.size().width)
        
        // スクロールするアクションを作成
        // 左方向に画像一枚分スクロールさせるアクション
        let moveCloud = SKAction.moveByX(-cloudTexture.size().width, y: 0, duration: 20.0)
        
        // 元の位置に戻すアクション
        let resetCloud = SKAction.moveByX(cloudTexture.size().width, y: 0, duration: 0.0)
        
        // スクロールを無限に繰り返すアクション
        let repeatScrollCloud = SKAction.repeatActionForever(SKAction.sequence([moveCloud, resetCloud]))
        
        // スプライトを配置する
        var i: CGFloat = 0
        while i < needCloudNumber {
            let sprite = SKSpriteNode(texture: cloudTexture)
            sprite.zPosition = -100 // 一番後ろへ
            
            // スプライトの表示する位置を指定する
            sprite.position = CGPoint(x: i * sprite.size.width, y: size.height - cloudTexture.size().height / 2)
            
            // スプライトにアニメーションを設定する
            sprite.runAction(repeatScrollCloud)
            
            // スプライトを追加する
            scrollNode.addChild(sprite)
            
            
            i += 1
        }
    }
    
        func setupWall() {
            // 壁の画像を読み込む
            let wallTexture = SKTexture(imageNamed: "wall")
            wallTexture.filteringMode = .Linear
            
            // 移動する距離を計算
            let movingDistance = CGFloat(self.frame.size.width + wallTexture.size().width * 2)
            
            // 画面外まで移動するアクションを作成
            let moveWall = SKAction.moveByX(-movingDistance, y: 0, duration: 4.0)
            
            // 自身を取り除くアクション
            let removeWall = SKAction.removeFromParent()
            
            // 2つのアニメーションを順に実行するアクションを作成
            let wallAnimation = SKAction.sequence([moveWall, removeWall])
            
            // 壁を生成するアクションを作成
            let createWallAnimation = SKAction.runBlock({
                // 壁関連のノードを乗せるノードを生成
                let wall = SKNode()
                wall.position = CGPoint(x: self.frame.size.width + wallTexture.size().width * 2, y: 0.0)
                wall.zPosition = -50.0 // 雲より手前、地面より奥
                
                // 画面のY軸の中央値
                let center_y = self.frame.size.height / 2
                // 壁のY座標を上下ランダムにさせるときの最大値
                let random_y_range = self.frame.size.height / 4
                // 下の壁のY軸の下限
                let under_wall_lowest_y = UInt32(center_y - wallTexture.size().height / 2 - random_y_range / 2)
                // 1~reandom_y_rangeまでのランダムな整数を生成
                let random_y = arc4random_uniform(UInt32(random_y_range))
                // Y軸の下限にランダムな値を足して、下の壁のY座標を決定
                let under_wall_y = CGFloat(under_wall_lowest_y + random_y)
                
                // キャラが通り抜ける隙間の長さ
                let slit_length = self.frame.size.height / 6
                
                // 下側の壁を作成
                let under = SKSpriteNode(texture: wallTexture)
                under.position = CGPoint(x: 0.0, y: under_wall_y)
                wall.addChild(under)
                
                // スプライトに物理演算を設定する
                under.physicsBody = SKPhysicsBody(rectangleOfSize: wallTexture.size())
                
                // 衝突時に動かないように設定する
                under.physicsBody?.dynamic = false
                
                // 上側の壁を作成
                let upper = SKSpriteNode(texture:  wallTexture)
                upper.position = CGPoint(x: 0.0, y: under_wall_y + wallTexture.size().height + slit_length)
                
                // スプライトに物理演算を設定する
                upper.physicsBody = SKPhysicsBody(rectangleOfSize: wallTexture.size())
                
                // 衝突時に動かないように設定する
                upper.physicsBody?.dynamic = false
                
                wall.addChild(upper)
                wall.runAction(wallAnimation)
                
                self.wallNode.addChild(wall)
                
                
            })
            
            // 次の壁作成までの待ち時間のアクションを作成
            let waitAnimation = SKAction.waitForDuration(2)
            
            // 壁作成を無限に繰り返すアクション
            let repeatForeverAnimation = SKAction.repeatActionForever(SKAction.sequence([createWallAnimation, waitAnimation]))
            runAction(repeatForeverAnimation)
        }
    
    func setupBird() {
        // 鳥の画像を2種類読み込む
        let birdTextureA = SKTexture(imageNamed: "bird_a")
        birdTextureA.filteringMode = SKTextureFilteringMode.Linear
        let birdTextureB = SKTexture(imageNamed: "bird_b")
        birdTextureB.filteringMode = SKTextureFilteringMode.Linear
        
        // 2種類のテクスチャを交互に変更するアニメーションを作成
        let texturesAnimation = SKAction.animateWithTextures([birdTextureA, birdTextureB], timePerFrame: 0.2)
        let flap = SKAction.repeatActionForever(texturesAnimation)
        
        // スプライトを作成
        bird = SKSpriteNode(texture: birdTextureA)
        bird.position = CGPoint(x: 30, y: self.frame.size.height * 0.7)
        
        // 物理演算を設定
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2.0)
        
        // アニメーションの設定
        bird.runAction(flap)
        
        // スプライトを追加する
        addChild(bird)
    }
    
    
}

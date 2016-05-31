//
//  ViewController.swift
//  FlappyBird
//
//  Created by Hilarion on 2016/05/31.
//  Copyright © 2016年 hidenori.nagasawa. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // SKView型に変換する
        let skView = self.view as! SKView
        
        // FPSを表示する
        skView.showsFPS = true
        // ノード数を表示する
        skView.showsNodeCount = true
        
        // ビューと同じサイズでシーンを作成する
        let scene = GameScene(size: skView.frame.size)
        
        // ビューにシーンを表示する
        skView.presentScene(scene)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ステータスバーを消す
    override func prefersStatusBarHidden() -> Bool {
        return true
    }


}


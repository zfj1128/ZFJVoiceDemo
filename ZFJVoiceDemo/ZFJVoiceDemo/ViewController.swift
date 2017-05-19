//
//  ViewController.swift
//  ZFJVoiceDemo
//
//  Created by ZFJ on 2017/5/19.
//  Copyright © 2017年 ZFJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController,ZFJVoiceBubbleDelegate {
    var voiceMegBtn: ZFJVoiceBubble!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiConfig()
        disposeChatInputToolReturnData()
    }
    
    lazy var zyTableView: UITableView = {
        let tempTableView = UITableView (frame: self.view.bounds, style: UITableViewStyle.plain)
        tempTableView.delegate = self as? UITableViewDelegate
        tempTableView.dataSource = self as? UITableViewDataSource
        return tempTableView
    }()
    
    func disposeChatInputToolReturnData() {
        let myFrame = CGRect(x: 0, y: ScreenHeight - CGFloat(49), width: ScreenWidth, height: CGFloat(49))
        let chatInputTool = ZFJChatInputTool(frame: myFrame)
        chatInputTool.title = "评论"
        view.addSubview(chatInputTool)
//        chatInputTool.sendOutBtnAction = {(_ content: String, _ selectImg: UIImage, _ voiceUrl: URL) -> Void in
//            print("content = \(content)")
//            print("selectImg = \(selectImg)")
//            print("voiceUrl = \(voiceUrl)")
//            //评论
//            weakSelf.dealWithMedias(with: content, image: selectImg, voiceUrl: voiceUrl)
//        }
    }
    
    func uiConfig(){
        self.title = "首页"
        let myFrame = CGRect(x: CGFloat((ScreenWidth - 250) / 2), y: CGFloat(200), width: CGFloat(150), height: CGFloat(30))
        voiceMegBtn = ZFJVoiceBubble.init(frame: myFrame)
        voiceMegBtn.contentURL = URL(string: "http://7xszyu.com1.z0.glb.clouddn.com/media_blog_9250_1488873184.mp3")
        voiceMegBtn.delegate = self
        voiceMegBtn.isHaveBar = true
        voiceMegBtn.userName = "墨小北"
        view.addSubview(voiceMegBtn)
    }
    
    // MARK: ZFJVoiceBubbleDelegate
    func voiceBubbleStratOrStop(_ isStart: Bool) {
        NSLog("voiceBubbleStratOrStop")
    }
    
    func voiceBubbleDidStartPlaying(_ voiceBubble: ZFJVoiceBubble) {
        NSLog("voiceBubbleDidStartPlaying")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


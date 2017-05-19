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
    
    func disposeChatInputToolReturnData() {
        weak var weakSelf = self
        let myFrame = CGRect(x: 0, y: ScreenHeight - CGFloat(49), width: ScreenWidth, height: CGFloat(49))
        let chatInputTool = ZFJChatInputTool(frame: myFrame)
        chatInputTool.sendURLAction = {(_ voiceUrl: URL) -> Void in
            let url = URL(fileURLWithPath: voiceUrl.absoluteString)
            weakSelf?.voiceMegBtn.contentURL = url
            weakSelf?.voiceMegBtn.isUserInteractionEnabled = true
        }
        view.addSubview(chatInputTool)
    }
    
    func uiConfig(){
        self.title = "首页"
        let myFrame = CGRect(x: CGFloat((ScreenWidth - 250) / 2), y: CGFloat(200), width: CGFloat(150), height: CGFloat(30))
        voiceMegBtn = ZFJVoiceBubble.init(frame: myFrame)
        voiceMegBtn.delegate = self
        voiceMegBtn.isHaveBar = true
        voiceMegBtn.userName = "墨小北"
        voiceMegBtn.isUserInteractionEnabled = false
        view.addSubview(voiceMegBtn)
        
        let backBtn = UIButton(type: .custom)
        backBtn.setTitle("语音列表", for: UIControlState.normal)
        backBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        backBtn.frame = CGRect(x: CGFloat((ScreenWidth - 100)/2), y: CGFloat(0), width: CGFloat(100), height: CGFloat(30))
        let backItem = UIBarButtonItem(customView: backBtn)
        navigationItem.rightBarButtonItem = backItem
        backBtn.addTarget(self, action: #selector(backBtnPush), for: .touchUpInside)
    }
    
    func backBtnPush(){
        let lvc = ListViewController()
        self.navigationController?.pushViewController(lvc, animated: true)
    }
    
    // MARK: ZFJVoiceBubbleDelegate
    func voiceBubbleStratOrStop(_ voiceBubble: ZFJVoiceBubble, _ isStart: Bool) {
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


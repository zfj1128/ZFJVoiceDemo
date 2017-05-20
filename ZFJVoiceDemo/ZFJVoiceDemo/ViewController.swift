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
    
    // MARK: - 底部录音控件
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
        let myFrame = CGRect(x: CGFloat((ScreenWidth - 250) / 2) + 50, y: CGFloat(200), width: CGFloat(150), height: CGFloat(30))
        voiceMegBtn = ZFJVoiceBubble.init(frame: myFrame)
        voiceMegBtn.delegate = self
        voiceMegBtn.isHaveBar = true
        voiceMegBtn.userName = "墨小北"
        voiceMegBtn.isUserInteractionEnabled = false
        voiceMegBtn.isShowLeftImg = true
        view.addSubview(voiceMegBtn)
        
        let backBtn = UIButton(type: .custom)
        backBtn.setTitle("语音列表", for: UIControlState.normal)
        backBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        backBtn.frame = CGRect(x: CGFloat((ScreenWidth - 100)/2), y: CGFloat(0), width: CGFloat(100), height: CGFloat(30))
        let backItem = UIBarButtonItem(customView: backBtn)
        navigationItem.rightBarButtonItem = backItem
        backBtn.addTarget(self, action: #selector(backBtnPush), for: .touchUpInside)
        
        let lab = UILabel()
        lab.frame = CGRect(x: 0, y: CGFloat(260), width: ScreenWidth, height: CGFloat(30))
        lab.text = "请先进行录音，才能点击进行播放"
        lab.textAlignment = NSTextAlignment.center
        lab.font = UIFont(name: "STHeitiSC-Light", size: CGFloat(22))
        lab.textColor = UIColor(red: CGFloat(0.071), green: CGFloat(0.588), blue: CGFloat(0.859), alpha: CGFloat(1.00))
        view.addSubview(lab)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        voiceMegBtn.stop()
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


//
//  ZFJChatInputTool.swift
//  ZFJVoiceDemo
//
//  Created by ZFJ on 2017/5/19.
//  Copyright © 2017年 ZFJ. All rights reserved.
//

import UIKit
import AVFoundation

let KZFJChatInputTool_HEI : CGFloat = 49
let KZFJChatInputTool_Space : CGFloat = 10  //控件距离两边的距离
let KBothSidesBtn_WID : CGFloat = 36        //左右两边按钮的宽高
let KCallViewWID : CGFloat = 166

class ZFJChatInputTool: UIView {
    //左边按钮的图片
    var leftImg: UIImage?
    //右边按钮的图片
    var rightImg: UIImage?
    var title: String = ""
    //录音存放的路径
    lazy var recordUrl: URL = {
        let thisRecordUrl = URL(string: NSTemporaryDirectory() + ("record.caf"))
        return thisRecordUrl!
    }()
    
    //------------
    //语音界面
    lazy var recordingView: UIView = {
        let redView = UIView()
        redView.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(ScreenWidth), height: CGFloat(KZFJChatInputTool_HEI))
        redView.backgroundColor = UIColor.white
        redView.isUserInteractionEnabled = true
        return redView
    }()
    //切换成键盘的按钮
    lazy var keyBoardBtn: UIButton = {
        let keyBoard = UIButton()
        keyBoard.frame = CGRect(x: CGFloat(KZFJChatInputTool_Space), y: CGFloat((KZFJChatInputTool_HEI - KBothSidesBtn_WID) / 2), width: CGFloat(KBothSidesBtn_WID), height: CGFloat(KBothSidesBtn_WID))
        keyBoard.setImage(UIImage(named: "ZFJKeyBoardBtn"), for: .normal)
        keyBoard.addTarget(self, action: #selector(keyboardBtnClick), for: .touchUpInside)
        return keyBoard
    }()
    
    // MARK: - 切换键盘控制条
    func keyboardBtnClick(_ button: UIButton) {
        recordingView.isHidden = true
    }
    var recorder: AVAudioRecorder!
    var voiceShowLab: UILabel = {
        let voiceLab = UILabel()
        voiceLab.textAlignment = .center
        voiceLab.font = UIFont(name: "STHeitiSC-Light", size: CGFloat(14))
        voiceLab.text = "手指上滑,取消发送"
        voiceLab.textColor = UIColor.white
        return voiceLab
    }()
    //录音状态背景图
    lazy var callView: UIView = {
        let myCallView = UIView()
        myCallView.frame = CGRect(x: CGFloat((ScreenWidth - KCallViewWID) / 2), y: CGFloat(-(ScreenHeight - KCallViewWID) / 2 - KZFJChatInputTool_HEI * 2), width: CGFloat(KCallViewWID), height: CGFloat(KCallViewWID))
        myCallView.backgroundColor = UIColor(red: CGFloat(0.000), green: CGFloat(0.000), blue: CGFloat(0.000), alpha: CGFloat(0.8))
        myCallView.layer.cornerRadius = 10
        myCallView.clipsToBounds = true
        return myCallView
    }()
    //麦克风图标
    var imgView: UIImageView = {
        let myImgView = UIImageView()
        myImgView.image = UIImage(named: "ZFJMicrophoneIcon")
        myImgView.contentMode = .scaleAspectFill
        return myImgView
    }()
    
    lazy var myMaskView: UIView = {
        let myMask = UIView()
        myMask.backgroundColor = UIColor.red
        return myMask
    }()
    
    //音节状态
    lazy var yinjieBtn: UIImageView = {
        let yinBtn = UIImageView()
        yinBtn.image = UIImage(named: "ZFJVolumeIcon")
        return yinBtn
    }()
    
    var timer: Timer?
    var tempPoint = CGPoint.zero
    var endState: Int = 0
    lazy var pressView: UILabel = {
        let myPressView = UILabel()
        myPressView.backgroundColor = UIColor(red: CGFloat(0.914), green: CGFloat(0.914), blue: CGFloat(0.914), alpha: CGFloat(1.00))
        myPressView.layer.masksToBounds = true
        myPressView.layer.cornerRadius = 5
        myPressView.layer.borderWidth = 0.5
        myPressView.isUserInteractionEnabled = true
        myPressView.text = "按住 说话"
        myPressView.font = UIFont(name: "STHeitiSC-Light", size: CGFloat(16))
        myPressView.textColor = UIColor(red: CGFloat(0.592), green: CGFloat(0.592), blue: CGFloat(0.592), alpha: CGFloat(1.00))
        myPressView.textAlignment = .center
        myPressView.layer.borderColor = UIColor(red: CGFloat(0.800), green: CGFloat(0.800), blue: CGFloat(0.800), alpha: CGFloat(1.00)).cgColor
        return myPressView
    }()
    
    // MARK: - 以下是懒加载
    //左边选择图片的按钮
    lazy var lefyImgBtn: UIButton = {
        let lefyBtn = UIButton()
        lefyBtn.frame = CGRect(x: CGFloat(KZFJChatInputTool_Space), y: CGFloat((KZFJChatInputTool_HEI - KBothSidesBtn_WID) / 2), width: CGFloat(KBothSidesBtn_WID), height: CGFloat(KBothSidesBtn_WID))
        lefyBtn.setImage(UIImage(named: "ZFJRightImg"), for: .normal)
        lefyBtn.addTarget(self, action: #selector(lefyImgBtnClick), for: .touchUpInside)
        return lefyBtn
    }()

    func lefyImgBtnClick(_ button: UIButton) {
        presentAlertController()
    }
    //右边选择语言的按钮
    lazy var rightImgBtn: UIButton = {
        let rightBtn = UIButton()
        rightBtn.frame = CGRect(x: CGFloat(ScreenWidth - KBothSidesBtn_WID - KZFJChatInputTool_Space), y: CGFloat((KZFJChatInputTool_HEI - KBothSidesBtn_WID) / 2), width: CGFloat(KBothSidesBtn_WID), height: CGFloat(KBothSidesBtn_WID))
        rightBtn.setImage(UIImage(named: "ZFJLeftVoice"), for: .normal)
        rightBtn.addTarget(self, action: #selector(rightImgBtnClick), for: .touchUpInside)
        return rightBtn
    }()
    
    // MARK: - 显示录音界面
    func rightImgBtnClick(_ button: UIButton) {
        self.recordingView.isHidden = false
    }
    
    //输入框按钮
    lazy var inputBoxBtn: UIButton = {
        let inputBtn = UIButton()
        var inputBoxBtn_WID: CGFloat = ScreenWidth - KZFJChatInputTool_Space * 4 - KBothSidesBtn_WID * 2
        inputBtn.frame = CGRect(x: CGFloat((ScreenWidth - inputBoxBtn_WID) / 2), y: CGFloat((KZFJChatInputTool_HEI - KBothSidesBtn_WID) / 2), width: inputBoxBtn_WID, height: CGFloat(KBothSidesBtn_WID))
        inputBtn.setTitle("     点击输入你的评论", for: .normal)
        inputBtn.titleLabel?.font = UIFont(name: "STHeitiSC-Light", size: CGFloat(14))
        inputBtn.layer.masksToBounds = true
        inputBtn.layer.cornerRadius = 14.0
        inputBtn.backgroundColor = UIColor(red: CGFloat(0.922), green: CGFloat(0.922), blue: CGFloat(0.922), alpha: CGFloat(1.00))
        inputBtn.contentHorizontalAlignment = .left
        inputBtn.setTitleColor(UIColor(red: CGFloat(0.608), green: CGFloat(0.608), blue: CGFloat(0.608), alpha: CGFloat(1.00)), for: .normal)
        inputBtn.addTarget(self, action: #selector(inputBoxBtnClick), for: .touchUpInside)
        return inputBtn
    }()
    
    // MARK: - 输入框
    func inputBoxBtnClick(_ button: UIButton) {
        print("显示输入框，这里面就不写了")
    }

    override init(frame:CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    func initUI(){
        backgroundColor = UIColor(red: CGFloat(0.976), green: CGFloat(0.976), blue: CGFloat(0.976), alpha: CGFloat(1.00))
        layer.borderColor = UIColor(red: CGFloat(0.847), green: CGFloat(0.847), blue: CGFloat(0.847), alpha: CGFloat(1.00)).cgColor
        layer.borderWidth = 0.5
        addSubview(self.lefyImgBtn)
        addSubview(self.rightImgBtn)
        addSubview(self.inputBoxBtn)
        //录音相关
        setRecordingAbout()
    }

    func showInputView() {
        print("显示输入框，这里面就不写了")
    }

    func presentAlertController(){}
    
    // MARK: - 以下是录音相关
    func setRecordingAbout(){
        endState = 1
        //初始化录音器
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        //设置录音类型
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        //设置支持后台
        try! session.setActive(true)
        //首先要判断是否允许访问麦克风
        var isAllowed = false
        session.requestRecordPermission { (allowed) in
            if !allowed{
                let alertView = UIAlertView(title: "无法访问您的麦克风" , message: "请到设置 -> 隐私 -> 麦克风 ，打开访问权限", delegate: nil, cancelButtonTitle: "取消", otherButtonTitles: "好的")
                alertView.show()
                isAllowed = false
            }else{
                isAllowed = true
            }
        }
        if isAllowed == false{
            return //如果没有访问权限 返回
        }
        
        let recorderSeetingsDic = [
                AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC),
                AVNumberOfChannelsKey: 2, //录音的声道数，立体声为双声道
                AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
                AVEncoderBitRateKey : 320000,
                AVSampleRateKey : 44100.0 //录音器每秒采集的录音样本数
        ] as [String : Any]
        
        recorder = try! AVAudioRecorder(url: self.recordUrl, settings: recorderSeetingsDic)
        if recorder == nil {
            return
        }
        //开启仪表计数功能
        recorder?.isMeteringEnabled = true
        //语音相关控件
        addSubview(self.recordingView)
        self.recordingView.isHidden = true
        self.recordingView.addSubview(self.keyBoardBtn)
        
        let inputBoxBtn_WID: CGFloat = ScreenWidth - KZFJChatInputTool_Space * 3 - KBothSidesBtn_WID
        let underPressView = UIView(frame: CGRect(x: CGFloat((self.keyBoardBtn.frame.maxX) + KZFJChatInputTool_Space), y: CGFloat((KZFJChatInputTool_HEI - KBothSidesBtn_WID) / 2), width: inputBoxBtn_WID, height: CGFloat(KBothSidesBtn_WID)))
        
        self.pressView.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: inputBoxBtn_WID, height: CGFloat(KBothSidesBtn_WID))
        underPressView.addSubview(self.pressView)
        self.recordingView.addSubview(underPressView)
        
        let presss = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress))
        underPressView.addGestureRecognizer(presss)
        
        //录音状态背景图
        addSubview(self.callView)
        self.callView.isHidden = true
        
        self.voiceShowLab.frame = CGRect(x: CGFloat(0), y: CGFloat(KCallViewWID - 40), width: CGFloat(KCallViewWID), height: CGFloat(40))
        self.callView.addSubview(self.voiceShowLab)
        
        self.imgView.frame = CGRect(x: CGFloat((KCallViewWID - 30) / 2), y: CGFloat((KCallViewWID - 90) / 2), width: CGFloat(30), height: CGFloat(70))
        self.callView.addSubview(self.imgView)
        
        self.yinjieBtn.frame = CGRect(x: CGFloat(self.imgView.frame.maxX + 10), y: CGFloat((KCallViewWID - 40 - 20) / 2 + 15), width: CGFloat(20), height: CGFloat(40))
        self.callView.addSubview(self.yinjieBtn)

        self.myMaskView.frame = CGRect(x: CGFloat(self.imgView.frame.maxX + 10), y: CGFloat((KCallViewWID - 40 - 20) / 2 + 15), width: CGFloat(20), height: CGFloat(0))
        self.callView.addSubview(self.myMaskView)
    }
    
    func longPress(_ press: UILongPressGestureRecognizer) {
        if(press.state == UIGestureRecognizerState.began){
            self.callView.isHidden = false
            recorder!.prepareToRecord()//准备录音
            recorder!.record()//开始录音
            //启动定时器，定时更新录音音量
            self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self,
                                               selector: #selector(changeImage),
                                               userInfo: nil, repeats: true)
        }else if(press.state == UIGestureRecognizerState.changed){
            //录音正在进行
            self.pressView.text = "松开  结束"
            self.pressView.textColor = UIColor(red: CGFloat(1.000), green: CGFloat(0.310), blue: CGFloat(0.000), alpha: CGFloat(1.00))
            let point: CGPoint = press.location(in: self)
            if point.y < tempPoint.y - 10 {
                endState = 0
                self.yinjieBtn.isHidden = true
                self.voiceShowLab.text = "松开手指,取消发送"
                self.imgView.image = UIImage(named: "ZFJRevokeIcon")
                if !point.equalTo(tempPoint) && point.y < tempPoint.y - 8 {
                    tempPoint = point
                }
            }
            else if point.y > tempPoint.y + 10 {
                endState = 1
                self.yinjieBtn.isHidden = false
                self.voiceShowLab.text = "手指上滑,取消发送"
                self.imgView.image = UIImage(named: "ZFJMicrophoneIcon")
                if !point.equalTo(tempPoint) && point.y > tempPoint.y + 8 {
                    tempPoint = point
                }
            }
        }else{
            //取消或者结束录音
            self.callView.isHidden = true
            recorder?.stop()
            recorder = nil
            timer?.invalidate()
            timer = nil
            endPress()
        }
    }
    
    func endPress(){
        self.pressView.text = "按住  说话"
        self.pressView.textColor = UIColor(red: CGFloat(0.592), green: CGFloat(0.592), blue: CGFloat(0.592), alpha: CGFloat(1.00))
        if(endState == 0){
            //取消发送
            endState = 1
            self.yinjieBtn.isHidden = false
            self.voiceShowLab.text = "手指上滑,取消发送"
            self.imgView.image = UIImage(named: "ZFJMicrophoneIcon")
        }else if(endState == 1){
            print(self.recordUrl as Any)
        }
    }
    
    // MARK: - 改变现实的图片
    func changeImage() {
        recorder!.updateMeters() // 刷新音量数据
        var avg: Float = recorder!.averagePower(forChannel: 0) //获取音量的平均值
        let minValue: Float = -30
        let range: Float = 30
        let outRange: Float = 100
        if avg < minValue {
            avg = minValue
        }
        let decibels: CGFloat = CGFloat((avg + range) / range * outRange)
        let maskViewY = CGFloat(self.yinjieBtn.frame.size.height - decibels * self.yinjieBtn.frame.size.height / 100.0)

        self.myMaskView.layer.frame = CGRect(x: CGFloat(0), y: maskViewY, width: CGFloat(yinjieBtn.frame.size.width), height: CGFloat(yinjieBtn.frame.size.height))
        self.yinjieBtn.layer.mask = self.myMaskView.layer
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

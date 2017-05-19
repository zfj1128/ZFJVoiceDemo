//
//  ListViewController.swift
//  ZFJVoiceDemo
//
//  Created by ZFJ on 2017/5/19.
//  Copyright © 2017年 ZFJ. All rights reserved.
//

import UIKit

class ListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ZFJVoiceBubbleDelegate {
    
    lazy var voiceMegBtnArr: NSMutableArray = {
        let arr = NSMutableArray()
        return arr
    }()
    
    lazy var tableView: UITableView = {
        let tempTableView = UITableView (frame: self.view.bounds, style: UITableViewStyle.plain)
        tempTableView.delegate = self
        tempTableView.dataSource = self
        return tempTableView
    }()
    
    private var TableSampleIdentifier: String = "cellStr"

    override func viewDidLoad() {
        super.viewDidLoad()
        uiConfig()
    }
    
    func uiConfig(){
        self.title = "语音列表"
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.tableView)
        setExtraCellLineHidden(self.tableView)
    }
    
    //UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: TableSampleIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: TableSampleIdentifier)
            //cell?.selectionStyle = UITableViewCellSelectionStyle.none
            cell?.textLabel?.font = UIFont.systemFont(ofSize: CGFloat(16))
        }
        setTableViewCell(cell: cell!, indexPath: indexPath)
        return cell!
    }
    
    func setTableViewCell(cell: UITableViewCell, indexPath: IndexPath){
        for view: UIView in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        //
        let voiceUrl = URL(string: "http://7xszyu.com1.z0.glb.clouddn.com/media_blog_15456_1495197412.mp3")
        let voiceMegBtn : ZFJVoiceBubble!
        if(indexPath.row >= self.voiceMegBtnArr.count || self.voiceMegBtnArr.count == 0){
            //说名没有创建过
            let myFrame = CGRect(x: CGFloat(10), y: CGFloat(15), width: CGFloat(150), height: CGFloat(30))
            voiceMegBtn = ZFJVoiceBubble.init(frame: myFrame)
            voiceMegBtn.contentURL = voiceUrl
            voiceMegBtn.isHaveBar = true
            voiceMegBtn.userName = "张福杰"
            voiceMegBtn.delegate = self
            voiceMegBtn.tag = 100 + indexPath.row
            if !voiceMegBtnArr.contains(voiceMegBtn) {
                voiceMegBtnArr.add(voiceMegBtn)
            }
        }else{
            //创建过
            voiceMegBtn = self.voiceMegBtnArr[indexPath.row] as! ZFJVoiceBubble
        }
        cell.contentView.addSubview(voiceMegBtn)
        let arr: [Any] = voiceUrl!.absoluteString.components(separatedBy: "/")
        
        let textLab = UILabel()
        textLab.text = arr.last as? String
        textLab.textAlignment = NSTextAlignment.right
        textLab.frame =  CGRect(x: ScreenWidth - CGFloat(160), y: CGFloat(15), width: CGFloat(150), height: CGFloat(30))
        textLab.font = UIFont(name: "STHeitiSC-Light", size: 14)
        cell.contentView.addSubview(textLab)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: ZFJVoiceBubbleDelegate
    func voiceBubbleStratOrStop(_ voiceBubble: ZFJVoiceBubble, _ isStart: Bool) {
        if(isStart){
            //开始
            for index in 0...(voiceMegBtnArr.count - 1) {
                let otherVoiceMegBtn = self.voiceMegBtnArr[index] as! ZFJVoiceBubble
                if(voiceBubble != otherVoiceMegBtn){
                    otherVoiceMegBtn.stop()
                }
            }
        }else{
            //结束
        }
    }
    
    func voiceBubbleDidStartPlaying(_ voiceBubble: ZFJVoiceBubble) {
        NSLog("voiceBubbleDidStartPlaying")
    }
    
    // MARK: - 隐藏多余的cell分界面
    func setExtraCellLineHidden(_ tableView: UITableView) {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        tableView.tableFooterView = view
        tableView.tableHeaderView = view
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

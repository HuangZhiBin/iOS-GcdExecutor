//
//  DispatchGlobalViewController.swift
//  GcdExecutor
//
//  Created by bin on 2018/12/29.
//  Copyright © 2018年 BinHuang. All rights reserved.
//

import UIKit

class DispatchGroupViewController: UIViewController {
    
    lazy var label : UILabel! = {
        let label = UILabel.init(frame: CGRect.init(x: 10, y: 140, width: 320, height: 500));
        label.numberOfLines = 0;
        label.font = UIFont.systemFont(ofSize: 14);
        label.textColor = UIColor.black
        label.text = "在这里显示运行结果:";
        label.sizeToFit();
        return label;
    }();
    
    lazy var btn : UIButton! = {
        let btn : UIButton = UIButton.init(type: .system);
        btn.frame = CGRect.init(x: 10, y: 70, width: 80, height: 50);
        btn.layer.masksToBounds = true;
        btn.layer.cornerRadius = 3;
        btn.setTitle("notify()", for: .normal);
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(UIColor.white, for: .normal);
        btn.backgroundColor = UIColor.blue;
        return btn;
    }();
    
    lazy var btn2 : UIButton! = {
        let btn : UIButton = UIButton.init(type: .system);
        btn.frame = CGRect.init(x: 100, y: 70, width: 120, height: 50);
        btn.layer.masksToBounds = true;
        btn.layer.cornerRadius = 3;
        btn.setTitle("wait(forever)", for: .normal);
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(UIColor.white, for: .normal);
        btn.backgroundColor = UIColor.blue;
        return btn;
    }();
    
    lazy var btn3 : UIButton! = {
        let btn : UIButton = UIButton.init(type: .system);
        btn.frame = CGRect.init(x: 230, y: 70, width: 120, height: 50);
        btn.layer.masksToBounds = true;
        btn.layer.cornerRadius = 3;
        btn.setTitle("wait(1 second)", for: .normal);
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(UIColor.white, for: .normal);
        btn.backgroundColor = UIColor.blue;
        return btn;
    }();

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "QueueGroup";
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white;
        // Do any additional setup after loading the view.
        
        self.view.addSubview(self.label);
        self.view.addSubview(self.btn);
        self.view.addSubview(self.btn2);
        self.view.addSubview(self.btn3);
        
        self.btn.addTarget(self, action: #selector(self.execAction(_:)), for: .touchUpInside);
        self.btn2.addTarget(self, action: #selector(self.execAction(_:)), for: .touchUpInside);
        self.btn3.addTarget(self, action: #selector(self.execAction(_:)), for: .touchUpInside);
    }
    
    @objc func execAction(_ btn: UIButton){
        
        self.label.text = "在这里显示运行结果:";
        
        if(self.btn == btn){
            self.executeQueue1();
        }
        else if(self.btn2 == btn){
            self.executeQueue2();
        }
        else if(self.btn3 == btn){
            self.executeQueue3();
        }
    }
    
    func log(_ text : String,_ thread : Thread){
        print(text + ": \(thread)")
        DispatchQueue.main.async {
            self.label.text = self.label.text! + "\n" + text;
            self.label.sizeToFit();
            var newframe = self.label.frame;
            newframe.size.width = 320;
            self.label.frame = newframe;
        }
    }
    
    func executeQueue1(){
        let concurrentQueue = DispatchQueue(label: "com.dianbo.concurrentQueue", attributes: .concurrent)
        
        let group = DispatchGroup.init();
        
        concurrentQueue.async(group: group) {
            self.log("并行队列中同步执行的第1个任务", Thread.current);
            sleep(4);
        }
        
        concurrentQueue.async(group: group) {
            self.log("并行队列中同步执行的第2个任务", Thread.current);
            sleep(2)
        }
        
        concurrentQueue.async(group: group) {
            self.log("并行队列中同步执行的第3个任务", Thread.current);
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.log("done doing all stuff", Thread.current);
        }
    }
    
    func executeQueue2(){
        let concurrentQueue = DispatchQueue(label: "com.dianbo.concurrentQueue", attributes: .concurrent)
        
        let group = DispatchGroup.init();
        
        concurrentQueue.async(group: group) {
            self.log("并行队列中同步执行的第1个任务", Thread.current);
            sleep(4);
        }
        
        concurrentQueue.async(group: group) {
            self.log("并行队列中同步执行的第2个任务", Thread.current);
            sleep(2)
        }
        
        concurrentQueue.async(group: group) {
            self.log("并行队列中同步执行的第3个任务", Thread.current);
        }
        
        group.wait(timeout: DispatchTime.distantFuture);//同步一直等待,当前线程停止
        self.log("done doing all stuffs", Thread.current);
    }
    
    func executeQueue3(){
        let concurrentQueue = DispatchQueue(label: "com.dianbo.concurrentQueue", attributes: .concurrent)
        
        let group = DispatchGroup.init();
        
        concurrentQueue.async(group: group) {
            self.log("并行队列中同步执行的第1个任务", Thread.current);
            sleep(4);
        }
        
        concurrentQueue.async(group: group) {
            self.log("并行队列中同步执行的第2个任务", Thread.current);
            sleep(2)
        }
        
        concurrentQueue.async(group: group) {
            self.log("并行队列中同步执行的第3个任务", Thread.current);
        }
        
        let result = group.wait(timeout: DispatchTime.now() + 1.00);//同步一直等待
        if(result == .success){
            self.log("done doing all stuffs after 1 second", Thread.current);
        }
        else{
            self.log("still doing stuffs after 1 second", Thread.current);
        }
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

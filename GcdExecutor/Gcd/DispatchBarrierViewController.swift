//
//  DispatchGlobalViewController.swift
//  GcdExecutor
//
//  Created by bin on 2018/12/29.
//  Copyright © 2018年 BinHuang. All rights reserved.
//

import UIKit

class DispatchBarrierViewController: UIViewController {
    
    lazy var label : UILabel! = {
        let label = UILabel.init(frame: CGRect.init(x: 10, y: 210, width: 320, height: 500));
        label.numberOfLines = 0;
        label.font = UIFont.systemFont(ofSize: 14);
        label.textColor = UIColor.black
        label.text = "在这里显示运行结果:";
        label.sizeToFit();
        return label;
    }();
    
    lazy var btn : UIButton! = {
        let btn : UIButton = UIButton.init(type: .system);
        btn.frame = CGRect.init(x: 10, y: 70, width: 160, height: 50);
        btn.layer.masksToBounds = true;
        btn.layer.cornerRadius = 3;
        btn.setTitle("执行不安全的async", for: .normal);
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(UIColor.white, for: .normal);
        btn.backgroundColor = UIColor.blue;
        return btn;
    }();
    
    lazy var btn2 : UIButton! = {
        let btn : UIButton = UIButton.init(type: .system);
        btn.frame = CGRect.init(x: 190, y: 70, width: 160, height: 50);
        btn.layer.masksToBounds = true;
        btn.layer.cornerRadius = 3;
        btn.setTitle("barrier给global队列", for: .normal);
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(UIColor.white, for: .normal);
        btn.backgroundColor = UIColor.blue;
        return btn;
    }();
    
    lazy var btn3 : UIButton! = {
        let btn : UIButton = UIButton.init(type: .system);
        btn.frame = CGRect.init(x: 10, y: 140, width: 200, height: 50);
        btn.layer.masksToBounds = true;
        btn.layer.cornerRadius = 3;
        btn.setTitle("barrier给自定义并行队列", for: .normal);
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(UIColor.white, for: .normal);
        btn.backgroundColor = UIColor.blue;
        return btn;
    }();

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Barrier数据一致";
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
    
    @objc func execAction(_ btn : UIButton){
        self.label.text = "在这里显示运行结果:";
        if(btn == self.btn){
            self.executeNormalQueue();
        }
        else if(btn == self.btn2){
            self.executeBarrierQueue();
        }
        else if(btn == self.btn3){
            self.executeBarrierQueue2();
        }
    }
    
    func log(_ text : String,_ thread : Thread){
        print(text + ": 当前线程的hash为\(thread.hash)")
        DispatchQueue.main.async {
            self.label.text = self.label.text! + "\n" + text;
            self.label.sizeToFit();
            var newframe = self.label.frame;
            newframe.size.width = 320;
            self.label.frame = newframe;
        }
    }
    
    func executeNormalQueue(){
        let queue = DispatchQueue.global(qos: .default);
        var a = "12345";
        queue.async {
            self.log("> 1 任务开始执行", Thread.current)
            self.log("  < 1.a的值是" + a, Thread.current)
        }
        queue.async {
            self.log("> 2 任务开始执行", Thread.current)
            self.log("  < 2.a的值是" + a, Thread.current)
        }
        queue.async {
            self.log("> 3 任务开始执行", Thread.current)
            self.log("  < 3.a的值是" + a, Thread.current)
        }
        queue.async {
            a = "54321";
            self.log("======a的值修改为" + a + "======", Thread.current)
        }
        queue.async {
            self.log("> 4 任务开始执行", Thread.current)
            self.log("  < 4.a的值是" + a, Thread.current)
        }
        queue.async {
            self.log("> 5 任务开始执行", Thread.current)
            self.log("  < 5.a的值是" + a, Thread.current)
        }
        queue.async {
            self.log("> 6 任务开始执行", Thread.current)
            self.log("  < 6.a的值是" + a, Thread.current)
        }
    }
    
    func executeBarrierQueue(){
        let queue = DispatchQueue.global(qos: .default);
        var a = "12345";
        queue.async {
            self.log("> 1 任务开始执行", Thread.current)
            self.log("  < 1.a的值是" + a, Thread.current)
        }
        queue.async {
            self.log("> 2 任务开始执行", Thread.current)
            self.log("  < 2.a的值是" + a, Thread.current)
        }
        queue.async {
            self.log("> 3 任务开始执行", Thread.current)
            self.log("  < 3.a的值是" + a, Thread.current)
        }
        queue.async(flags: .barrier){
            a = "54321";
            self.log("======a的值修改为" + a + "======", Thread.current)
        }
        queue.async {
            self.log("> 4 任务开始执行", Thread.current)
            self.log("  < 4.a的值是" + a, Thread.current)
        }
        queue.async {
            self.log("> 5 任务开始执行", Thread.current)
            self.log("  < 5.a的值是" + a, Thread.current)
        }
        queue.async {
            self.log("> 6 任务开始执行", Thread.current)
            self.log("  < 6.a的值是" + a, Thread.current)
        }
    }
    
    func executeBarrierQueue2(){
        let queue = DispatchQueue(label: "com.dianbo.concurrentQueue", attributes: .concurrent)
        var a = "12345";
        queue.async {
            self.log("> 1 任务开始执行", Thread.current)
            self.log("  < 1.a的值是" + a, Thread.current)
        }
        queue.async {
            self.log("> 2 任务开始执行", Thread.current)
            self.log("  < 2.a的值是" + a, Thread.current)
        }
        queue.async {
            self.log("> 3 任务开始执行", Thread.current)
            self.log("  < 3.a的值是" + a, Thread.current)
        }
        queue.async(flags: .barrier){
            a = "54321";
            self.log("======a的值修改为" + a + "======", Thread.current)
        }
        queue.async {
            self.log("> 4 任务开始执行", Thread.current)
            self.log("  < 4.a的值是" + a, Thread.current)
        }
        queue.async {
            self.log("> 5 任务开始执行", Thread.current)
            self.log("  < 5.a的值是" + a, Thread.current)
        }
        queue.async {
            self.log("> 6 任务开始执行", Thread.current)
            self.log("  < 6.a的值是" + a, Thread.current)
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

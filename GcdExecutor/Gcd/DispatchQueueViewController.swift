//
//  DispatchQueueViewController.swift
//  GcdExecutor
//
//  Created by bin on 2018/12/29.
//  Copyright © 2018年 BinHuang. All rights reserved.
//

import UIKit

class DispatchQueueViewController: UIViewController {
    
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
        btn.frame = CGRect.init(x: 10, y: 70, width: 120, height: 50);
        btn.layer.masksToBounds = true;
        btn.layer.cornerRadius = 3;
        btn.setTitle("执行serial", for: .normal);
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(UIColor.white, for: .normal);
        btn.backgroundColor = UIColor.blue;
        return btn;
    }();
    
    lazy var btn2 : UIButton! = {
        let btn : UIButton = UIButton.init(type: .system);
        btn.frame = CGRect.init(x: 150, y: 70, width: 120, height: 50);
        btn.layer.masksToBounds = true;
        btn.layer.cornerRadius = 3;
        btn.setTitle("执行concurrent", for: .normal);
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(UIColor.white, for: .normal);
        btn.backgroundColor = UIColor.blue;
        return btn;
    }();

    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.title = "Serial Queue 与 Concurrent Queue";
        
        self.view.backgroundColor = UIColor.white;
        // Do any additional setup after loading the view.
        
        self.view.addSubview(self.label);
        self.view.addSubview(self.btn);
        self.view.addSubview(self.btn2);
        self.btn.addTarget(self, action: #selector(self.execAction(_:)), for: .touchUpInside);
        self.btn2.addTarget(self, action: #selector(self.execAction(_:)), for: .touchUpInside);
    }
    
    @objc func execAction(_ btn : UIButton){
        self.label.text = "在这里显示运行结果:";
        if(btn == self.btn){
            self.executeSerialQueue();
        }
        else if(btn == self.btn2){
            self.executeConcurrentQueue();
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
    
    func executeConcurrentQueue(){
        let concurrentQueue = DispatchQueue(label: "com.dianbo.concurrentQueue", attributes: .concurrent)
        
        concurrentQueue.async {
            self.log("并行队列中同步执行的第1个任务", Thread.current);
            sleep(4);
        }
        
        concurrentQueue.async {
            self.log("并行队列中同步执行的第2个任务", Thread.current);
            sleep(2)
        }
        
        concurrentQueue.async {
            self.log("并行队列中同步执行的第3个任务", Thread.current);
        }
    }
    
    func executeSerialQueue(){
        let serialQueue = DispatchQueue(label: "com.dianbo.serialQueue");
        
        serialQueue.async {
            self.log("串行队列中同步执行的第1个任务", Thread.current);
            sleep(4)
        }
        
        serialQueue.async {
            self.log("串行队列中同步执行的第2个任务", Thread.current);
            sleep(2)
        }
        
        serialQueue.async {
            self.log("串行队列中同步执行的第3个任务", Thread.current);
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

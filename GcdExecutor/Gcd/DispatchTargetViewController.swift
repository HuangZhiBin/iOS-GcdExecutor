//
//  DispatchGlobalViewController.swift
//  GcdExecutor
//
//  Created by bin on 2018/12/29.
//  Copyright © 2018年 BinHuang. All rights reserved.
//

import UIKit

class DispatchTargetViewController: UIViewController {
    
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
        btn.setTitle("执行", for: .normal);
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(UIColor.white, for: .normal);
        btn.backgroundColor = UIColor.blue;
        return btn;
    }();

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "修改Queue执行的优先级";
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white;
        // Do any additional setup after loading the view.
        
        self.view.addSubview(self.label);
        self.view.addSubview(self.btn);
        
        self.btn.addTarget(self, action: #selector(self.execAction), for: .touchUpInside);
    }
    
    @objc func execAction(){
        self.label.text = "在这里显示运行结果:";
        self.executeGlobalQueue();
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
    
    func executeGlobalQueue(){
        let concurrentQueue = DispatchQueue(label: "com.dianbo.concurrentQueue", attributes: .concurrent)
        let serialQueue = DispatchQueue(label: "com.dianbo.serialQueue");
        
        concurrentQueue.async {
            self.log("并行队列中同步执行的第1个任务", Thread.current);
            sleep(4);
        }
        
        serialQueue.async {
            self.log("串行队列中同步执行的第1个任务", Thread.current);
            sleep(4)
        }
        
        concurrentQueue.suspend();
        //在活动的队列中使用会造成崩溃
        concurrentQueue.setTarget(queue: DispatchQueue.global(qos: .default));
        concurrentQueue.resume();
        serialQueue.setTarget(queue: DispatchQueue.global(qos: .default));
        
        concurrentQueue.async {
            self.log("并行队列中同步执行的第2个任务", Thread.current);
            sleep(2)
        }
        
        concurrentQueue.async {
            self.log("并行队列中同步执行的第3个任务", Thread.current);
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

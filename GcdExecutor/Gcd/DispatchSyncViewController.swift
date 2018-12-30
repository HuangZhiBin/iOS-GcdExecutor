//
//  DispatchGlobalViewController.swift
//  GcdExecutor
//
//  Created by bin on 2018/12/29.
//  Copyright © 2018年 BinHuang. All rights reserved.
//

import UIKit

class DispatchSyncViewController: UIViewController {
    
    lazy var label : UILabel! = {
        let label = UILabel.init(frame: CGRect.init(x: 10, y: 270, width: 320, height: 500));
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
        btn.setTitle("执行sync", for: .normal);
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(UIColor.white, for: .normal);
        btn.backgroundColor = UIColor.blue;
        return btn;
    }();
    
    lazy var btn2 : UIButton! = {
        let btn : UIButton = UIButton.init(type: .system);
        btn.frame = CGRect.init(x: 210, y: 70, width: 160, height: 50);
        btn.layer.masksToBounds = true;
        btn.layer.cornerRadius = 3;
        btn.setTitle("主线程执行sync的死锁", for: .normal);
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
        btn.setTitle("主线程async执行sync的死锁", for: .normal);
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(UIColor.white, for: .normal);
        btn.backgroundColor = UIColor.blue;
        return btn;
    }();
    
    lazy var btn4 : UIButton! = {
        let btn : UIButton = UIButton.init(type: .system);
        btn.frame = CGRect.init(x: 10, y: 210, width: 200, height: 50);
        btn.layer.masksToBounds = true;
        btn.layer.cornerRadius = 3;
        btn.setTitle("串行队列执行sync的死锁", for: .normal);
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(UIColor.white, for: .normal);
        btn.backgroundColor = UIColor.blue;
        return btn;
    }();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Sync同步";
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white;
        // Do any additional setup after loading the view.
        
        self.view.addSubview(self.label);
        self.view.addSubview(self.btn);
        self.view.addSubview(self.btn2);
        self.view.addSubview(self.btn3);
        self.view.addSubview(self.btn4);
        
        self.btn.addTarget(self, action: #selector(self.execAction(_:)), for: .touchUpInside);
        self.btn2.addTarget(self, action: #selector(self.execAction(_:)), for: .touchUpInside);
        self.btn3.addTarget(self, action: #selector(self.execAction(_:)), for: .touchUpInside);
        self.btn4.addTarget(self, action: #selector(self.execAction(_:)), for: .touchUpInside);
    }
    
    @objc func execAction(_ btn : UIButton){
        self.label.text = "在这里显示运行结果:";
        if(btn == self.btn){
            self.executeSync1();
        }
        else if(btn == self.btn2){
            self.executeSync2();
        }
        else if(btn == self.btn3){
            self.executeSync3();
        }
        else if(btn == self.btn4){
            self.executeSync4();
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
    
    func executeSync1(){
        let globalQueue = DispatchQueue.global(qos: .default);
        globalQueue.async {
            self.log("globalQueue.async", Thread.current);
        }
        globalQueue.sync {
            self.log("globalQueue.sync", Thread.current);
        }
    }
    
    func executeSync2(){
        let mainQueue = DispatchQueue.main
        mainQueue.sync {
            self.log("main.sync", Thread.current);
        }
    }
    
    func executeSync3(){
        let mainQueue = DispatchQueue.main
        mainQueue.async {
            mainQueue.sync {
                self.log("main.sync", Thread.current);
            }
        }
    }
    
    func executeSync4(){
        let serialQueue = DispatchQueue(label: "com.dianbo.serialQueue");
        serialQueue.async {
            serialQueue.sync {
                self.log("serialQueue.sync", Thread.current);
            }
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


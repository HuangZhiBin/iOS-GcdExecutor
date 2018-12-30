//
//  DispatchGlobalViewController.swift
//  GcdExecutor
//
//  Created by bin on 2018/12/29.
//  Copyright © 2018年 BinHuang. All rights reserved.
//

import UIKit

class DispatchGlobalViewController: UIViewController {
    
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

        self.title = "系统级Global Queue";
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
        print(text + ": 当前线程的hash为\(thread.hash)")
        DispatchQueue.main.async {
            self.label.text = self.label.text! + "\n" + text;
            self.label.sizeToFit();
            var newframe = self.label.frame;
            newframe.size.width = 320;
            self.label.frame = newframe;
        }
    }
    
    func executeGlobalQueue(){
        DispatchQueue.global(qos: .background).async {
            self.log("background任务", Thread.current);
            sleep(4);
        }
        
        DispatchQueue.global(qos: .utility).async {
            self.log("utility任务", Thread.current);
            sleep(2)
        }
        
        DispatchQueue.global(qos: .default).async {
            self.log("default任务", Thread.current);
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.log("userInitiated任务", Thread.current);
        }
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.log("userInteractive任务", Thread.current);
        }
        
        DispatchQueue.global(qos: .unspecified).async {
            self.log("unspecified任务", Thread.current);
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

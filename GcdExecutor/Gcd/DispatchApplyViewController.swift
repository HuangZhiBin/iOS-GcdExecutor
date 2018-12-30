//
//  DispatchGlobalViewController.swift
//  GcdExecutor
//
//  Created by bin on 2018/12/29.
//  Copyright © 2018年 BinHuang. All rights reserved.
//

import UIKit

class DispatchApplyViewController: UIViewController {
    
    lazy var label : UILabel! = {
        let label = UILabel.init(frame: CGRect.init(x: 10, y: 130, width: 320, height: 500));
        label.numberOfLines = 0;
        label.font = UIFont.systemFont(ofSize: 14);
        label.textColor = UIColor.black
        label.text = "在这里显示运行结果:";
        label.sizeToFit();
        return label;
    }();
    
    lazy var btn : UIButton! = {
        let btn : UIButton = UIButton.init(type: .system);
        btn.frame = CGRect.init(x: 10, y: 70, width: 100, height: 50);
        btn.layer.masksToBounds = true;
        btn.layer.cornerRadius = 3;
        btn.setTitle("执行apply", for: .normal);
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(UIColor.white, for: .normal);
        btn.backgroundColor = UIColor.blue;
        return btn;
    }();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Apply";
        self.view.backgroundColor = UIColor.white;
        
        self.view.addSubview(self.label);
        self.view.addSubview(self.btn);
        self.btn.addTarget(self, action: #selector(self.execAction(_:)), for: .touchUpInside);
    }
    
    @objc func execAction(_ btn : UIButton){
        self.label.text = "在这里显示运行结果:";
        if(btn == self.btn){
            self.executeSync1();
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
    
    let globalQueue = DispatchQueue(label: "com.dianbo.concurrentQueue", attributes: .concurrent)//DispatchQueue.global(qos: .default);
    
    func executeSync1(){
        
        globalQueue.async {
            DispatchQueue.concurrentPerform(iterations: 15) {
                self.log("\($0)", Thread.current);
                sleep(1);
            }
            self.log("DispatchQueue.concurrentPerform done", Thread.current);
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

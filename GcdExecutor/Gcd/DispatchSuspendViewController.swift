//
//  DispatchGlobalViewController.swift
//  GcdExecutor
//
//  Created by bin on 2018/12/29.
//  Copyright © 2018年 BinHuang. All rights reserved.
//

import UIKit

class DispatchSuspendViewController: UIViewController {
    
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
        btn.setTitle("执行queue", for: .normal);
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(UIColor.white, for: .normal);
        btn.backgroundColor = UIColor.blue;
        return btn;
    }();
    
    lazy var btn2 : UIButton! = {
        let btn : UIButton = UIButton.init(type: .system);
        btn.frame = CGRect.init(x: 120, y: 70, width: 100, height: 50);
        btn.layer.masksToBounds = true;
        btn.layer.cornerRadius = 3;
        btn.setTitle("suspend", for: .normal);
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(UIColor.white, for: .normal);
        btn.backgroundColor = UIColor.blue;
        return btn;
    }();
    
    lazy var btn3 : UIButton! = {
        let btn : UIButton = UIButton.init(type: .system);
        btn.frame = CGRect.init(x: 230, y: 70, width: 100, height: 50);
        btn.layer.masksToBounds = true;
        btn.layer.cornerRadius = 3;
        btn.setTitle("resume", for: .normal);
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
        self.view.addSubview(self.btn2);
        self.view.addSubview(self.btn3);
        self.btn.addTarget(self, action: #selector(self.execAction(_:)), for: .touchUpInside);
        self.btn2.addTarget(self, action: #selector(self.execAction(_:)), for: .touchUpInside);
        self.btn3.addTarget(self, action: #selector(self.execAction(_:)), for: .touchUpInside);
    }
    
    @objc func execAction(_ btn : UIButton){
        
        if(btn == self.btn){
            self.label.text = "在这里显示运行结果:";
            self.executeSync1();
        }
        else if(btn == self.btn2){
            self.label.text = "will suspend";
            self.executeSync2();
        }
        else if(btn == self.btn3){
            self.label.text = "will resume";
            self.executeSync3();
        }
    }
    
    func log(_ text : String,_ thread : Thread){
        print(text + ": \(thread)")
        DispatchQueue.main.async {
            if((self.label.text! as NSString).length >= 100){
                self.label.text = "在这里显示运行结果:";
            }
            self.label.text = self.label.text! + "\n" + text;
            self.label.sizeToFit();
            var newframe = self.label.frame;
            newframe.size.width = 320;
            self.label.frame = newframe;
        }
    }
    
    var concurrentQueue : DispatchQueue! = DispatchQueue(label: "com.dianbo.concurrentQueue", attributes: .concurrent)
    
    func executeSync1(){
        for index in 0...50{
            concurrentQueue.async {
                self.log("\(index)", Thread.current);
                sleep(2)
            }
        }
        
    }
    
    func executeSync2(){
        
        concurrentQueue.suspend()
        for index in 51...100{
            concurrentQueue.async {
                self.log("\(index)", Thread.current);
                sleep(2)
            }
        }
    }
    
    func executeSync3(){
        
        concurrentQueue.resume()
        
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

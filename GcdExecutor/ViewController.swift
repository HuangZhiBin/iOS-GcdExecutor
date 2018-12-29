//
//  ViewController.swift
//  GcdDownload
//
//  Created by bin on 2018/12/29.
//  Copyright © 2018年 BinHuang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var btn : UIButton! = {
        let btn : UIButton = UIButton.init(type: .system);
        btn.frame = CGRect.init(x: 10, y: 100, width: 320, height: 50);
        btn.layer.masksToBounds = true;
        btn.layer.cornerRadius = 3;
        btn.setTitle("Serial Queue 与 Concurrent Queue", for: .normal);
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(UIColor.white, for: .normal);
        btn.backgroundColor = UIColor.blue;
        return btn;
    }();
    
    lazy var btn2 : UIButton! = {
        let btn : UIButton = UIButton.init(type: .system);
        btn.frame = CGRect.init(x: 10, y: 160, width: 320, height: 50);
        btn.layer.masksToBounds = true;
        btn.layer.cornerRadius = 3;
        btn.setTitle("系统级Global Queue", for: .normal);
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(UIColor.white, for: .normal);
        btn.backgroundColor = UIColor.blue;
        return btn;
    }();
    
    lazy var btn3 : UIButton! = {
        let btn : UIButton = UIButton.init(type: .system);
        btn.frame = CGRect.init(x: 10, y: 220, width: 320, height: 50);
        btn.layer.masksToBounds = true;
        btn.layer.cornerRadius = 3;
        btn.setTitle("修改Queue执行的优先级", for: .normal);
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(UIColor.white, for: .normal);
        btn.backgroundColor = UIColor.blue;
        return btn;
    }();
    
    lazy var btn4 : UIButton! = {
        let btn : UIButton = UIButton.init(type: .system);
        btn.frame = CGRect.init(x: 10, y: 280, width: 320, height: 50);
        btn.layer.masksToBounds = true;
        btn.layer.cornerRadius = 3;
        btn.setTitle("延迟执行", for: .normal);
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(UIColor.white, for: .normal);
        btn.backgroundColor = UIColor.blue;
        return btn;
    }();
    
    lazy var btn5 : UIButton! = {
        let btn : UIButton = UIButton.init(type: .system);
        btn.frame = CGRect.init(x: 10, y: 340, width: 320, height: 50);
        btn.layer.masksToBounds = true;
        btn.layer.cornerRadius = 3;
        btn.setTitle("DispatchGroup", for: .normal);
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(UIColor.white, for: .normal);
        btn.backgroundColor = UIColor.blue;
        return btn;
    }();
    
    lazy var btn6 : UIButton! = {
        let btn : UIButton = UIButton.init(type: .system);
        btn.frame = CGRect.init(x: 10, y: 400, width: 320, height: 50);
        btn.layer.masksToBounds = true;
        btn.layer.cornerRadius = 3;
        btn.setTitle("Barrier数据一致", for: .normal);
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(UIColor.white, for: .normal);
        btn.backgroundColor = UIColor.blue;
        return btn;
    }();

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white;
        self.title = "GCD例子";
        
        
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(self.btn);
        self.btn.addTarget(self, action: #selector(self.actions(_:)), for: .touchUpInside);
        
        self.view.addSubview(self.btn2);
        self.btn2.addTarget(self, action: #selector(self.actions(_:)), for: .touchUpInside);
        
        // self.view.addSubview(self.btn3);
        // self.btn3.addTarget(self, action: #selector(self.actions(_:)), for: .touchUpInside);
        
        self.view.addSubview(self.btn4);
        self.btn4.addTarget(self, action: #selector(self.actions(_:)), for: .touchUpInside);
        
        self.view.addSubview(self.btn5);
        self.btn5.addTarget(self, action: #selector(self.actions(_:)), for: .touchUpInside);
        
        self.view.addSubview(self.btn6);
        self.btn6.addTarget(self, action: #selector(self.actions(_:)), for: .touchUpInside);
    }
    
    @objc func actions(_ btn : UIButton){
        if(btn == self.btn){
            let vc = DispatchQueueViewController();
            self.show(vc, sender: nil);
        }
        else if(btn == self.btn2){
            let vc = DispatchGlobalViewController();
            self.show(vc, sender: nil);
        }
        else if(btn == self.btn3){
            let vc = DispatchTargetViewController();
            self.show(vc, sender: nil);
        }
        else if(btn == self.btn4){
            let vc = DispatchAfterViewController();
            self.show(vc, sender: nil);
        }
        else if(btn == self.btn5){
            let vc = DispatchGroupViewController();
            self.show(vc, sender: nil);
        }
        else if(btn == self.btn6){
            let vc = DispatchBarrierViewController();
            self.show(vc, sender: nil);
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


//
//  DispatchGlobalViewController.swift
//  GcdExecutor
//
//  Created by bin on 2018/12/29.
//  Copyright © 2018年 BinHuang. All rights reserved.
//

import UIKit

class DispatchSemaphoreViewController: UIViewController {
    
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
        btn.frame = CGRect.init(x: 10, y: 70, width: 180, height: 50);
        btn.layer.masksToBounds = true;
        btn.layer.cornerRadius = 3;
        btn.setTitle("执行semaphore", for: .normal);
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(UIColor.white, for: .normal);
        btn.backgroundColor = UIColor.blue;
        return btn;
    }();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "semaphore信号量";
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
        print(text + ": 当前线程的hash为\(thread.hash)")
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
        let semaphore = DispatchSemaphore(value: 1) //设置semaphore的初始量为1
        let queue = DispatchQueue(label: "com.leo.concurrentQueue", qos: .default, attributes: .concurrent)
        
        queue.async {
            //semaphore>0继续执行，==0则等待
            semaphore.wait()
            
            //此时，semaphore--
            self.log("Start usb task1",Thread.current)
            sleep(3)
            self.log("End usb task1",Thread.current)
            
            semaphore.signal()
            //此时，semaphore++
        }
        
        queue.async {
            semaphore.wait()
            
            self.log("Start usb task2",Thread.current)
            sleep(3)
            self.log("End usb task2",Thread.current)
            
            semaphore.signal()
        }
        
        queue.async {
            semaphore.wait()
            
            self.log("Start usb task3",Thread.current)
            sleep(3)
            self.log("End usb task3",Thread.current)
            
            semaphore.signal()
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

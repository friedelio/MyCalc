//
//  ViewController.swift
//  MyCalc
//
//  Created by friedel arendt on 24.07.16.
//  Copyright © 2016 friedel arendt. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // z.b. initiale werte laden...
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet private weak var digLB: UILabel!
    
    @IBOutlet private weak var hist: UILabel!
    
    private var dispval: Double {
        get { return Double(digLB.text!)!}
        set {
            //if String(newValue).rangeOfString(".") == nil
            if String(Double(Int(newValue))) == String(Double(newValue))
            {
                digLB.text = String(Int(newValue))
                
            }
            else
            {
                digLB.text = String(newValue)
            }
        }
    }
    
    
    private var cb = CalcBrain()  // das model-objekt
    private var isUsrTyping = false  // steuerung
    private var isTypingNK  = false
    private var isNewval = true

    
    
    @IBAction private func digitBT(sender: UIButton)
    {
        if let dt = sender.currentTitle
        {
            if isUsrTyping
            {
                if dt == "."
                {
                    if !isTypingNK
                    {
                        isTypingNK = true
                        if digLB.text! != "."
                        {
                            digLB.text! += dt
                            hist.text! += dt
                        }
                    }
                }
                else
                {
                    digLB.text! += dt
                    hist.text! += dt
                }
            }
            else
            {
                digLB.text! = dt
                
                if isNewval
                {
                    hist.text! = dt
                    isNewval = false
                }
                else
                {
                    hist.text! += dt
                }
            }
            isUsrTyping = true
        }
    }
    
    @IBAction func performOP(sender: UIButton) {
        if isUsrTyping {
            cb.setOperand(dispval)
            isUsrTyping = false
            isTypingNK  = false
        }
        if let mathsymbol = sender.currentTitle {
            hist.text! += mathsymbol
            cb.performOperation(mathsymbol)
            if !cb.OPisPending && mathsymbol == "="
            {
                isNewval = true
            }
        }
        dispval = cb.result
    }
}


//
//  CalcBrain.swift
//  MyCalc
//
//  Created by friedel arendt on 24.07.16.
//  Copyright © 2016 friedel arendt. All rights reserved.
//

import Foundation


class CalcBrain {
    
    private var accumulator: Double = 0.0
    var OPisPending = false
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinOperation((Double, Double) -> Double)
        case Equals // ohne wert
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "√": Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos), // (double) -> double
        "sin" : Operation.UnaryOperation(sin),
        "abs" : Operation.UnaryOperation(abs),
        "+/-" : Operation.UnaryOperation({ -$0 }),
        "*" : Operation.BinOperation({ $0 * $1 }), // (double, double) -> double
        "/" : Operation.BinOperation({ $0 / $1 }),
        "-" : Operation.BinOperation({ $0 - $1 }),
        "+" : Operation.BinOperation({ $0 + $1 }),
        // was noch??
        "=" : Operation.Equals,
    ]
    
    
    private func execPendingBinOp() {
        if pending != nil {
            accumulator = pending!.binFunc(pending!.firstOperand, accumulator)
            pending = nil
            OPisPending = false
        }
    }
    
    
    private var pending: PendingBinOpInfo?
    
    private struct PendingBinOpInfo {
        var binFunc: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    var result: Double{get{return accumulator}}
    
    func setOperand	(operand: Double) {
        accumulator = operand
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value): accumulator = value
            case .UnaryOperation(let function): accumulator = function(accumulator)
            case .BinOperation(let function):
                OPisPending = true
                execPendingBinOp()
                pending = PendingBinOpInfo(binFunc: function, firstOperand: accumulator)
                
            case .Equals: execPendingBinOp()
                
            }
        }
    }
    
}

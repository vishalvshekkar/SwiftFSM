//
//  ViewController.swift
//  SwiftFSM
//
//  Created by Vishal V. Shekkar on 25/10/16.
//  Copyright © 2016 Vishal V. Shekkar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var stateLabel: UILabel!
    
    enum TurnstileState {
        case locked
        case unlocked
    }
    
    enum TurnstileTrigger {
        case insertCoin
        case push
    }
    private typealias TurnstileMachineSchema = SwiftFSMSchema<TurnstileState, TurnstileTrigger>
    
    private var turnstileMachineSchema = TurnstileMachineSchema(initialState: .locked) { (presentState, trigger) -> ViewController.TurnstileState in
        var toState: TurnstileState
        switch presentState {
        case .locked:
            switch trigger {
            case .insertCoin:
                toState = .unlocked
            case .push:
                toState = .locked
            }
        case .unlocked:
            switch trigger {
            case .insertCoin:
                toState = .unlocked
            case .push:
                toState = .locked
            }
        }
        return toState
    }
    private var turnstileMachine: SwiftFSM<TurnstileMachineSchema>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        turnstileMachine = SwiftFSM(schema: turnstileMachineSchema)
        turnstileMachine?.logging = .logging(nil)
        turnstileMachine?.shouldMachineTransitState = { (_ fromState: TurnstileState, _ trigger: TurnstileTrigger, _ toState: TurnstileState) -> Bool in
            return true
        }
        turnstileMachine?.machineDidTransitState = { (_ fromState: TurnstileState, _ trigger: TurnstileTrigger, _ toState: TurnstileState) -> () in
            self.stateLabel.text = "\(toState)"
        }
    }
    
    @IBAction func insertCoin(_ sender: AnyObject) {
        turnstileMachine?.trigger(.insertCoin)
    }
    
    @IBAction func pushTurnstile(_ sender: AnyObject) {
        turnstileMachine?.trigger(.push)
    }

}


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
    
    ///Represents all the states a Turnstile can be in
    enum TurnstileState {
        case locked
        case unlocked
    }
    
    ///Represents all the triggers a Turnstile can perform
    enum TurnstileTrigger {
        case insertCoin
        case push
    }
    
    ///A `typealias` used to keep line sizes small in the declarations of `turnstileMachineSchema` and `turnstileMachine`. It's not necessary to do this. This is merely done for readability.
    private typealias TurnstileMachineSchema = SwiftFSMSchema<TurnstileState, TurnstileTrigger>
    
    ///A `SwiftFSMSchema` object with asociated types - `TurnstileState` and `TurnstileTrigger`
    private var turnstileMachineSchema = TurnstileMachineSchema(initialState: .locked) { (presentState, trigger) -> ViewController.TurnstileState in
        var toState: TurnstileState
        
        //The `switch` statements could be simplified further for the Turnstile as it has two loops in the graph. But, it's kept elaborated in this example to aid in understanding.
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
    
    ///The optional `SwiftFSM` object.
    private var turnstileMachine: SwiftFSM<TurnstileMachineSchema>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialization of the FSM with the schema object being passed
        turnstileMachine = SwiftFSM(schema: turnstileMachineSchema)
        
        //Setting the logging preference. This step is optional.
        turnstileMachine?.logging = .logging({(log: String) -> () in
            print(log) //Use any logging method you choose in this closure
        })
        
        //Defining the `shouldMachineTransitState` closure of the FSM. Do this only if you need to block state transition for some reason, or need to do something before the state transits. This step is optional.
        turnstileMachine?.shouldMachineTransitState = { (_ fromState: TurnstileState, _ trigger: TurnstileTrigger, _ toState: TurnstileState) -> Bool in
            return true
        }
        
        //Defining the `machineDidTransitState` closure of the FSM. Do this only if you need a trigger for all state changes. This step is optional.
        turnstileMachine?.machineDidTransitState = { (_ fromState: TurnstileState, _ trigger: TurnstileTrigger, _ toState: TurnstileState) -> () in
            self.stateLabel.text = "\(toState)"
        }
    }
    
    @IBAction func insertCoin(_ sender: AnyObject) {
        //Triggers the FSM with `.insertCoin` event.
        turnstileMachine?.trigger(.insertCoin)
    }
    
    @IBAction func pushTurnstile(_ sender: AnyObject) {
        //Triggers the FSM with `.push` event.
        turnstileMachine?.trigger(.push)
    }

}


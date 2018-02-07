//
//  SwiftFSM.swift
//  SwiftFSM
//
//  Created by Vishal V. Shekkar on 25/10/16.
//  Copyright © 2016 Vishal V. Shekkar. All rights reserved.
//

import Foundation

///`protocol` defining the characteristics and requirements of a SwiftFSM Schema.
public protocol SwiftFSMSchemaSpecification {
    
    associatedtype State
    associatedtype Trigger
    
    ///The state with which the FSM is initialized.
    var initialState: State {get}
    
    ///Specifies the entire transition logic.
    var transitionLogic: (_ state: State, _ trigger: Trigger) -> State {get}
    
    ///Initializes the schema object with an initial state and transition logic closure. The closure is `@escaping` because it is stored as a property in the
    init(initialState: State, transitionLogic: @escaping (_ state: State, _ trigger: Trigger) -> State)
    
}

///A `struct` conforming to `SwiftFSMSchemaSpecification` `protocol`. This can be used as the default schema for the `SwiftFSM` class. Alternately, you can define any `struct` to act as the schema for the `SwiftFSM` as long as it conforms to `SwiftFSMSchemaSpecification` `protocol`.
public struct SwiftFSMSchema<S, T>: SwiftFSMSchemaSpecification {
    
    public typealias State = S
    public typealias Trigger = T
    
    public var initialState: State
    public var transitionLogic: (_ state: State, _ trigger: Trigger) -> State
    
    public init(initialState: State, transitionLogic: @escaping (State, Trigger) -> State) {
        self.initialState = initialState
        self.transitionLogic = transitionLogic
    }
    
}

///This is the generic finite state machine class
public final class SwiftFSM<Schema: SwiftFSMSchemaSpecification> {
    
    ///Represents the state of the FSM at any given moment. Read-only.
    public private(set) var state: Schema.State
    
    ///The schema object is stored in this variable
    private let schema: Schema
    
    ///An optional closure that will be executed before transiting the state due to a trigger. The state will transition if the closure returns `true`. Otherwise, the FSM remains unchanged. If the closure itself is `nil`, the state change will happen as directed by the schema.
    public var shouldMachineTransitState: ((_ fromState: Schema.State, _ trigger: Schema.Trigger, _ toState: Schema.State) -> (Bool))?
    
    ///An optional closure that will be executed when a state transition occurs due to a trigger. The execution of this closure is subject to the result of `shouldMachineTransitState` if it's not a `nil`. Use this closure to perform actions based on any state changes.
    public var machineDidTransitState: ((_ fromState: Schema.State, _ trigger: Schema.Trigger, _ toState: Schema.State) -> ())?
    
    ///This `enum` represents the loggin preference. It defaults to `.logging(nil)` which uses a `print` statement to log.
    public var logging = SwiftFSMLogType.logging(nil)
    
    ///The only initializer for the `SwiftFSM`.
    /// - parameter schema: Represents all transitions of the FSM which is an object that conforms to `SwiftFSMSchemaSpecification` protocol.
    public init(schema: Schema) {
        self.schema = schema
        self.state = schema.initialState
    }
    
    ///The method which informs the FSM about a trigger. This method is solely responsible for handling all state changes, executing `shouldMachineTransitState` and `machineDidTransitState` closures and logging.
    /// - parameter trigger: The `Schema.Trigger` instance that represents a particular trigger.
    public func trigger(_ trigger: Schema.Trigger) {
        let toState = schema.transitionLogic(state, trigger)
        if let shouldMachineTransitState = shouldMachineTransitState {
            if shouldMachineTransitState(state, trigger, toState) {
                changeState(trigger: trigger, toState: toState)
            } else {
                handleLogging(fromState: state, trigger: trigger, toState: toState, transitStatus: .transitCancelled)
            }
        } else {
            changeState(trigger: trigger, toState: toState)
        }
    }
    
    ///Handles the state change. Modifies the `state` property and performs consecutive operations.
    private func changeState(trigger: Schema.Trigger, toState: Schema.State) {
        let oldState = state
        state = toState
        handleLogging(fromState: oldState, trigger: trigger, toState: state, transitStatus: .didTransit)
        machineDidTransitState?(oldState, trigger, state)
    }
    
    ///Handles logging of FSM transitions. It either logs using default `print` statement, or executes the closure for logging or restrains from logging based on the preference set on `logging`.
    private func handleLogging(fromState: Schema.State, trigger: Schema.Trigger, toState: Schema.State, transitStatus: SwiftFSMTransitStatus) {
        switch logging {
        case let .logging(some):
            let log = getLog(fromState: fromState, trigger: trigger, toState: toState, transitStatus: transitStatus)
            if let some = some { some(log) } else { print(log) }
        case .noLogging:
            break
        }
    }
    
    ///Provides the log text based on conditions.
    private func getLog(fromState: Schema.State, trigger: Schema.Trigger, toState: Schema.State, transitStatus: SwiftFSMTransitStatus) -> String {
        var log = transitStatus.rawValue
        log += "🔥\(trigger)🔥: \(fromState) → \(toState)"
        return log
    }
    
}

///Specifies the logging preference to the `SwiftFSM` class.
public enum SwiftFSMLogType {
    ///Does not log anything to the console
    case noLogging
    
    ///Logs every state change to the console. If the closure is `nil`, logging is done using a `print` statement. Otherwise, a `String` containing the log is passed to the closure as a parameter and that can be used to log to the console using the users' preferred means.
    case logging(((_ log: String) -> ())?)
}

///Used internally to specify the status of transition. Aids in providing log messages based on transition status.
fileprivate enum SwiftFSMTransitStatus: String {
    case willTransit = "Machine will transit: "
    case transitCancelled = "Machine transition cancelled: "
    case didTransit = "Machine did transit: "
}

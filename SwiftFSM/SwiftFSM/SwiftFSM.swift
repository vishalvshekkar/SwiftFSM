//
//  SwiftFSM.swift
//  SwiftFSM
//
//  Created by Vishal V. Shekkar on 25/10/16.
//  Copyright © 2016 Vishal V. Shekkar. All rights reserved.
//

import Foundation

public protocol SwiftFSMSchemaType {
    
    associatedtype State
    associatedtype Trigger
    
    var initialState: State {get}
    var transitionLogic: (_ state: State, _ trigger: Trigger) -> State {get}
    
    init(initialState: State, transitionLogic: @escaping (_ state: State, _ trigger: Trigger) -> State)
    
}

public struct SwiftFSMSchema<S, T>: SwiftFSMSchemaType {
    
    public typealias State = S
    public typealias Trigger = T
    
    public var initialState: State
    public var transitionLogic: (_ state: State, _ trigger: Trigger) -> State
    
    public init(initialState: State, transitionLogic: @escaping (State, Trigger) -> State) {
        self.initialState = initialState
        self.transitionLogic = transitionLogic
    }
    
}

public enum SwiftFSMLogType {
    case noLogging
    case logging(((_ log: String) -> ())?)
}

fileprivate enum SwiftFSMTransitStatus: String {
    case willTransit = "Machine will transit: "
    case transitCancelled = "Machine transition cancelled: "
    case didTransit = "Machine did transit: "
}

public final class SwiftFSM<Schema: SwiftFSMSchemaType> {
    
    public private(set) var state: Schema.State
    public let schema: Schema
    public var shouldMachineTransitState: ((_ fromState: Schema.State, _ trigger: Schema.Trigger, _ toState: Schema.State) -> (Bool))?
    public var machineDidTransitState: ((_ fromState: Schema.State, _ trigger: Schema.Trigger, _ toState: Schema.State) -> ())?
    public var logging = SwiftFSMLogType.logging(nil)
    
    public init(schema: Schema) {
        self.schema = schema
        self.state = schema.initialState
    }
    
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
    
    private func changeState(trigger: Schema.Trigger, toState: Schema.State) {
        let oldState = state
        state = toState
        handleLogging(fromState: oldState, trigger: trigger, toState: state, transitStatus: .didTransit)
        machineDidTransitState?(oldState, trigger, state)
    }
    
    private func handleLogging(fromState: Schema.State, trigger: Schema.Trigger, toState: Schema.State, transitStatus: SwiftFSMTransitStatus) {
        switch logging {
        case .noLogging:
            break
        case let .logging(some):
            let log = getLog(fromState: fromState, trigger: trigger, toState: toState, transitStatus: transitStatus)
            if let some = some { some(log) } else { print(log) }
        }
    }
    
    private func getLog(fromState: Schema.State, trigger: Schema.Trigger, toState: Schema.State, transitStatus: SwiftFSMTransitStatus) -> String {
        var log = transitStatus.rawValue
        log += "🔥\(trigger)🔥: \(fromState) → \(toState)"
        return log
    }
    
}

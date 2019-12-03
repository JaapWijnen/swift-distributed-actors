// ==== ------------------------------------------------------------------ ====
// === DO NOT EDIT: Generated by GenActors                     
// ==== ------------------------------------------------------------------ ====

//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift Distributed Actors open source project
//
// Copyright (c) 2018-2019 Apple Inc. and the Swift Distributed Actors project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.md for the list of Swift Distributed Actors project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

// tag::imports[]

import DistributedActors

// end::imports[]

import DistributedActorsTestKit
import XCTest

// ==== ----------------------------------------------------------------------------------------------------------------
// MARK: DO NOT EDIT: Generated InvokeFuncs messages 

/// DO NOT EDIT: Generated InvokeFuncs messages
extension InvokeFuncs {

    public enum Message { 
        case doThingsAndRunTask(_replyTo: ActorRef<Int>) 
        case doThingsAsync(_replyTo: ActorRef<Reply<Int>>) 
        case internalTask(_replyTo: ActorRef<Int>) 
    }
    
}
// ==== ----------------------------------------------------------------------------------------------------------------
// MARK: DO NOT EDIT: Generated InvokeFuncs behavior

extension InvokeFuncs {

    public static func makeBehavior(instance: InvokeFuncs) -> Behavior<Message> {
        return .setup { _context in
            let context = Actor<InvokeFuncs>.Context(underlying: _context)
            let instance = instance

            /* await */ instance.preStart(context: context)

            return Behavior<Message>.receiveMessage { message in
                switch message { 
                
                case .doThingsAndRunTask(let _replyTo):
                    let result = instance.doThingsAndRunTask()
                    _replyTo.tell(result)
 
                case .doThingsAsync(let _replyTo):
                    let result = instance.doThingsAsync()
                    _replyTo.tell(result)
 
                case .internalTask(let _replyTo):
                    let result = instance.internalTask()
                    _replyTo.tell(result)
 
                
                }
                return .same
            }.receiveSignal { _context, signal in 
                let context = Actor<InvokeFuncs>.Context(underlying: _context)

                switch signal {
                case is Signals.PostStop: 
                    instance.postStop(context: context)
                    return .same
                case let terminated as Signals.Terminated:
                    switch instance.receiveTerminated(context: context, terminated: terminated) {
                    case .unhandled: 
                        return .unhandled
                    case .stop: 
                        return .stop
                    case .ignore: 
                        return .same
                    }
                default:
                    return .unhandled
                }
            }
        }
    }
}
// ==== ----------------------------------------------------------------------------------------------------------------
// MARK: Extend Actor for InvokeFuncs

extension Actor where A.Message == InvokeFuncs.Message {

 

 

 

}

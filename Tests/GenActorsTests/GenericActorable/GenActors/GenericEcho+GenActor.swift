// ==== ------------------------------------------------------------------ ====
// === DO NOT EDIT: Generated by GenActors                     
// ==== ------------------------------------------------------------------ ====

//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift Distributed Actors open source project
//
// Copyright (c) 2019-2020 Apple Inc. and the Swift Distributed Actors project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.md for the list of Swift Distributed Actors project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import DistributedActors

// ==== ----------------------------------------------------------------------------------------------------------------
// MARK: DO NOT EDIT: Generated GenericEcho messages 

/// DO NOT EDIT: Generated GenericEcho messages
extension GenericEcho {

    public enum Message: ActorMessage { 
        case echo(M, _replyTo: ActorRef<M>) 
    }
    
}
// ==== ----------------------------------------------------------------------------------------------------------------
// MARK: DO NOT EDIT: Generated GenericEcho behavior

extension GenericEcho {

    public static func makeBehavior(instance: GenericEcho) -> Behavior<Message> {
        return .setup { _context in
            let context = Actor<GenericEcho>.Context(underlying: _context)
            let instance = instance

            instance.preStart(context: context)

            return Behavior<Message>.receiveMessage { message in
                switch message { 
                
                case .echo(let message, let _replyTo):
                    let result =                     instance.echo(message)
                    _replyTo.tell(result)

                     
                
                }
                return .same
            }.receiveSignal { _context, signal in 
                let context = Actor<GenericEcho>.Context(underlying: _context)

                switch signal {
                case is Signals.PostStop: 
                    instance.postStop(context: context)
                    return .same
                case let terminated as Signals.Terminated:
                    switch try instance.receiveTerminated(context: context, terminated: terminated) {
                    case .unhandled: 
                        return .unhandled
                    case .stop: 
                        return .stop
                    case .ignore: 
                        return .same
                    }
                default:
                    try instance.receiveSignal(context: context, signal: signal)
                    return .same
                }
            }
        }
    }
}
// ==== ----------------------------------------------------------------------------------------------------------------
// MARK: Extend Actor for GenericEcho

extension Actor {

     func echo<M: Codable>(_ message: M) -> Reply<M>
        where Self.Message == GenericEcho<M>.Message {
        // TODO: FIXME perhaps timeout should be taken from context
        Reply.from(askResponse: 
            self.ref.ask(for: M.self, timeout: .effectivelyInfinite) { _replyTo in
                Self.Message.echo(message, _replyTo: _replyTo)}
        )
    }
 

}

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

@testable import DistributedActors
import DistributedActorsTestKit
import Foundation
import XCTest

final class ShoutingInterceptor: _Interceptor<String> {
    let probe: ActorTestProbe<String>?

    init(probe: ActorTestProbe<String>? = nil) {
        self.probe = probe
    }

    override func interceptMessage(target: _Behavior<String>, context: _ActorContext<String>, message: String) throws -> _Behavior<String> {
        self.probe?.tell("from-interceptor:\(message)")
        return try target.interpretMessage(context: context, message: message + "!")
    }

    override func isSame(as other: _Interceptor<String>) -> Bool {
        false
    }
}

final class TerminatedInterceptor<Message: Codable>: _Interceptor<Message> {
    let probe: ActorTestProbe<_Signals.Terminated>

    init(probe: ActorTestProbe<_Signals.Terminated>) {
        self.probe = probe
    }

    override func interceptSignal(target: _Behavior<Message>, context: _ActorContext<Message>, signal: _Signal) throws -> _Behavior<Message> {
        switch signal {
        case let terminated as _Signals.Terminated:
            self.probe.tell(terminated) // we forward all termination signals to someone
        case is _Signals._PostStop:
            () // ok
        default:
            fatalError("Other signal: \(signal)")
            ()
        }
        return try target.interpretSignal(context: context, signal: signal)
    }
}

final class InterceptorTests: ClusterSystemXCTestCase {
    func test_interceptor_shouldConvertMessages() throws {
        let p: ActorTestProbe<String> = self.testKit.makeTestProbe()

        let interceptor = ShoutingInterceptor()

        let forwardToProbe: _Behavior<String> = .receiveMessage { message in
            p.tell(message)
            return .same
        }

        let ref: _ActorRef<String> = try system._spawn(
            "theWallsHaveEars",
            .intercept(behavior: forwardToProbe, with: interceptor)
        )

        for i in 0 ... 10 {
            ref.tell("hello:\(i)")
        }

        for i in 0 ... 10 {
            try p.expectMessage("hello:\(i)!")
        }
    }

    func test_interceptor_shouldSurviveDeeplyNestedInterceptors() throws {
        let p: ActorTestProbe<String> = self.testKit.makeTestProbe()
        let i: ActorTestProbe<String> = self.testKit.makeTestProbe()

        let makeStringsLouderInterceptor = ShoutingInterceptor(probe: i)

        // just like in the movie "Inception"
        func interceptionInceptionBehavior(currentDepth depth: Int, stopAt limit: Int) -> _Behavior<String> {
            let behavior: _Behavior<String>
            if depth < limit {
                // add another "setup layer"
                behavior = interceptionInceptionBehavior(currentDepth: depth + 1, stopAt: limit)
            } else {
                behavior = .receiveMessage { msg in
                    p.tell("received:\(msg)")
                    return .stop
                }
            }

            return .intercept(behavior: behavior, with: makeStringsLouderInterceptor)
        }

        let depth = 50
        let ref: _ActorRef<String> = try system._spawn(
            "theWallsHaveEars",
            interceptionInceptionBehavior(currentDepth: 0, stopAt: depth)
        )

        ref.tell("hello")

        try p.expectMessage("received:hello!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        for j in 0 ... depth {
            let m = "from-interceptor:hello\(String(repeating: "!", count: j))"
            try i.expectMessage(m)
        }
    }

    func test_interceptor_shouldInterceptSignals() throws {
        let p: ActorTestProbe<_Signals.Terminated> = self.testKit.makeTestProbe()

        let spyOnTerminationSignals: _Interceptor<String> = TerminatedInterceptor(probe: p)

        let spawnSomeStoppers = _Behavior<String>.setup { context in
            let one: _ActorRef<String> = try context._spawnWatch(
                "stopperOne",
                .receiveMessage { _ in
                    .stop
                }
            )
            one.tell("stop")

            let two: _ActorRef<String> = try context._spawnWatch(
                "stopperTwo",
                .receiveMessage { _ in
                    .stop
                }
            )
            two.tell("stop")

            return .same
        }

        let _: _ActorRef<String> = try system._spawn(
            "theWallsHaveEarsForTermination",
            .intercept(behavior: spawnSomeStoppers, with: spyOnTerminationSignals)
        )

        // either of the two child actors can cause the death pact, depending on which one was scheduled first,
        // so we have to check that the message we get is from one of them and afterwards we should not receive
        // any additional messages
        let terminated = try p.expectMessage()
        (terminated.id.name == "stopperOne" || terminated.id.name == "stopperTwo").shouldBeTrue()
        try p.expectNoMessage(for: .milliseconds(500))
    }

    class SignalToStringInterceptor<Message: Codable>: _Interceptor<Message> {
        let probe: ActorTestProbe<String>

        init(_ probe: ActorTestProbe<String>) {
            self.probe = probe
        }

        override func interceptSignal(target: _Behavior<Message>, context: _ActorContext<Message>, signal: _Signal) throws -> _Behavior<Message> {
            self.probe.tell("intercepted:\(signal)")
            return try target.interpretSignal(context: context, signal: signal)
        }
    }

    func test_interceptor_shouldRemainWhenReturningStoppingWithPostStop() throws {
        let p: ActorTestProbe<String> = self.testKit.makeTestProbe()

        let behavior: _Behavior<String> = .receiveMessage { _ in
            .stop { _ in
                p.tell("postStop")
            }
        }

        let interceptedBehavior: _Behavior<String> = .intercept(behavior: behavior, with: SignalToStringInterceptor(p))

        let ref = try system._spawn(.anonymous, interceptedBehavior)
        p.watch(ref)
        ref.tell("test")

        try p.expectMessage("intercepted:_PostStop()")
        try p.expectMessage("postStop")
        try p.expectTerminated(ref)
    }
}

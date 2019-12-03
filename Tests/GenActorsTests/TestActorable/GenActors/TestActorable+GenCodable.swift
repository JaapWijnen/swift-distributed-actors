// ==== ------------------------------------------------------------------ ====
// === DO NOT EDIT: Generated by GenActors                     
// ==== ------------------------------------------------------------------ ====

//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift Distributed Actors open source project
//
// Copyright (c) 2019 Apple Inc. and the Swift Distributed Actors project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.md for the list of Swift Distributed Actors project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import DistributedActors
import class NIO.EventLoopFuture

// ==== ----------------------------------------------------------------------------------------------------------------
// MARK: DO NOT EDIT: Codable conformance for TestActorable.Message
// TODO: This will not be required, once Swift synthesizes Codable conformances for enums with associated values 

extension TestActorable.Message: Codable {
    // TODO: Check with Swift team which style of discriminator to aim for
    public enum DiscriminatorKeys: String, Decodable {
        case ping
        case greet
        case greetUnderscoreParam
        case greet2
        case throwing
        case passMyself
        case _ignoreInGenActor
        case parameterNames
        case greetReplyToActorRef
        case greetReplyToActor
        case greetReplyToReturnStrict
        case greetReplyToReturnStrictThrowing
        case greetReplyToReturnNIOFuture
        case becomeStopped
        case contextSpawnExample
        case timer

    }

    public enum CodingKeys: CodingKey {
        case _case
        case greet_name
        case greetUnderscoreParam_name
        case greet2_name
        case greet2_surname
        case passMyself_someone
        case parameterNames_first
        case greetReplyToActorRef_name
        case greetReplyToActorRef_replyTo
        case greetReplyToActor_name
        case greetReplyToActor_replyTo
        case greetReplyToReturnStrict_name
        case greetReplyToReturnStrict__replyTo
        case greetReplyToReturnStrictThrowing_name
        case greetReplyToReturnStrictThrowing__replyTo
        case greetReplyToReturnNIOFuture_name
        case greetReplyToReturnNIOFuture__replyTo

    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(DiscriminatorKeys.self, forKey: CodingKeys._case) {
        case .ping:
            self = .ping
        case .greet:
            let name = try container.decode(String.self, forKey: CodingKeys.greet_name)
            self = .greet(name: name)
        case .greetUnderscoreParam:
            let name = try container.decode(String.self, forKey: CodingKeys.greetUnderscoreParam_name)
            self = .greetUnderscoreParam(name)
        case .greet2:
            let name = try container.decode(String.self, forKey: CodingKeys.greet2_name)
            let surname = try container.decode(String.self, forKey: CodingKeys.greet2_surname)
            self = .greet2(name: name, surname: surname)
        case .throwing:
            self = .throwing
        case .passMyself:
            let someone = try container.decode(ActorRef<Actor<TestActorable>>.self, forKey: CodingKeys.passMyself_someone)
            self = .passMyself(someone: someone)
        case ._ignoreInGenActor:
            self = ._ignoreInGenActor
        case .parameterNames:
            let second = try container.decode(String.self, forKey: CodingKeys.parameterNames_first)
            self = .parameterNames(first: second)
        case .greetReplyToActorRef:
            let name = try container.decode(String.self, forKey: CodingKeys.greetReplyToActorRef_name)
            let replyTo = try container.decode(ActorRef<String>.self, forKey: CodingKeys.greetReplyToActorRef_replyTo)
            self = .greetReplyToActorRef(name: name, replyTo: replyTo)
        case .greetReplyToActor:
            let name = try container.decode(String.self, forKey: CodingKeys.greetReplyToActor_name)
            let replyTo = try container.decode(Actor<TestActorable>.self, forKey: CodingKeys.greetReplyToActor_replyTo)
            self = .greetReplyToActor(name: name, replyTo: replyTo)
        case .greetReplyToReturnStrict:
            let name = try container.decode(String.self, forKey: CodingKeys.greetReplyToReturnStrict_name)
            let _replyTo = try container.decode(ActorRef<String>.self, forKey: CodingKeys.greetReplyToReturnStrict__replyTo)
            self = .greetReplyToReturnStrict(name: name, _replyTo: _replyTo)
        case .greetReplyToReturnStrictThrowing:
            let name = try container.decode(String.self, forKey: CodingKeys.greetReplyToReturnStrictThrowing_name)
            let _replyTo = try container.decode(ActorRef<Result<String, Error>>.self, forKey: CodingKeys.greetReplyToReturnStrictThrowing__replyTo)
            self = .greetReplyToReturnStrictThrowing(name: name, _replyTo: _replyTo)
        case .greetReplyToReturnNIOFuture:
            let name = try container.decode(String.self, forKey: CodingKeys.greetReplyToReturnNIOFuture_name)
            let _replyTo = try container.decode(ActorRef<Result<String, Error>>.self, forKey: CodingKeys.greetReplyToReturnNIOFuture__replyTo)
            self = .greetReplyToReturnNIOFuture(name: name, _replyTo: _replyTo)
        case .becomeStopped:
            self = .becomeStopped
        case .contextSpawnExample:
            self = .contextSpawnExample
        case .timer:
            self = .timer

        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .ping:
            try container.encode(DiscriminatorKeys.ping.rawValue, forKey: CodingKeys._case)
        case .greet(let name):
            try container.encode(DiscriminatorKeys.greet.rawValue, forKey: CodingKeys._case)
            try container.encode(name, forKey: CodingKeys.greet_name)
        case .greetUnderscoreParam(let name):
            try container.encode(DiscriminatorKeys.greetUnderscoreParam.rawValue, forKey: CodingKeys._case)
            try container.encode(name, forKey: CodingKeys.greetUnderscoreParam_name)
        case .greet2(let name, let surname):
            try container.encode(DiscriminatorKeys.greet2.rawValue, forKey: CodingKeys._case)
            try container.encode(name, forKey: CodingKeys.greet2_name)
            try container.encode(surname, forKey: CodingKeys.greet2_surname)
        case .throwing:
            try container.encode(DiscriminatorKeys.throwing.rawValue, forKey: CodingKeys._case)
        case .passMyself(let someone):
            try container.encode(DiscriminatorKeys.passMyself.rawValue, forKey: CodingKeys._case)
            try container.encode(someone, forKey: CodingKeys.passMyself_someone)
        case ._ignoreInGenActor:
            try container.encode(DiscriminatorKeys._ignoreInGenActor.rawValue, forKey: CodingKeys._case)
        case .parameterNames(let second):
            try container.encode(DiscriminatorKeys.parameterNames.rawValue, forKey: CodingKeys._case)
            try container.encode(second, forKey: CodingKeys.parameterNames_first)
        case .greetReplyToActorRef(let name, let replyTo):
            try container.encode(DiscriminatorKeys.greetReplyToActorRef.rawValue, forKey: CodingKeys._case)
            try container.encode(name, forKey: CodingKeys.greetReplyToActorRef_name)
            try container.encode(replyTo, forKey: CodingKeys.greetReplyToActorRef_replyTo)
        case .greetReplyToActor(let name, let replyTo):
            try container.encode(DiscriminatorKeys.greetReplyToActor.rawValue, forKey: CodingKeys._case)
            try container.encode(name, forKey: CodingKeys.greetReplyToActor_name)
            try container.encode(replyTo, forKey: CodingKeys.greetReplyToActor_replyTo)
        case .greetReplyToReturnStrict(let name, let _replyTo):
            try container.encode(DiscriminatorKeys.greetReplyToReturnStrict.rawValue, forKey: CodingKeys._case)
            try container.encode(name, forKey: CodingKeys.greetReplyToReturnStrict_name)
            try container.encode(_replyTo, forKey: CodingKeys.greetReplyToReturnStrict__replyTo)
        case .greetReplyToReturnStrictThrowing(let name, let _replyTo):
            try container.encode(DiscriminatorKeys.greetReplyToReturnStrictThrowing.rawValue, forKey: CodingKeys._case)
            try container.encode(name, forKey: CodingKeys.greetReplyToReturnStrictThrowing_name)
            try container.encode(_replyTo, forKey: CodingKeys.greetReplyToReturnStrictThrowing__replyTo)
        case .greetReplyToReturnNIOFuture(let name, let _replyTo):
            try container.encode(DiscriminatorKeys.greetReplyToReturnNIOFuture.rawValue, forKey: CodingKeys._case)
            try container.encode(name, forKey: CodingKeys.greetReplyToReturnNIOFuture_name)
            try container.encode(_replyTo, forKey: CodingKeys.greetReplyToReturnNIOFuture__replyTo)
        case .becomeStopped:
            try container.encode(DiscriminatorKeys.becomeStopped.rawValue, forKey: CodingKeys._case)
        case .contextSpawnExample:
            try container.encode(DiscriminatorKeys.contextSpawnExample.rawValue, forKey: CodingKeys._case)
        case .timer:
            try container.encode(DiscriminatorKeys.timer.rawValue, forKey: CodingKeys._case)

        }
    }
}

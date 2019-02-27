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

import SwiftProtobuf
import NIO
import struct Foundation.Data // TODO would refer to not go "through" Data as our target always is ByteBuffer

// MARK: Serialization with ByteBuf // TODO is forced to allocate more than it would have to normally (due to hop through Data)

extension SwiftProtobuf.Message {

    // FIXME: Avoid the copying, needs SwiftProtobuf changes
    /// Returns a `ByteBuffer` value containing the Protocol Buffer binary format serialization of the message.
    ///
    /// - Warning: Currently it is forced to perform an additional copy internally (so we double allocate the needed amount of space).
    ///
    /// - Parameters:
    ///   - partial: If `false` (the default), this method will check
    ///     `Message.isInitialized` before encoding to verify that all required
    ///     fields are present. If any are missing, this method throws
    ///     `BinaryEncodingError.missingRequiredFields`.
    /// - Returns: A `ByteBuffer` value containing the binary serialization of the message.
    /// - Throws: `BinaryEncodingError` if encoding fails.
    func serializedByteBuffer(allocator allocate: ByteBufferAllocator, partial: Bool = false) throws -> ByteBuffer {
        let data = try self.serializedData(partial: partial)

        var buffer = allocate.buffer(capacity: data.count)
        buffer.write(bytes: data)

        return buffer
    }
}

// MARK: Conversions

extension ProtoEnvelope {
    init(serializedData data: Data) throws { 
        var proto = ProtoEnvelope()
        try proto.merge(serializedData: data)

        // TODO
        // guard proto.hasRecipient else { throw DeserializationError.missingField("recipient") }
        
        self = proto
    }
}

extension ProtoProtocolVersion {
    init(_ value: Wire.Version) {
        var proto = ProtoProtocolVersion()
        proto.reserved = UInt32(value.reserved)
        proto.major = UInt32(value.major)
        proto.minor = UInt32(value.minor)
        proto.patch = UInt32(value.patch)
        self = proto
    }
}

extension Remote.UniqueAddress {
    init(_ proto: ProtoUniqueAddress) {
        let address = Remote.Address(proto.address)
        let uid = Remote.NodeUID(proto.uid)
        self.init(address: address, uid: uid)
    }
}
extension ProtoUniqueAddress {
    init(_ address: Remote.UniqueAddress) {
        var proto = ProtoUniqueAddress()
        proto.address = ProtoAddress(address.address)
        self = proto
    }
}

extension Remote.Address {
    init(_ proto: ProtoAddress) {
        self.systemName = proto.system
        self.host = proto.hostname
        self.port = UInt(proto.port) // FIXME
    }
}
extension ProtoAddress {
    init(_ address: Remote.Address) {
        var proto = ProtoAddress()
        proto.system = address.systemName
        proto.hostname = address.host
        proto.port = UInt32(address.port) // FIXME
        self = proto
    }
}

extension ProtoHandshakeOffer {
    init(_ offer: Wire.HandshakeOffer) {
        var proto = ProtoHandshakeOffer()
        proto.from = ProtoUniqueAddress(offer.from)
        proto.to = ProtoAddress(offer.to)
        proto.version = ProtoProtocolVersion(offer.version)
        self = proto
    }

    init(serializedData data: Data) throws {
        var proto = ProtoHandshakeOffer()
        try proto.merge(serializedData: data)

        guard proto.hasFrom else { throw HandshakeError.missingField("from") }
        guard proto.hasTo else { throw HandshakeError.missingField("to") }
        guard proto.hasVersion else { throw HandshakeError.missingField("version") }
        
        self = proto
    }
}
extension Wire.HandshakeOffer {
    init(_ proto: ProtoHandshakeOffer) throws {
        guard proto.hasFrom else { throw HandshakeError.missingField("from") }
        guard proto.hasTo else { throw HandshakeError.missingField("to") }
        guard proto.hasVersion else { throw HandshakeError.missingField("version") }
        
        self.from = Remote.UniqueAddress(proto.from)
        self.to = Remote.Address(proto.to)
        self.version = Wire.Version(reserved: UInt8(proto.version.reserved), major: UInt8(proto.version.major), minor: UInt8(proto.version.minor), patch: UInt8(proto.version.patch))
    }
}

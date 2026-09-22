# protocol

A Minecraft: Bedrock Edition network protocol implementation in V.

## Scope

Current version: **1.26.50, protocol 2192**.

```
packets/      one file per packet
types/        the types packets carry on the wire
enums/        the enums they use
model/        the types callers work with, independent of the wire layout
serializer/   the reader and writer
```

## Dependency: nbt

This project consumes the standalone network-NBT codec from
[bedrock-v/nbt](https://github.com/bedrock-v/nbt). Install it into your V module
path before building:

```bash
v install bedrock-v.nbt
```

## Tests

```bash
v test tests              # the test suite
v run examples/roundtrip.v
```

## Usage

```v
import protocol
import protocol.serializer
import protocol.packets

mut pool := protocol.new_pool()
println('proto=${protocol.protocol_id} mc=${protocol.minecraft_version}')

packet := &packets.RequestNetworkSettingsPacket{
	client_network_version: i32(protocol.protocol_id)
}
bytes := protocol.encode_packet_to_bytes(packet)

// decode straight from bytes
mut r := serializer.new_reader(bytes)
decoded := pool.decode(mut r)!
if decoded is packets.RequestNetworkSettingsPacket {
	println('decoded=${decoded.name()} client_network_version=${decoded.client_network_version}')
}
```

## Tests

`tests/` exercises the module from outside, the way a dependent does.
`roundtrip_test.v` encodes and decodes every packet the pool registers and
compares the result against a recorded baseline, so a packet that stops
round-tripping is caught even though the suite has no wire fixtures yet.

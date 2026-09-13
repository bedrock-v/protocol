# protocol

A Minecraft: Bedrock Edition network protocol implementation in V.

## Versions

Packets live under versioned modules in `version/`. Each supported protocol
version ships its own packet pool, later versions only materialize the packets,
types and enums that changed and inherit the rest from earlier modules.

The latest supported version lives in `protocol.current`. Older releases remain
available under their numbered `protocol.version` modules.

## Dependency: nbt

This project consumes the standalone network-NBT codec from
[bedrock-v/nbt](https://github.com/bedrock-v/nbt) via `import nbt`. Install it into
your V module path before building:

```bash
git clone https://github.com/bedrock-v/nbt ~/.vmodules/nbt
```

## Build and Run

```bash
v -shared -skip-unused .          # compile the library
v -path 'src|@vlib|@vmodules' run examples/roundtrip.v
v -path 'src|@vlib|@vmodules' run examples/all_versions.v
```

## Usage

```v
import protocol
import protocol.serializer
import protocol.version
import protocol.current
import protocol.version.v662.packets as packets_662

mut pool := current.new_pool()
println('proto=${current.proto_version.protocol_id()} mc=${current.proto_version.minecraft_version()}')

// encode any packet from the pool's version slice
packet := &packets_662.RequestNetworkSettingsPacket{
	client_network_version: i32(current.proto_version.protocol_id())
}
bytes := protocol.encode_packet_to_bytes(packet)

// decode straight from bytes
mut r := serializer.new_reader(bytes)
decoded := pool.decode(mut r)!
if decoded is packets_662.RequestNetworkSettingsPacket {
	println('decoded=${decoded.name()} client_network_version=${decoded.client_network_version}')
}

// pick a pool from a client's protocol id
v := version.from_protocol_id(1001)
println('selected=${v} mc=${v.minecraft_version()}')
```

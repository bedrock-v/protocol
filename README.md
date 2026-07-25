# protocol

A Minecraft: Bedrock Edition network protocol implementation in V.

## Versions

Packets live under versioned modules in `src/version/`. Each supported protocol
version ships its own packet pool - later versions only materialize the packets,
types and enums that changed and inherit the rest from earlier modules.

Supported protocols run from 2 (MCPE 0.2.0, 2012) up to 2168 (MC 1.26.40), 100
versions across four wire-format eras plus the modern chain:

Framing differs per era - use `protocol.encode_packet_old_to_bytes` / `pool.decode_old`
for proto 9-113, `protocol.encode_packet_split_to_bytes` / `pool.decode_split` for
proto 130-274, and `protocol.encode_packet_to_bytes` / `pool.decode` for 280+.

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
import serializer
import version
import version.v1001

mut pool := v1001.new_pool()
println('proto=${v1001.proto_version.protocol_id()} mc=${v1001.proto_version.minecraft_version()}')

// encode any packet from the pool's version slice
// decode straight from bytes
mut r := serializer.new_reader(bytes)
decoded := pool.decode(mut r)!

// pick a pool from a client's protocol id
v := version.from_protocol_id(1001)
```

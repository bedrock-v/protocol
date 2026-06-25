# protocol

A Minecraft: Bedrock Edition network protocol implementation in V.

## Dependency: nbt

This project consumes the standalone network-NBT codec from
[bedrock-v/nbt](https://github.com/bedrock-v/nbt) via `import nbt`. Install it into
your V module path before building:

```bash
git clone https://github.com/bedrock-v/nbt ~/.vmodules/nbt
```

## Build and Run

```bash
v -shared -skip-unused src        # compile the library
v run examples/roundtrip.v        # example round-trip
```

## Usage

```v
import src as protocol
import src.serializer

pkt := &protocol.RequestNetworkSettingsPacket{
	protocol_version: protocol.current_protocol
}
bytes := protocol.encode_packet_to_bytes(pkt)

mut pool := protocol.new_packet_pool()
mut r := serializer.new_reader(bytes)
decoded := pool.decode(mut r)!
```

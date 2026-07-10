# protocol

A Minecraft: Bedrock Edition network protocol implementation in V.

## Dependency: nbt

This project consumes the standalone network-NBT codec from
[bedrock-v/nbt](https://github.com/bedrock-v/nbt) via `import nbt`.

```bash
v install
```

## Build and Run

```bash
v -shared -skip-unused .          # compile the library
v run examples/roundtrip.v
```

## Usage

```v
import protocol

pkt := &protocol.RequestNetworkSettingsPacket{
	protocol_version: protocol.current_protocol
}
bytes := protocol.encode_packet_to_bytes(pkt)

mut pool := protocol.new_packet_pool()
mut r := protocol.new_reader(bytes)
decoded := pool.decode(mut r)!
```

module packets

import serializer
import version.v729.types

pub struct ContainerRegistryCleanupPacket {
pub mut:
	containers []types.FullContainerName
}

pub fn (p &ContainerRegistryCleanupPacket) pid() u16 { return 317 }

pub fn (p &ContainerRegistryCleanupPacket) name() string { return 'ContainerRegistryCleanupPacket' }

pub fn (p &ContainerRegistryCleanupPacket) can_be_sent_before_login() bool { return false }

pub fn (p &ContainerRegistryCleanupPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.containers.len))
	for e in p.containers {
		e.encode(mut w)
	}
}

pub fn (mut p ContainerRegistryCleanupPacket) decode_payload(mut r serializer.Reader) ! {
	count := int(r.read_varuint32()!)
	p.containers = []types.FullContainerName{cap: count}
	for _ in 0 .. count {
		p.containers << types.FullContainerName.decode(mut r)!
	}
}

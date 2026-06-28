module protocol

import serializer
import types

pub struct ContainerRegistryCleanupPacket {
pub mut:
	removed_containers []types.FullContainerName
}

pub fn (p &ContainerRegistryCleanupPacket) pid() u16 {
	return container_registry_cleanup_packet
}

pub fn (p &ContainerRegistryCleanupPacket) name() string {
	return 'ContainerRegistryCleanupPacket'
}

pub fn (p &ContainerRegistryCleanupPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ContainerRegistryCleanupPacket) decode_payload(mut r serializer.Reader) ! {
	count := r.read_varuint32()!
	p.removed_containers = []types.FullContainerName{}
	for _ in 0 .. count {
		p.removed_containers << r.read_full_container_name()!
	}
}

pub fn (p &ContainerRegistryCleanupPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.removed_containers.len))
	for c in p.removed_containers {
		w.write_full_container_name(c)
	}
}

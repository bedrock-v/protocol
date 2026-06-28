module protocol

import serializer
import nbt

pub struct EditorNetworkPacket {
pub mut:
	is_route_to_manager bool
	payload             nbt.RootTag
}

pub fn (p &EditorNetworkPacket) pid() u16 {
	return editor_network_packet
}

pub fn (p &EditorNetworkPacket) name() string {
	return 'EditorNetworkPacket'
}

pub fn (p &EditorNetworkPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p EditorNetworkPacket) decode_payload(mut r serializer.Reader) ! {
	p.is_route_to_manager = r.bool()!
	p.payload = r.read_nbt_compound_root()!
}

pub fn (p &EditorNetworkPacket) encode_payload(mut w serializer.Writer) {
	w.bool(p.is_route_to_manager)
	w.write_nbt_compound_root(p.payload)
}

module packets

import protocol.serializer
import nbt

pub struct EditorNetworkPacket {
pub mut:
	route_to_manager bool
	binary_payload   nbt.RootTag
}

pub fn (p &EditorNetworkPacket) pid() u16 {
	return 190
}

pub fn (p &EditorNetworkPacket) name() string {
	return 'EditorNetworkPacket'
}

pub fn (p &EditorNetworkPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &EditorNetworkPacket) encode_payload(mut w serializer.Writer) {
	w.bool(p.route_to_manager)
	w.write_nbt_compound_root(p.binary_payload)
}

pub fn (mut p EditorNetworkPacket) decode_payload(mut r serializer.Reader) ! {
	p.route_to_manager = r.bool()!
	p.binary_payload = r.read_nbt_compound_root()!
}

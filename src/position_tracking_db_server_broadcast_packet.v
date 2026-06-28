module protocol

import serializer
import nbt

pub struct PositionTrackingDBServerBroadcastPacket {
pub mut:
	action      u8
	tracking_id int
	nbt         nbt.RootTag
}

pub fn (p &PositionTrackingDBServerBroadcastPacket) pid() u16 {
	return position_tracking_db_server_broadcast_packet
}

pub fn (p &PositionTrackingDBServerBroadcastPacket) name() string {
	return 'PositionTrackingDBServerBroadcastPacket'
}

pub fn (p &PositionTrackingDBServerBroadcastPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p PositionTrackingDBServerBroadcastPacket) decode_payload(mut r serializer.Reader) ! {
	p.action = r.u8()!
	p.tracking_id = r.read_varint32()!
	p.nbt = r.read_nbt_compound_root()!
}

pub fn (p &PositionTrackingDBServerBroadcastPacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.action)
	w.write_varint32(p.tracking_id)
	w.write_nbt_compound_root(p.nbt)
}

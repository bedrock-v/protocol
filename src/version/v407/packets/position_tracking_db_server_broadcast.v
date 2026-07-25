module packets

import nbt
import serializer

pub enum PositionTrackingBroadcastAction as u8 {
	update    = 0
	destroy   = 1
	not_found = 2
}

pub struct PositionTrackingDBServerBroadcastPacket {
pub mut:
	action      PositionTrackingBroadcastAction
	tracking_id i32
	tag         nbt.RootTag
}

pub fn (p &PositionTrackingDBServerBroadcastPacket) pid() u16 {
	return 153
}

pub fn (p &PositionTrackingDBServerBroadcastPacket) name() string {
	return 'PositionTrackingDBServerBroadcastPacket'
}

pub fn (p &PositionTrackingDBServerBroadcastPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &PositionTrackingDBServerBroadcastPacket) encode_payload(mut w serializer.Writer) {
	w.u8(u8(p.action))
	w.write_varint32(p.tracking_id)
	w.write_nbt_compound_root(p.tag)
}

pub fn (mut p PositionTrackingDBServerBroadcastPacket) decode_payload(mut r serializer.Reader) ! {
	p.action = unsafe { PositionTrackingBroadcastAction(r.u8()!) }
	p.tracking_id = r.read_varint32()!
	p.tag = r.read_nbt_compound_root()!
}

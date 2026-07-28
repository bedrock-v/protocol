module packets

import protocol.serializer
import nbt
import protocol.version.v662.types

pub enum PositionTrackingDBBroadcastAction as i8 {
	update    = 0
	destroy   = 1
	not_found = 2
}

pub struct PositionTrackingDBServerBroadcastPacket {
pub mut:
	action                 PositionTrackingDBBroadcastAction
	id                     types.PositionTrackingId
	position_tracking_data nbt.RootTag
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
	w.i8(i8(p.action))
	p.id.encode(mut w)
	w.write_nbt_compound_root(p.position_tracking_data)
}

pub fn (mut p PositionTrackingDBServerBroadcastPacket) decode_payload(mut r serializer.Reader) ! {
	p.action = unsafe { PositionTrackingDBBroadcastAction(r.i8()!) }
	p.id = types.PositionTrackingId.decode(mut r)!
	p.position_tracking_data = r.read_nbt_compound_root()!
}

module packets

import protocol.serializer
import protocol.version.v662.types

pub enum PositionTrackingDBClientAction as i8 {
	query = 0
}

pub struct PositionTrackingDBClientRequestPacket {
pub mut:
	action PositionTrackingDBClientAction
	id     types.PositionTrackingId
}

pub fn (p &PositionTrackingDBClientRequestPacket) pid() u16 {
	return 154
}

pub fn (p &PositionTrackingDBClientRequestPacket) name() string {
	return 'PositionTrackingDBClientRequestPacket'
}

pub fn (p &PositionTrackingDBClientRequestPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &PositionTrackingDBClientRequestPacket) encode_payload(mut w serializer.Writer) {
	w.i8(i8(p.action))
	p.id.encode(mut w)
}

pub fn (mut p PositionTrackingDBClientRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.action = unsafe { PositionTrackingDBClientAction(r.i8()!) }
	p.id = types.PositionTrackingId.decode(mut r)!
}

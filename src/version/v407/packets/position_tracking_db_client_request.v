module packets

import protocol.serializer

pub enum PositionTrackingRequestAction as u8 {
	query = 0
}

pub struct PositionTrackingDBClientRequestPacket {
pub mut:
	action      PositionTrackingRequestAction
	tracking_id i32
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
	w.u8(u8(p.action))
	w.write_varint32(p.tracking_id)
}

pub fn (mut p PositionTrackingDBClientRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.action = unsafe { PositionTrackingRequestAction(r.u8()!) }
	p.tracking_id = r.read_varint32()!
}

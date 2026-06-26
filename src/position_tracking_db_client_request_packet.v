module src

import src.serializer

pub struct PositionTrackingDBClientRequestPacket {
pub mut:
	action      u8
	tracking_id int
}

pub fn (p &PositionTrackingDBClientRequestPacket) pid() u16 {
	return position_tracking_db_client_request_packet
}

pub fn (p &PositionTrackingDBClientRequestPacket) name() string {
	return 'PositionTrackingDBClientRequestPacket'
}

pub fn (p &PositionTrackingDBClientRequestPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p PositionTrackingDBClientRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.action = r.u8()!
	p.tracking_id = r.read_varint32()!
}

pub fn (p &PositionTrackingDBClientRequestPacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.action)
	w.write_varint32(p.tracking_id)
}

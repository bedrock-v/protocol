module src

import src.serializer

pub struct ServerboundDataDrivenScreenClosedPacket {
pub mut:
	form_id      int
	close_reason string
}

pub fn (p &ServerboundDataDrivenScreenClosedPacket) pid() u16 {
	return serverbound_data_driven_screen_closed_packet
}

pub fn (p &ServerboundDataDrivenScreenClosedPacket) name() string {
	return 'ServerboundDataDrivenScreenClosedPacket'
}

pub fn (p &ServerboundDataDrivenScreenClosedPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ServerboundDataDrivenScreenClosedPacket) decode_payload(mut r serializer.Reader) ! {
	p.form_id = int(r.le_u32()!)
	p.close_reason = r.read_string()!
}

pub fn (p &ServerboundDataDrivenScreenClosedPacket) encode_payload(mut w serializer.Writer) {
	w.le_u32(u32(p.form_id))
	w.write_string(p.close_reason)
}

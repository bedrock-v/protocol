module packets

import serializer

pub enum DataDrivenScreenClosedReason as u8 {
	programmatic_close     = 0
	programmatic_close_all = 1
	client_cancelled       = 2
	user_busy              = 3
	invalid_form           = 4
}

pub fn (e DataDrivenScreenClosedReason) encode(mut w serializer.Writer) {
	w.u8(u8(e))
}

pub fn DataDrivenScreenClosedReason.decode(mut r serializer.Reader) !DataDrivenScreenClosedReason {
	return unsafe { DataDrivenScreenClosedReason(r.u8()!) }
}

pub struct ServerBoundDataDrivenClosedPacket {
pub mut:
	form_id      i32
	close_reason DataDrivenScreenClosedReason
}

pub fn (p &ServerBoundDataDrivenClosedPacket) pid() u16 { return 343 }

pub fn (p &ServerBoundDataDrivenClosedPacket) name() string { return 'ServerBoundDataDrivenClosedPacket' }

pub fn (p &ServerBoundDataDrivenClosedPacket) can_be_sent_before_login() bool { return false }

pub fn (p &ServerBoundDataDrivenClosedPacket) encode_payload(mut w serializer.Writer) {
	w.le_i32(p.form_id)
	p.close_reason.encode(mut w)
}

pub fn (mut p ServerBoundDataDrivenClosedPacket) decode_payload(mut r serializer.Reader) ! {
	p.form_id = r.le_i32()!
	p.close_reason = DataDrivenScreenClosedReason.decode(mut r)!
}

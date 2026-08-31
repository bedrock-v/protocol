module packets

import protocol.serializer

pub struct ServerBoundDataDrivenClosedPacket {
pub mut:
	form_id      ?u32
	close_reason string
}

pub fn (p &ServerBoundDataDrivenClosedPacket) pid() u16 {
	return 343
}

pub fn (p &ServerBoundDataDrivenClosedPacket) name() string {
	return 'ServerBoundDataDrivenClosedPacket'
}

pub fn (p &ServerBoundDataDrivenClosedPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ServerBoundDataDrivenClosedPacket) encode_payload(mut w serializer.Writer) {
	if v := p.form_id {
		w.bool(true)
		w.le_u32(v)
	} else {
		w.bool(false)
	}
	w.write_string(p.close_reason)
}

pub fn (mut p ServerBoundDataDrivenClosedPacket) decode_payload(mut r serializer.Reader) ! {
	if r.bool()! {
		p.form_id = r.le_u32()!
	}
	p.close_reason = r.read_string()!
}

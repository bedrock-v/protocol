module packets

import protocol.serializer

pub struct ClientBoundDataDrivenUICloseScreenPacket {
pub mut:
	form_id ?u32
}

pub fn (p &ClientBoundDataDrivenUICloseScreenPacket) pid() u16 {
	return 334
}

pub fn (p &ClientBoundDataDrivenUICloseScreenPacket) name() string {
	return 'ClientBoundDataDrivenUICloseScreenPacket'
}

pub fn (p &ClientBoundDataDrivenUICloseScreenPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ClientBoundDataDrivenUICloseScreenPacket) encode_payload(mut w serializer.Writer) {
	if v := p.form_id {
		w.bool(true)
		w.le_u32(v)
	} else {
		w.bool(false)
	}
}

pub fn (mut p ClientBoundDataDrivenUICloseScreenPacket) decode_payload(mut r serializer.Reader) ! {
	if r.bool()! {
		p.form_id = r.le_u32()!
	}
}

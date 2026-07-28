module packets

import protocol.serializer

pub struct ClientBoundDataDrivenUICloseScreenPacket {
pub mut:
	form_id u32
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
	w.le_u32(p.form_id)
}

pub fn (mut p ClientBoundDataDrivenUICloseScreenPacket) decode_payload(mut r serializer.Reader) ! {
	p.form_id = r.le_u32()!
}

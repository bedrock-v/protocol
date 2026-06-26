module src

import src.serializer

pub struct ClientboundDataDrivenUICloseScreenPacket {
pub mut:
	form_id ?u32
}

pub fn (p &ClientboundDataDrivenUICloseScreenPacket) pid() u16 {
	return clientbound_data_driven_ui_close_screen_packet
}

pub fn (p &ClientboundDataDrivenUICloseScreenPacket) name() string {
	return 'ClientboundDataDrivenUICloseScreenPacket'
}

pub fn (p &ClientboundDataDrivenUICloseScreenPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ClientboundDataDrivenUICloseScreenPacket) decode_payload(mut r serializer.Reader) ! {
	if r.bool()! {
		p.form_id = r.le_u32()!
	} else {
		p.form_id = none
	}
}

pub fn (p &ClientboundDataDrivenUICloseScreenPacket) encode_payload(mut w serializer.Writer) {
	if id := p.form_id {
		w.bool(true)
		w.le_u32(id)
	} else {
		w.bool(false)
	}
}

module protocol

import serializer

pub struct ClientboundDataDrivenUIShowScreenPacket {
pub mut:
	screen_id        string
	form_id          u32
	data_instance_id ?u32
}

pub fn (p &ClientboundDataDrivenUIShowScreenPacket) pid() u16 {
	return clientbound_data_driven_ui_show_screen_packet
}

pub fn (p &ClientboundDataDrivenUIShowScreenPacket) name() string {
	return 'ClientboundDataDrivenUIShowScreenPacket'
}

pub fn (p &ClientboundDataDrivenUIShowScreenPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ClientboundDataDrivenUIShowScreenPacket) decode_payload(mut r serializer.Reader) ! {
	p.screen_id = r.read_string()!
	p.form_id = r.le_u32()!
	if r.bool()! {
		p.data_instance_id = r.le_u32()!
	} else {
		p.data_instance_id = none
	}
}

pub fn (p &ClientboundDataDrivenUIShowScreenPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.screen_id)
	w.le_u32(p.form_id)
	if id := p.data_instance_id {
		w.bool(true)
		w.le_u32(id)
	} else {
		w.bool(false)
	}
}

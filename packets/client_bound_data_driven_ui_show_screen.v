module packets

import protocol.serializer

pub struct ClientBoundDataDrivenUIShowScreenPacket {
pub mut:
	screen_id        string
	form_id          i32
	data_instance_id ?i32
}

pub fn (p &ClientBoundDataDrivenUIShowScreenPacket) pid() u16 {
	return 333
}

pub fn (p &ClientBoundDataDrivenUIShowScreenPacket) name() string {
	return 'ClientBoundDataDrivenUIShowScreenPacket'
}

pub fn (p &ClientBoundDataDrivenUIShowScreenPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ClientBoundDataDrivenUIShowScreenPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.screen_id)
	w.le_i32(p.form_id)
	if v := p.data_instance_id {
		w.bool(true)
		w.le_i32(v)
	} else {
		w.bool(false)
	}
}

pub fn (mut p ClientBoundDataDrivenUIShowScreenPacket) decode_payload(mut r serializer.Reader) ! {
	p.screen_id = r.read_string()!
	p.form_id = r.le_i32()!
	if r.bool()! {
		p.data_instance_id = r.le_i32()!
	}
}

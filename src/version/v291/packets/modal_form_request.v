module packets

import serializer

pub struct ModalFormRequestPacket {
pub mut:
	form_id   u32
	form_data string
}

pub fn (p &ModalFormRequestPacket) pid() u16 {
	return 100
}

pub fn (p &ModalFormRequestPacket) name() string {
	return 'ModalFormRequestPacket'
}

pub fn (p &ModalFormRequestPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ModalFormRequestPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(p.form_id)
	w.write_string(p.form_data)
}

pub fn (mut p ModalFormRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.form_id = r.read_varuint32()!
	p.form_data = r.read_string()!
}

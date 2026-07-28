module packets

import protocol.serializer

pub struct ModalFormResponsePacket {
pub mut:
	form_id   u32
	form_data string
}

pub fn (p &ModalFormResponsePacket) pid() u16 {
	return 101
}

pub fn (p &ModalFormResponsePacket) name() string {
	return 'ModalFormResponsePacket'
}

pub fn (p &ModalFormResponsePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ModalFormResponsePacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(p.form_id)
	w.write_string(p.form_data)
}

pub fn (mut p ModalFormResponsePacket) decode_payload(mut r serializer.Reader) ! {
	p.form_id = r.read_varuint32()!
	p.form_data = r.read_string()!
}

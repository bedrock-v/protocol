module src

import src.serializer

pub struct ModalFormResponsePacket {
pub mut:
	form_id       int
	form_data     ?string
	cancel_reason ?int
}

pub fn (p &ModalFormResponsePacket) pid() u16 {
	return modal_form_response_packet
}

pub fn (p &ModalFormResponsePacket) name() string {
	return 'ModalFormResponsePacket'
}

pub fn (p &ModalFormResponsePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ModalFormResponsePacket) decode_payload(mut r serializer.Reader) ! {
	p.form_id = int(r.read_varuint32()!)
	if r.bool()! {
		p.form_data = r.read_string()!
	} else {
		p.form_data = none
	}
	if r.bool()! {
		p.cancel_reason = int(r.u8()!)
	} else {
		p.cancel_reason = none
	}
}

pub fn (p &ModalFormResponsePacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.form_id))
	if data := p.form_data {
		w.bool(true)
		w.write_string(data)
	} else {
		w.bool(false)
	}
	if reason := p.cancel_reason {
		w.bool(true)
		w.u8(u8(reason))
	} else {
		w.bool(false)
	}
}

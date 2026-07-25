module packets

import serializer

pub enum ModalFormCancelReason as u8 {
	user_closed = 0
	user_busy   = 1
}

pub struct ModalFormResponsePacket {
pub mut:
	form_id       u32
	form_data     ?string
	cancel_reason ?ModalFormCancelReason
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
	if form_data := p.form_data {
		w.bool(true)
		w.write_string(form_data)
	} else {
		w.bool(false)
	}
	if cancel_reason := p.cancel_reason {
		w.bool(true)
		w.u8(u8(cancel_reason))
	} else {
		w.bool(false)
	}
}

pub fn (mut p ModalFormResponsePacket) decode_payload(mut r serializer.Reader) ! {
	p.form_id = r.read_varuint32()!
	if r.bool()! {
		p.form_data = r.read_string()!
	} else {
		p.form_data = none
	}
	if r.bool()! {
		p.cancel_reason = unsafe { ModalFormCancelReason(r.u8()!) }
	} else {
		p.cancel_reason = none
	}
}

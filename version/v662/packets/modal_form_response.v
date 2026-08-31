module packets

import protocol.serializer
import protocol.version.v662.enums

pub struct ModalFormResponsePacket {
pub mut:
	form_id            u32
	json_response      ?string
	form_cancel_reason ?enums.ModalFormCancelReason
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
	if val := p.json_response {
		w.bool(true)
		w.write_string(val)
	} else {
		w.bool(false)
	}
	if val := p.form_cancel_reason {
		w.bool(true)
		val.encode(mut w)
	} else {
		w.bool(false)
	}
}

pub fn (mut p ModalFormResponsePacket) decode_payload(mut r serializer.Reader) ! {
	p.form_id = r.read_varuint32()!
	if r.bool()! {
		p.json_response = r.read_string()!
	}
	if r.bool()! {
		p.form_cancel_reason = enums.ModalFormCancelReason.decode(mut r)!
	}
}

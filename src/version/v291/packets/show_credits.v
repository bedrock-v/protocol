module packets

import serializer

pub enum ShowCreditsStatus as i32 {
	start_credits = 0
	end_credits   = 1
}

pub struct ShowCreditsPacket {
pub mut:
	runtime_entity_id u64
	status            ShowCreditsStatus
}

pub fn (p &ShowCreditsPacket) pid() u16 {
	return 75
}

pub fn (p &ShowCreditsPacket) name() string {
	return 'ShowCreditsPacket'
}

pub fn (p &ShowCreditsPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ShowCreditsPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint64(p.runtime_entity_id)
	w.write_varint32(i32(p.status))
}

pub fn (mut p ShowCreditsPacket) decode_payload(mut r serializer.Reader) ! {
	p.runtime_entity_id = r.read_varuint64()!
	p.status = unsafe { ShowCreditsStatus(r.read_varint32()!) }
}

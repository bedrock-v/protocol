module packets

import protocol.serializer

pub struct TakeItemEntityPacket {
pub mut:
	item_runtime_entity_id u64
	runtime_entity_id      u64
}

pub fn (p &TakeItemEntityPacket) pid() u16 {
	return 17
}

pub fn (p &TakeItemEntityPacket) name() string {
	return 'TakeItemEntityPacket'
}

pub fn (p &TakeItemEntityPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &TakeItemEntityPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint64(p.item_runtime_entity_id)
	w.write_varuint64(p.runtime_entity_id)
}

pub fn (mut p TakeItemEntityPacket) decode_payload(mut r serializer.Reader) ! {
	p.item_runtime_entity_id = r.read_varuint64()!
	p.runtime_entity_id = r.read_varuint64()!
}

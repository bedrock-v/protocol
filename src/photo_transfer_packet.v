module src

import src.serializer

pub struct PhotoTransferPacket {
pub mut:
	photo_name           string
	photo_data           string
	book_id              string
	type                 u8
	source_type          u8
	owner_actor_unique_id i64
	new_photo_name       string
}

pub fn (p &PhotoTransferPacket) pid() u16 {
	return photo_transfer_packet
}

pub fn (p &PhotoTransferPacket) name() string {
	return 'PhotoTransferPacket'
}

pub fn (p &PhotoTransferPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p PhotoTransferPacket) decode_payload(mut r serializer.Reader) ! {
	p.photo_name = r.read_string()!
	p.photo_data = r.read_string()!
	p.book_id = r.read_string()!
	p.type = r.u8()!
	p.source_type = r.u8()!
	p.owner_actor_unique_id = i64(r.le_u64()!)
	p.new_photo_name = r.read_string()!
}

pub fn (p &PhotoTransferPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.photo_name)
	w.write_string(p.photo_data)
	w.write_string(p.book_id)
	w.u8(p.type)
	w.u8(p.source_type)
	w.le_u64(u64(p.owner_actor_unique_id))
	w.write_string(p.new_photo_name)
}

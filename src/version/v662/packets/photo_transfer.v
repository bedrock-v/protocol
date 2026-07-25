module packets

import serializer
import version.v662.enums

pub struct PhotoTransferPacket {
pub mut:
	photo_name     string
	photo_data     []u8
	book_id        string
	photo_type     enums.PhotoType
	source_type    enums.PhotoType
	owner_id       i64
	new_photo_name string
}

pub fn (p &PhotoTransferPacket) pid() u16 { return 99 }

pub fn (p &PhotoTransferPacket) name() string { return 'PhotoTransferPacket' }

pub fn (p &PhotoTransferPacket) can_be_sent_before_login() bool { return false }

pub fn (p &PhotoTransferPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.photo_name)
	w.write_string_bytes(p.photo_data)
	w.write_string(p.book_id)
	p.photo_type.encode(mut w)
	p.source_type.encode(mut w)
	w.le_i64(p.owner_id)
	w.write_string(p.new_photo_name)
}

pub fn (mut p PhotoTransferPacket) decode_payload(mut r serializer.Reader) ! {
	p.photo_name = r.read_string()!
	p.photo_data = r.read_string_bytes()!
	p.book_id = r.read_string()!
	p.photo_type = enums.PhotoType.decode(mut r)!
	p.source_type = enums.PhotoType.decode(mut r)!
	p.owner_id = r.le_i64()!
	p.new_photo_name = r.read_string()!
}

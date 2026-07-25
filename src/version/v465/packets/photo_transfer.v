module packets

import serializer

pub enum PhotoType as u8 {
	portfolio  = 0
	photo_item = 1
	book       = 2
}

pub struct PhotoTransferPacket {
pub mut:
	photo_name     string
	data           []u8
	book_id        string
	photo_type     PhotoType
	source_type    PhotoType
	owner_id       i64
	new_photo_name string
}

pub fn (p &PhotoTransferPacket) pid() u16 {
	return 99
}

pub fn (p &PhotoTransferPacket) name() string {
	return 'PhotoTransferPacket'
}

pub fn (p &PhotoTransferPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &PhotoTransferPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.photo_name)
	w.write_string_bytes(p.data)
	w.write_string(p.book_id)
	w.u8(u8(p.photo_type))
	w.u8(u8(p.source_type))
	w.le_i64(p.owner_id)
	w.write_string(p.new_photo_name)
}

pub fn (mut p PhotoTransferPacket) decode_payload(mut r serializer.Reader) ! {
	p.photo_name = r.read_string()!
	p.data = r.read_string_bytes()!
	p.book_id = r.read_string()!
	p.photo_type = unsafe { PhotoType(r.u8()!) }
	p.source_type = unsafe { PhotoType(r.u8()!) }
	p.owner_id = r.le_i64()!
	p.new_photo_name = r.read_string()!
}

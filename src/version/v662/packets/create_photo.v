module packets

import serializer

pub struct CreatePhotoPacket {
pub mut:
	raw_id          u64
	photo_name      string
	photo_item_name string
}

pub fn (p &CreatePhotoPacket) pid() u16 { return 171 }

pub fn (p &CreatePhotoPacket) name() string { return 'CreatePhotoPacket' }

pub fn (p &CreatePhotoPacket) can_be_sent_before_login() bool { return false }

pub fn (p &CreatePhotoPacket) encode_payload(mut w serializer.Writer) {
	w.le_u64(p.raw_id)
	w.write_string(p.photo_name)
	w.write_string(p.photo_item_name)
}

pub fn (mut p CreatePhotoPacket) decode_payload(mut r serializer.Reader) ! {
	p.raw_id = r.le_u64()!
	p.photo_name = r.read_string()!
	p.photo_item_name = r.read_string()!
}

module protocol

import serializer

pub struct CreatePhotoPacket {
pub mut:
	actor_unique_id i64
	photo_name      string
	photo_item_name string
}

pub fn (p &CreatePhotoPacket) pid() u16 {
	return create_photo_packet
}

pub fn (p &CreatePhotoPacket) name() string {
	return 'CreatePhotoPacket'
}

pub fn (p &CreatePhotoPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p CreatePhotoPacket) decode_payload(mut r serializer.Reader) ! {
	p.actor_unique_id = i64(r.le_u64()!)
	p.photo_name = r.read_string()!
	p.photo_item_name = r.read_string()!
}

pub fn (p &CreatePhotoPacket) encode_payload(mut w serializer.Writer) {
	w.le_u64(u64(p.actor_unique_id))
	w.write_string(p.photo_name)
	w.write_string(p.photo_item_name)
}

module packets

import protocol.serializer

pub struct PhotoTransferPacket {
pub mut:
	photo_name string
	photo_data string
	book_id    string
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
	w.write_string(p.photo_data)
	w.write_string(p.book_id)
}

pub fn (mut p PhotoTransferPacket) decode_payload(mut r serializer.Reader) ! {
	p.photo_name = r.read_string()!
	p.photo_data = r.read_string()!
	p.book_id = r.read_string()!
}

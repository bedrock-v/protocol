module packets

import protocol.serializer

pub struct PhotoTransferPacket {
pub mut:
	string1 string
	string2 string
	string3 string
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
	w.write_string(p.string1)
	w.write_string(p.string2)
	w.write_string(p.string3)
}

pub fn (mut p PhotoTransferPacket) decode_payload(mut r serializer.Reader) ! {
	p.string1 = r.read_string()!
	p.string2 = r.read_string()!
	p.string3 = r.read_string()!
}

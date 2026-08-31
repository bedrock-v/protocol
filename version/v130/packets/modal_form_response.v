module packets

import protocol.serializer

pub struct ModalFormResponsePacket {}

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
}

pub fn (mut p ModalFormResponsePacket) decode_payload(mut r serializer.Reader) ! {
}

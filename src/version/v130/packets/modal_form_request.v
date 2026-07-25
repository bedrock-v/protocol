module packets

import serializer

pub struct ModalFormRequestPacket {}

pub fn (p &ModalFormRequestPacket) pid() u16 {
	return 100
}

pub fn (p &ModalFormRequestPacket) name() string {
	return 'ModalFormRequestPacket'
}

pub fn (p &ModalFormRequestPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ModalFormRequestPacket) encode_payload(mut w serializer.Writer) {
}

pub fn (mut p ModalFormRequestPacket) decode_payload(mut r serializer.Reader) ! {
}

module protocol

import serializer

pub struct ResourcePacksReadyForValidationPacket {
}

pub fn (p &ResourcePacksReadyForValidationPacket) pid() u16 {
	return resource_packs_ready_for_validation_packet
}

pub fn (p &ResourcePacksReadyForValidationPacket) name() string {
	return 'ResourcePacksReadyForValidationPacket'
}

pub fn (p &ResourcePacksReadyForValidationPacket) can_be_sent_before_login() bool {
	return true
}

pub fn (mut p ResourcePacksReadyForValidationPacket) decode_payload(mut r serializer.Reader) ! {
}

pub fn (p &ResourcePacksReadyForValidationPacket) encode_payload(mut w serializer.Writer) {
}

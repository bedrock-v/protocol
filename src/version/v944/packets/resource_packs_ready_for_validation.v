module packets

import serializer

pub struct ResourcePacksReadyForValidationPacket {}

pub fn (p &ResourcePacksReadyForValidationPacket) pid() u16 { return 340 }

pub fn (p &ResourcePacksReadyForValidationPacket) name() string { return 'ResourcePacksReadyForValidationPacket' }

pub fn (p &ResourcePacksReadyForValidationPacket) can_be_sent_before_login() bool { return false }

pub fn (p &ResourcePacksReadyForValidationPacket) encode_payload(mut w serializer.Writer) {
}

pub fn (mut p ResourcePacksReadyForValidationPacket) decode_payload(mut r serializer.Reader) ! {
}

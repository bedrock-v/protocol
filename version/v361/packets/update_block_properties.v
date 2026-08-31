module packets

import protocol.serializer
import bedrock_v.nbt

pub struct UpdateBlockPropertiesPacket {
pub mut:
	properties nbt.RootTag
}

pub fn (p &UpdateBlockPropertiesPacket) pid() u16 {
	return 134
}

pub fn (p &UpdateBlockPropertiesPacket) name() string {
	return 'UpdateBlockPropertiesPacket'
}

pub fn (p &UpdateBlockPropertiesPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &UpdateBlockPropertiesPacket) encode_payload(mut w serializer.Writer) {
	w.write_nbt_compound_root(p.properties)
}

pub fn (mut p UpdateBlockPropertiesPacket) decode_payload(mut r serializer.Reader) ! {
	p.properties = r.read_nbt_compound_root()!
}

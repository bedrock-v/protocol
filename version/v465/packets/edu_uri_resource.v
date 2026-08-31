module packets

import protocol.serializer
import protocol.version.v465.types

pub struct EduUriResourcePacket {
pub mut:
	edu_shared_uri_resource types.EduSharedUriResource
}

pub fn (p &EduUriResourcePacket) pid() u16 {
	return 170
}

pub fn (p &EduUriResourcePacket) name() string {
	return 'EduUriResourcePacket'
}

pub fn (p &EduUriResourcePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &EduUriResourcePacket) encode_payload(mut w serializer.Writer) {
	p.edu_shared_uri_resource.encode(mut w)
}

pub fn (mut p EduUriResourcePacket) decode_payload(mut r serializer.Reader) ! {
	p.edu_shared_uri_resource = types.EduSharedUriResource.decode(mut r)!
}

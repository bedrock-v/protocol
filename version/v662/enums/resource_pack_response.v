module enums

import protocol.serializer

pub enum ResourcePackResponse as i8 {
	cancel                       = 1
	downloading                  = 2
	downloading_finished         = 3
	resource_pack_stack_finished = 4
}

pub fn (e ResourcePackResponse) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn ResourcePackResponse.decode(mut r serializer.Reader) !ResourcePackResponse {
	return unsafe { ResourcePackResponse(r.i8()!) }
}

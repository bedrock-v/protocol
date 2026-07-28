module types

import protocol.serializer
import protocol.version.v712.enums

pub struct FullContainerName {
pub mut:
	container  enums.ContainerEnumName
	dynamic_id i32
}

pub fn (t FullContainerName) encode(mut w serializer.Writer) {
	t.container.encode(mut w)
	w.le_i32(t.dynamic_id)
}

pub fn FullContainerName.decode(mut r serializer.Reader) !FullContainerName {
	return FullContainerName{
		container:  enums.ContainerEnumName.decode(mut r)!
		dynamic_id: r.le_i32()!
	}
}

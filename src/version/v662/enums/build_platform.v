module enums

import serializer

pub enum BuildPlatform as i32 {
	google        = 1
	ios           = 2
	osx           = 3
	amazon        = 4
	gear_vr       = 5
	uwp           = 7
	win32         = 8
	dedicated     = 9
	tv_os         = 10
	sony          = 11
	nx            = 12
	xbox          = 13
	windows_phone = 14
	linux         = 15
	unknown       = -1
}

pub fn (e BuildPlatform) encode(mut w serializer.Writer) {
	w.le_i32(i32(e))
}

pub fn BuildPlatform.decode(mut r serializer.Reader) !BuildPlatform {
	return unsafe { BuildPlatform(r.le_i32()!) }
}

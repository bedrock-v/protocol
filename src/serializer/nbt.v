module serializer

import nbt

pub fn (mut r Reader) read_nbt_compound_root() !nbt.RootTag {
	res := nbt.decode(r.data[r.offset..])!
	r.offset += res.read
	return res.root
}

pub fn (mut w Writer) write_nbt_compound_root(root nbt.RootTag) {
	w.write_raw(nbt.encode(root))
}

module packets

import nbt
import protocol.serializer
import protocol.version.v575.types

pub struct CameraPresetsPacket {
pub mut:
	presets []types.CameraPreset
}

pub fn (p &CameraPresetsPacket) pid() u16 {
	return 198
}

pub fn (p &CameraPresetsPacket) name() string {
	return 'CameraPresetsPacket'
}

pub fn (p &CameraPresetsPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &CameraPresetsPacket) encode_payload(mut w serializer.Writer) {
	mut values := []nbt.Tag{cap: p.presets.len}
	for preset in p.presets {
		values << nbt.Tag(preset.to_tag())
	}
	mut root := nbt.new_compound()
	root.set('presets', nbt.Tag(nbt.List{
		element_type: nbt.tag_compound
		values:       values
	}))
	w.write_nbt_compound_root(nbt.RootTag{
		name: ''
		tag:  nbt.Tag(root)
	})
}

pub fn (mut p CameraPresetsPacket) decode_payload(mut r serializer.Reader) ! {
	root := r.read_nbt_compound_root()!
	p.presets = []
	tag := root.tag
	if tag is nbt.Compound {
		if list := tag.get('presets') {
			if list is nbt.List {
				for value in list.values {
					if value is nbt.Compound {
						p.presets << types.CameraPreset.from_tag(value)
					}
				}
			}
		}
	}
}

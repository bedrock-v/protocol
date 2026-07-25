module types

import nbt

pub struct CameraPreset {
pub mut:
	identifier    string
	parent_preset string
	pos           ?[3]f32
	yaw           ?f32
	pitch         ?f32
}

pub fn (t CameraPreset) to_tag() nbt.Compound {
	mut c := nbt.new_compound()
	c.set('identifier', nbt.Tag(t.identifier))
	c.set('inherit_from', nbt.Tag(t.parent_preset))
	if pos := t.pos {
		c.set('pos_x', nbt.Tag(pos[0]))
		c.set('pos_y', nbt.Tag(pos[1]))
		c.set('pos_z', nbt.Tag(pos[2]))
	}
	if yaw := t.yaw {
		c.set('rot_y', nbt.Tag(yaw))
	}
	if pitch := t.pitch {
		c.set('rot_x', nbt.Tag(pitch))
	}
	return c
}

pub fn CameraPreset.from_tag(c nbt.Compound) CameraPreset {
	mut t := CameraPreset{}
	t.identifier = get_string(c, 'identifier') or { '' }
	t.parent_preset = get_string(c, 'inherit_from') or { '' }
	x := get_f32(c, 'pos_x')
	y := get_f32(c, 'pos_y')
	z := get_f32(c, 'pos_z')
	if x != none || y != none || z != none {
		t.pos = [x or { 0 }, y or { 0 }, z or { 0 }]!
	}
	if yaw := get_f32(c, 'rot_y') {
		t.yaw = yaw
	}
	if pitch := get_f32(c, 'rot_x') {
		t.pitch = pitch
	}
	return t
}

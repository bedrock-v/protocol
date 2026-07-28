module types

import nbt
import protocol.serializer

pub struct CameraEaseData {
pub mut:
	ease_type string
	time      f32
}

pub struct CameraSetInstruction {
pub mut:
	preset_runtime_id i32
	ease              ?CameraEaseData
	pos               ?[3]f32
	rot               ?[2]f32
	default_preset    ?bool
}

pub struct CameraFadeTimeData {
pub mut:
	fade_in_time  f32
	wait_time     f32
	fade_out_time f32
}

pub struct CameraFadeColor {
pub mut:
	r f32
	g f32
	b f32
}

pub struct CameraFadeInstruction {
pub mut:
	time_data ?CameraFadeTimeData
	color     ?CameraFadeColor
}

pub struct CameraInstruction {
pub mut:
	set_instruction  ?CameraSetInstruction
	clear            ?bool
	fade_instruction ?CameraFadeInstruction
}

fn get_compound(c nbt.Compound, key string) ?nbt.Compound {
	tag := c.get(key)?
	if tag is nbt.Compound {
		return tag
	}
	return none
}

fn get_f32(c nbt.Compound, key string) ?f32 {
	tag := c.get(key)?
	if tag is f32 {
		return tag
	}
	return none
}

fn get_i32(c nbt.Compound, key string) ?i32 {
	tag := c.get(key)?
	if tag is i32 {
		return tag
	}
	return none
}

fn get_i8(c nbt.Compound, key string) ?i8 {
	tag := c.get(key)?
	if tag is i8 {
		return tag
	}
	return none
}

fn get_string(c nbt.Compound, key string) ?string {
	tag := c.get(key)?
	if tag is string {
		return tag
	}
	return none
}

pub fn (t CameraInstruction) encode(mut w serializer.Writer) {
	mut root := nbt.new_compound()
	if set := t.set_instruction {
		mut set_tag := nbt.new_compound()
		set_tag.set('preset', nbt.Tag(set.preset_runtime_id))
		if ease := set.ease {
			mut ease_tag := nbt.new_compound()
			ease_tag.set('type', nbt.Tag(ease.ease_type))
			ease_tag.set('time', nbt.Tag(ease.time))
			set_tag.set('ease', nbt.Tag(ease_tag))
		}
		if pos := set.pos {
			mut pos_tag := nbt.new_compound()
			pos_tag.set('pos', nbt.Tag(nbt.List{
				element_type: nbt.tag_float
				values:       [nbt.Tag(pos[0]), nbt.Tag(pos[1]), nbt.Tag(pos[2])]
			}))
			set_tag.set('pos', nbt.Tag(pos_tag))
		}
		if rot := set.rot {
			mut rot_tag := nbt.new_compound()
			rot_tag.set('x', nbt.Tag(rot[0]))
			rot_tag.set('y', nbt.Tag(rot[1]))
			set_tag.set('rot', nbt.Tag(rot_tag))
		}
		if default_preset := set.default_preset {
			set_tag.set('default', nbt.Tag(i8(if default_preset { 1 } else { 0 })))
		}
		root.set('set', nbt.Tag(set_tag))
	}
	if clear := t.clear {
		root.set('clear', nbt.Tag(i8(if clear { 1 } else { 0 })))
	}
	if fade := t.fade_instruction {
		mut fade_tag := nbt.new_compound()
		if time := fade.time_data {
			mut time_tag := nbt.new_compound()
			time_tag.set('fadeIn', nbt.Tag(time.fade_in_time))
			time_tag.set('hold', nbt.Tag(time.wait_time))
			time_tag.set('fadeOut', nbt.Tag(time.fade_out_time))
			fade_tag.set('time', nbt.Tag(time_tag))
		}
		if color := fade.color {
			mut color_tag := nbt.new_compound()
			color_tag.set('r', nbt.Tag(color.r))
			color_tag.set('g', nbt.Tag(color.g))
			color_tag.set('b', nbt.Tag(color.b))
			fade_tag.set('color', nbt.Tag(color_tag))
		}
		root.set('fade', nbt.Tag(fade_tag))
	}
	w.write_nbt_compound_root(nbt.RootTag{
		name: ''
		tag:  nbt.Tag(root)
	})
}

pub fn CameraInstruction.decode(mut r serializer.Reader) !CameraInstruction {
	root := r.read_nbt_compound_root()!
	mut t := CameraInstruction{}
	tag := root.tag
	if tag is nbt.Compound {
		if set_tag := get_compound(tag, 'set') {
			mut set := CameraSetInstruction{}
			set.preset_runtime_id = get_i32(set_tag, 'preset') or { 0 }
			if ease_tag := get_compound(set_tag, 'ease') {
				set.ease = CameraEaseData{
					ease_type: get_string(ease_tag, 'type') or { '' }
					time:      get_f32(ease_tag, 'time') or { 0 }
				}
			}
			if pos_tag := get_compound(set_tag, 'pos') {
				mut pos := [3]f32{}
				if list := pos_tag.get('pos') {
					if list is nbt.List {
						for i, value in list.values {
							if i < 3 {
								if value is f32 {
									pos[i] = value
								}
							}
						}
					}
				}
				set.pos = pos
			}
			if rot_tag := get_compound(set_tag, 'rot') {
				set.rot = [get_f32(rot_tag, 'x') or { 0 }, get_f32(rot_tag, 'y') or { 0 }]!
			}
			if default_preset := get_i8(set_tag, 'default') {
				set.default_preset = default_preset != 0
			}
			t.set_instruction = set
		}
		if clear := get_i8(tag, 'clear') {
			t.clear = clear != 0
		}
		if fade_tag := get_compound(tag, 'fade') {
			mut fade := CameraFadeInstruction{}
			if time_tag := get_compound(fade_tag, 'time') {
				fade.time_data = CameraFadeTimeData{
					fade_in_time:  get_f32(time_tag, 'fadeIn') or { 0 }
					wait_time:     get_f32(time_tag, 'hold') or { 0 }
					fade_out_time: get_f32(time_tag, 'fadeOut') or { 0 }
				}
			}
			if color_tag := get_compound(fade_tag, 'color') {
				fade.color = CameraFadeColor{
					r: get_f32(color_tag, 'r') or { 0 }
					g: get_f32(color_tag, 'g') or { 0 }
					b: get_f32(color_tag, 'b') or { 0 }
				}
			}
			t.fade_instruction = fade
		}
	}
	return t
}

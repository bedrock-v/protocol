module types

import protocol.serializer
import protocol.version.v2192.enums
import protocol.version.v662.types as types_662

pub struct SerializedSkinAnimationFrame {
pub mut:
	image_width          u32
	image_height         u32
	image_bytes          []u8
	animation_type       enums.AnimatedTextureType
	frame_count          f32
	animation_expression enums.AnimationExpression
}

pub fn (t SerializedSkinAnimationFrame) encode(mut w serializer.Writer) {
	w.le_u32(t.image_width)
	w.le_u32(t.image_height)
	w.write_string_bytes(t.image_bytes)
	t.animation_type.encode(mut w)
	w.le_f32(t.frame_count)
	t.animation_expression.encode(mut w)
}

pub fn SerializedSkinAnimationFrame.decode(mut r serializer.Reader) !SerializedSkinAnimationFrame {
	return SerializedSkinAnimationFrame{
		image_width:          r.le_u32()!
		image_height:         r.le_u32()!
		image_bytes:          r.read_string_bytes()!
		animation_type:       enums.AnimatedTextureType.decode(mut r)!
		frame_count:          r.le_f32()!
		animation_expression: enums.AnimationExpression.decode(mut r)!
	}
}

pub struct PersonaPiecesEntry {
pub mut:
	piece_id         string
	piece_type       enums.PersonaPieceType
	pack_id          types_662.Uuid
	is_default_piece bool
	product_id       string
}

pub fn (t PersonaPiecesEntry) encode(mut w serializer.Writer) {
	w.write_string(t.piece_id)
	t.piece_type.encode(mut w)
	t.pack_id.encode(mut w)
	w.bool(t.is_default_piece)
	w.write_string(t.product_id)
}

pub fn PersonaPiecesEntry.decode(mut r serializer.Reader) !PersonaPiecesEntry {
	return PersonaPiecesEntry{
		piece_id:         r.read_string()!
		piece_type:       enums.PersonaPieceType.decode(mut r)!
		pack_id:          types_662.Uuid.decode(mut r)!
		is_default_piece: r.bool()!
		product_id:       r.read_string()!
	}
}

pub struct PieceTintColorsEntry {
pub mut:
	piece_type string
	colors     [4]i32
}

pub fn (t PieceTintColorsEntry) encode(mut w serializer.Writer) {
	w.write_string(t.piece_type)
	w.le_i32(t.colors[0])
	w.le_i32(t.colors[1])
	w.le_i32(t.colors[2])
	w.le_i32(t.colors[3])
}

pub fn PieceTintColorsEntry.decode(mut r serializer.Reader) !PieceTintColorsEntry {
	return PieceTintColorsEntry{
		piece_type: r.read_string()!
		colors:     [r.le_i32()!, r.le_i32()!, r.le_i32()!, r.le_i32()!]!
	}
}

pub struct SerializedSkin {
pub mut:
	skin_id                         string
	play_fab_id                     string
	skin_resource_patch             string
	skin_image_width                u32
	skin_image_height               u32
	skin_image_bytes                []u8
	animations                      []SerializedSkinAnimationFrame
	cape_image_width                u32
	cape_image_height               u32
	cape_image_bytes                []u8
	geometry_data                   string
	geometry_data_engine_version    string
	animation_data                  string
	cape_id                         string
	full_id                         string
	arm_size                        enums.ArmSizeType
	skin_color                      i32
	persona_pieces                  []PersonaPiecesEntry
	piece_tint_colors               []PieceTintColorsEntry
	is_premium_skin                 bool
	is_persona_skin                 bool
	is_persona_cape_on_classic_skin bool
	is_primary_user                 bool
	overrides_player_appearance     bool
	trusted_skin_flag               string
	profile_hash                    string
}

pub fn (t SerializedSkin) encode(mut w serializer.Writer) {
	w.write_string(t.skin_id)
	w.write_string(t.play_fab_id)
	w.write_string(t.skin_resource_patch)
	w.le_u32(t.skin_image_width)
	w.le_u32(t.skin_image_height)
	w.write_string_bytes(t.skin_image_bytes)
	w.write_varuint32(u32(t.animations.len))
	for e in t.animations {
		e.encode(mut w)
	}
	w.le_u32(t.cape_image_width)
	w.le_u32(t.cape_image_height)
	w.write_string_bytes(t.cape_image_bytes)
	w.write_string(t.geometry_data)
	w.write_string(t.geometry_data_engine_version)
	w.write_string(t.animation_data)
	w.write_string(t.cape_id)
	w.write_string(t.full_id)
	t.arm_size.encode(mut w)
	w.le_i32(t.skin_color)
	w.write_varuint32(u32(t.persona_pieces.len))
	for e in t.persona_pieces {
		e.encode(mut w)
	}
	w.write_varuint32(u32(t.piece_tint_colors.len))
	for e in t.piece_tint_colors {
		e.encode(mut w)
	}
	w.bool(t.is_premium_skin)
	w.bool(t.is_persona_skin)
	w.bool(t.is_persona_cape_on_classic_skin)
	w.bool(t.is_primary_user)
	w.bool(t.overrides_player_appearance)
	w.write_string(t.trusted_skin_flag)
	w.write_string(t.profile_hash)
}

pub fn SerializedSkin.decode(mut r serializer.Reader) !SerializedSkin {
	mut t := SerializedSkin{}
	t.skin_id = r.read_string()!
	t.play_fab_id = r.read_string()!
	t.skin_resource_patch = r.read_string()!
	t.skin_image_width = r.le_u32()!
	t.skin_image_height = r.le_u32()!
	t.skin_image_bytes = r.read_string_bytes()!
	anim_count := int(r.read_varuint32()!)
	t.animations = []SerializedSkinAnimationFrame{cap: anim_count}
	for _ in 0 .. anim_count {
		t.animations << SerializedSkinAnimationFrame.decode(mut r)!
	}
	t.cape_image_width = r.le_u32()!
	t.cape_image_height = r.le_u32()!
	t.cape_image_bytes = r.read_string_bytes()!
	t.geometry_data = r.read_string()!
	t.geometry_data_engine_version = r.read_string()!
	t.animation_data = r.read_string()!
	t.cape_id = r.read_string()!
	t.full_id = r.read_string()!
	t.arm_size = enums.ArmSizeType.decode(mut r)!
	t.skin_color = r.le_i32()!
	persona_count := int(r.read_varuint32()!)
	t.persona_pieces = []PersonaPiecesEntry{cap: persona_count}
	for _ in 0 .. persona_count {
		t.persona_pieces << PersonaPiecesEntry.decode(mut r)!
	}
	tint_count := int(r.read_varuint32()!)
	t.piece_tint_colors = []PieceTintColorsEntry{cap: tint_count}
	for _ in 0 .. tint_count {
		t.piece_tint_colors << PieceTintColorsEntry.decode(mut r)!
	}
	t.is_premium_skin = r.bool()!
	t.is_persona_skin = r.bool()!
	t.is_persona_cape_on_classic_skin = r.bool()!
	t.is_primary_user = r.bool()!
	t.overrides_player_appearance = r.bool()!
	t.trusted_skin_flag = r.read_string()!
	t.profile_hash = r.read_string()!
	return t
}

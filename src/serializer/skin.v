module serializer

import src.types

fn (mut r Reader) read_skin_image() !types.SkinImage {
	return types.SkinImage{
		width:  r.le_u32()!
		height: r.le_u32()!
		data:   r.read_string()!
	}
}

fn (mut w Writer) write_skin_image(img types.SkinImage) {
	w.le_u32(img.width)
	w.le_u32(img.height)
	w.write_string(img.data)
}

pub fn (mut r Reader) read_skin() !types.SkinData {
	mut s := types.SkinData{
		skin_id:        r.read_string()!
		play_fab_id:    r.read_string()!
		resource_patch: r.read_string()!
		skin_image:     r.read_skin_image()!
	}
	anim_count := r.le_u32()!
	s.animations = []types.SkinAnimation{}
	for _ in 0 .. anim_count {
		s.animations << types.SkinAnimation{
			image:           r.read_skin_image()!
			type:            r.le_u32()!
			frames:          r.le_f32()!
			expression_type: r.le_u32()!
		}
	}
	s.cape_image = r.read_skin_image()!
	s.geometry_data = r.read_string()!
	s.geometry_data_version = r.read_string()!
	s.animation_data = r.read_string()!
	s.cape_id = r.read_string()!
	s.full_skin_id = r.read_string()!
	s.arm_size = r.read_string()!
	s.skin_color = r.read_string()!
	piece_count := r.le_u32()!
	s.persona_pieces = []types.PersonaSkinPiece{}
	for _ in 0 .. piece_count {
		s.persona_pieces << types.PersonaSkinPiece{
			piece_id:   r.read_string()!
			piece_type: r.read_string()!
			pack_id:    r.read_string()!
			is_default: r.bool()!
			product_id: r.read_string()!
		}
	}
	tint_count := r.le_u32()!
	s.piece_tint_colors = []types.PersonaPieceTintColor{}
	for _ in 0 .. tint_count {
		piece_type := r.read_string()!
		color_count := r.le_u32()!
		mut colors := []string{}
		for _ in 0 .. color_count {
			colors << r.read_string()!
		}
		s.piece_tint_colors << types.PersonaPieceTintColor{
			piece_type: piece_type
			colors:     colors
		}
	}
	s.premium = r.bool()!
	s.persona = r.bool()!
	s.cape_on_classic = r.bool()!
	s.is_primary_user = r.bool()!
	s.override = r.bool()!
	return s
}

pub fn (mut w Writer) write_skin(s types.SkinData) {
	w.write_string(s.skin_id)
	w.write_string(s.play_fab_id)
	w.write_string(s.resource_patch)
	w.write_skin_image(s.skin_image)
	w.le_u32(u32(s.animations.len))
	for a in s.animations {
		w.write_skin_image(a.image)
		w.le_u32(a.type)
		w.le_f32(a.frames)
		w.le_u32(a.expression_type)
	}
	w.write_skin_image(s.cape_image)
	w.write_string(s.geometry_data)
	w.write_string(s.geometry_data_version)
	w.write_string(s.animation_data)
	w.write_string(s.cape_id)
	w.write_string(s.full_skin_id)
	w.write_string(s.arm_size)
	w.write_string(s.skin_color)
	w.le_u32(u32(s.persona_pieces.len))
	for p in s.persona_pieces {
		w.write_string(p.piece_id)
		w.write_string(p.piece_type)
		w.write_string(p.pack_id)
		w.bool(p.is_default)
		w.write_string(p.product_id)
	}
	w.le_u32(u32(s.piece_tint_colors.len))
	for t in s.piece_tint_colors {
		w.write_string(t.piece_type)
		w.le_u32(u32(t.colors.len))
		for c in t.colors {
			w.write_string(c)
		}
	}
	w.bool(s.premium)
	w.bool(s.persona)
	w.bool(s.cape_on_classic)
	w.bool(s.is_primary_user)
	w.bool(s.override)
}

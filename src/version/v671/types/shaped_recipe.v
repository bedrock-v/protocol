module types

import protocol.serializer
import protocol.version.v662.types as types_662

pub struct ShapedRecipe {
pub mut:
	recipe_unique_id string
	ingredient_grid  [][]types_662.RecipeIngredient
	production_list  []types_662.NetworkItemInstanceDescriptor
	recipe_id        types_662.Uuid
	recipe_tag       string
	priority         i32
	assume_symmetry  bool
	network_id       u32
}

pub fn (t ShapedRecipe) encode(mut w serializer.Writer) {
	w.write_string(t.recipe_unique_id)
	x_len := u32(t.ingredient_grid.len)
	y_len := if x_len > 0 { u32(t.ingredient_grid[0].len) } else { u32(0) }
	w.write_varuint32(x_len)
	w.write_varuint32(y_len)
	for row in t.ingredient_grid {
		for ing in row {
			ing.encode(mut w)
		}
	}
	w.write_varuint32(u32(t.production_list.len))
	for e in t.production_list {
		e.encode(mut w)
	}
	t.recipe_id.encode(mut w)
	w.write_string(t.recipe_tag)
	w.write_varint32(t.priority)
	w.bool(t.assume_symmetry)
	w.write_varuint32(t.network_id)
}

pub fn ShapedRecipe.decode(mut r serializer.Reader) !ShapedRecipe {
	mut t := ShapedRecipe{}
	t.recipe_unique_id = r.read_string()!
	x_len := int(r.read_varuint32()!)
	y_len := int(r.read_varuint32()!)
	t.ingredient_grid = [][]types_662.RecipeIngredient{cap: x_len}
	for _ in 0 .. x_len {
		mut row := []types_662.RecipeIngredient{cap: y_len}
		for _ in 0 .. y_len {
			row << types_662.RecipeIngredient.decode(mut r)!
		}
		t.ingredient_grid << row
	}
	prod_count := int(r.read_varuint32()!)
	t.production_list = []types_662.NetworkItemInstanceDescriptor{cap: prod_count}
	for _ in 0 .. prod_count {
		t.production_list << types_662.NetworkItemInstanceDescriptor.decode(mut r)!
	}
	t.recipe_id = types_662.Uuid.decode(mut r)!
	t.recipe_tag = r.read_string()!
	t.priority = r.read_varint32()!
	t.assume_symmetry = r.bool()!
	t.network_id = r.read_varuint32()!
	return t
}

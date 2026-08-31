module types

import protocol.serializer

pub struct ShapedRecipe {
pub mut:
	recipe_unique_id string
	ingredient_grid  [][]RecipeIngredient
	production_list  []NetworkItemInstanceDescriptor
	recipe_id        Uuid
	recipe_tag       string
	priority         i32
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
	w.write_varuint32(t.network_id)
}

pub fn ShapedRecipe.decode(mut r serializer.Reader) !ShapedRecipe {
	mut t := ShapedRecipe{}
	t.recipe_unique_id = r.read_string()!
	x_len := r.read_count()!
	y_len := r.read_count()!
	t.ingredient_grid = [][]RecipeIngredient{cap: serializer.prealloc(x_len)}
	for _ in 0 .. x_len {
		mut row := []RecipeIngredient{cap: serializer.prealloc(y_len)}
		for _ in 0 .. y_len {
			row << RecipeIngredient.decode(mut r)!
		}
		t.ingredient_grid << row
	}
	prod_count := r.read_count()!
	t.production_list = []NetworkItemInstanceDescriptor{cap: serializer.prealloc(prod_count)}
	for _ in 0 .. prod_count {
		t.production_list << NetworkItemInstanceDescriptor.decode(mut r)!
	}
	t.recipe_id = Uuid.decode(mut r)!
	t.recipe_tag = r.read_string()!
	t.priority = r.read_varint32()!
	t.network_id = r.read_varuint32()!
	return t
}

//! Storage operations for models and entities.

use sai::meta::{Layout, FieldLayout};

/// Write a new entity.
///
/// # Arguments
///   * `model_selector` - the model selector
///   * `entity_id` - the id used to identify the record
///   * `values` - the field values of the record
///   * `layout` - the model layout
pub fn write_model_entity(
    model_selector: felt252, entity_id: felt252, values: Span<felt252>, layout: Layout
) {
    let mut offset = 0;

    match layout {
        Layout::Fixed(layout) => {
            super::layout::write_fixed_layout(
                model_selector, entity_id, values, ref offset, layout
            );
        },
        Layout::Struct(layout) => {
            super::layout::write_struct_layout(
                model_selector, entity_id, values, ref offset, layout
            );
        },
        _ => { panic!("Unexpected layout type for a model."); }
    };
}

pub fn write_entity_from_field_layouts(
    model_selector: felt252,
    field_layouts: Span<FieldLayout>,
    entity_id: felt252,
    values: Span<felt252>
) {
    let mut offset = 0;
    super::layout::write_struct_layout(
        model_selector, entity_id, values, ref offset, field_layouts
    );
}

pub fn read_entity_from_field_layouts(
    model_selector: felt252, field_layouts: Span<FieldLayout>, entity_id: felt252
) -> Span<felt252> {
    let mut read_data = ArrayTrait::<felt252>::new();
    super::layout::read_struct_layout(model_selector, entity_id, ref read_data, field_layouts);
    read_data.span()
}
/// Read an entity.
///
/// # Arguments
///   * `model_selector` - the model selector
///   * `entity_id` - the ID of the entity to read.
///   * `layout` - the model layout
pub fn read_model_entity(
    model_selector: felt252, entity_id: felt252, layout: Layout
) -> Span<felt252> {
    let mut read_data = ArrayTrait::<felt252>::new();

    match layout {
        Layout::Fixed(layout) => {
            super::layout::read_fixed_layout(model_selector, entity_id, ref read_data, layout);
        },
        Layout::Struct(layout) => {
            super::layout::read_struct_layout(model_selector, entity_id, ref read_data, layout);
        },
        _ => { panic!("Unexpected layout type for a model."); }
    };

    read_data.span()
}

/// Read a model member value.
///
/// # Arguments
///   * `model_selector` - the model selector
///   * `entity_id` - the ID of the entity for which to read a member.
///   * `member_id` - the selector of the model member to read.
///   * `layout` - the model layout
pub fn read_model_member(
    model_selector: felt252, entity_id: felt252, member_id: felt252, layout: Layout
) -> Span<felt252> {
    let mut read_data = ArrayTrait::<felt252>::new();
    super::layout::read_layout(
        model_selector, sai::utils::combine_key(entity_id, member_id), ref read_data, layout
    );

    read_data.span()
}

/// Write a model member value.
///
/// # Arguments
///   * `model_selector` - the model selector
///   * `entity_id` - the ID of the entity for which to write a member.
///   * `member_id` - the selector of the model member to write.
///   * `values` - the new member value.
///   * `layout` - the model layout
pub fn write_model_member(
    model_selector: felt252,
    entity_id: felt252,
    member_id: felt252,
    values: Span<felt252>,
    layout: Layout
) {
    let mut offset = 0;
    super::layout::write_layout(
        model_selector, sai::utils::combine_key(entity_id, member_id), values, ref offset, layout
    )
}

use sai::meta::Schema;

#[starknet::interface]
pub trait IPublisher<T> {
    fn set_entity(ref self: T, table: felt252, id: felt252, schema: Schema, values: Span<felt252>);
    fn set_entities(
        ref self: T,
        table: felt252,
        ids: Span<felt252>,
        schema: Schema,
        values: Array<Span<felt252>>,
    );
}


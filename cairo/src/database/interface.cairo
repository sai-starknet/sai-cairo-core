use sai::meta::Schema;

#[starknet::interface]
pub trait IDatabase<T> {
    fn read_entity(self: @T, table: felt252, id: felt252, schema: Schema) -> Array<felt252>;
    fn read_entities(
        self: @T, table: felt252, ids: Span<felt252>, schema: Schema
    ) -> Array<Array<felt252>>;
    fn write_entity(
        ref self: T, table: felt252, id: felt252, schema: Schema, values: Span<felt252>
    );
    fn write_entities(
        ref self: T,
        table: felt252,
        ids: Span<felt252>,
        schema: Schema,
        values: Array<Span<felt252>>,
    );
}


use sai::meta::Schema;

#[starknet::interface]
pub trait IDatabase<T> {
    fn read_entity(self: @T, table: felt252, schema: Schema, id: felt252) -> Span<felt252>;
    fn read_entities(
        self: @T, table: felt252, schema: Schema, ids: Span<felt252>
    ) -> Array<Span<felt252>>;
    fn write_entity(
        ref self: T, table: felt252, schema: Schema, id: felt252, values: Span<felt252>
    );
    fn write_entities(
        ref self: T, table: felt252, schema: Schema, entities: Array<SerializedEntity>
    );
}


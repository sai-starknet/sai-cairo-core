use sai::{store::{IdWrite, IdSet, IdSetWrite, SchemaData}, meta::FieldLayout};

#[starknet::interface]
pub trait IStoreSet<S> {
    fn store_set_entity(
        ref self: S, table: felt252, schema_selector: felt252, id: felt252, values: Span<felt252>
    );
    fn store_set_entities(
        ref self: S, table: felt252, schema_selector: felt252, entities: Array<IdSet>
    );
}

#[starknet::interface]
pub trait IStoreWrite<S> {
    fn store_write_entity(
        ref self: S, table: felt252, schema: SchemaData, id: felt252, values: Span<felt252>
    );
    fn store_write_entities(
        ref self: S, table: felt252, schema: SchemaData, entities: Array<IdWrite>
    );
}

#[starknet::interface]
pub trait IStoreSetWrite<S> {
    fn store_set_write_entity(
        ref self: S,
        table: felt252,
        schema: SchemaData,
        id: felt252,
        set: Span<felt252>,
        write: Span<felt252>
    );
    fn store_set_write_entities(
        ref self: S, table: felt252, schema: SchemaData, entities: Array<IdSetWrite>
    );
}

#[starknet::interface]
pub trait IStoreRead<S> {
    fn store_read_entity(
        self: @S, table: felt252, fields: Span<FieldLayout>, id: felt252
    ) -> Span<felt252>;
    fn store_read_entities(
        self: @S, table: felt252, fields: Span<FieldLayout>, ids: Span<felt252>
    ) -> Array<Span<felt252>>;
}

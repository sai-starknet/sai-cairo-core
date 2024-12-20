use sai::{
    database::DatabaseInterface, meta::Schema,
    storage::entity_model::{read_entity_from_schema, write_entity_from_schema},
    publisher::IPublisher
};

struct StoreAuthor {}
#[derive(Drop, Copy)]
struct StoreAuthor<P> {
    publisher: P,
}

impl LocalDatabaseInterfaceImpl<
    P, +Drop<P>, +Copy<P>, +IPublisher<P>
> of DatabaseInterface<LocalDatabase<P>> {
    fn read_entity(
        self: @LocalDatabase<P>, table: felt252, id: felt252, schema: Schema
    ) -> Span<felt252> {
        read_entity_from_schema(table, id, schema)
    }

    fn read_entities(
        self: @LocalDatabase<P>, table: felt252, ids: Span<felt252>, schema: Schema
    ) -> Array<Span<felt252>> {
        let mut entities = ArrayTrait::<Span<felt252>>::new();
        for id in ids {
            entities.append(read_entity_from_schema(table, *id, schema));
        };
        entities
    }

    fn write_entity(
        ref self: LocalDatabase<P>,
        table: felt252,
        id: felt252,
        values: Span<felt252>,
        schema: Schema
    ) {
        write_entity_from_schema(table, id, schema, values);
        let mut publisher = self.publisher;
        publisher.set_entity(table, id, schema, values);
    }

    fn write_entities(
        ref self: LocalDatabase<P>,
        table: felt252,
        mut ids: Span<felt252>,
        mut values: Array<Span<felt252>>,
        schema: Schema
    ) {
        loop {
            match (ids.pop_front(), values.pop_front()) {
                (
                    Option::Some(id), Option::Some(values)
                ) => { write_entity_from_schema(table, *id, schema, values); },
                _ => { break; }
            }
        };
        let mut publisher = self.publisher;
        publisher.set_entities(table, ids, schema, values);
    }
}

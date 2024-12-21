use sai::{
    author::{utils::{entities_to_schemas, schemas_to_id_set_write}}, schema::{Schema, SchemaId},
    store::{IStoreSetWrite, IStoreRead}, utils::{entity_id_from_keys, entity_ids_from_keys}
};


trait DatabaseAuthor<A> {
    fn read<K, M, +Serde<K>, +Drop<K>, +Schema<M>, +Drop<Schema::<M>::Keys>>(
        self: @A, table: felt252, keys: K
    ) -> M;
    fn reads<K, M, +Serde<K>, +Drop<K>, +Schema<M>, +Drop<M>, +Drop<Schema::<M>::Keys>>(
        self: @A, table: felt252, keys: Array<K>
    ) -> Array<M>;
    fn write<M, +Drop<M>, +SchemaId<M>, +Schema<M>>(ref self: A, table: felt252, model: M);
    fn writes<M, +Drop<M>, +SchemaId<M>, +Schema<M>>(ref self: A, table: felt252, models: Array<M>);
}


impl StorageAuthorImpl<A, +Drop<A>, +IStoreSetWrite<A>, +IStoreRead<A>> of DatabaseAuthor<A> {
    fn read<K, M, +Serde<K>, +Drop<K>, +Schema<M>, +Drop<Schema::<M>::Keys>>(
        self: @A, table: felt252, keys: K
    ) -> M {
        let serialized = self
            .store_read_entity(
                table, Schema::<M>::write_field_layouts(), entity_id_from_keys(@keys)
            );
        let keys = Schema::<M>::parse_keys(keys);
        Schema::<M>::from_keys_and_serialized(keys, serialized, [].span())
    }
    fn reads<K, M, +Drop<K>, +Serde<K>, +Schema<M>, +Drop<M>, +Drop<Schema::<M>::Keys>>(
        self: @A, table: felt252, keys: Array<K>
    ) -> Array<M> {
        let entity_ids = entity_ids_from_keys(keys.span());
        entities_to_schemas(
            keys, self.store_read_entities(table, Schema::<M>::write_field_layouts(), entity_ids)
        )
    }
    fn write<M, +Drop<M>, +SchemaId<M>, +Schema<M>>(ref self: A, table: felt252, model: M) {
        self
            .store_set_write_entity(
                table,
                Schema::<M>::schema_data(),
                model.id(),
                model.set_serialized(),
                model.write_serialized()
            )
    }
    fn writes<M, +Drop<M>, +SchemaId<M>, +Schema<M>>(
        ref self: A, table: felt252, models: Array<M>
    ) {
        self
            .store_set_write_entities(
                table, Schema::<M>::schema_data(), schemas_to_id_set_write(models)
            )
    }
}

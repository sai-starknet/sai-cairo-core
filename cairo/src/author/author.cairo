use sai::{
    author::{IAuthor, utils::{entities_to_schemas, schemas_to_id_set_write}}, schema::{Schema, Id},
    database::{IDatabase, SerializedEntity}, store::{IStoreSetWrite, IStoreRead},
    utils::{entity_id_from_keys, entity_ids_from_keys}
};


trait DatabaseAuthor<A> {
    fn read_model<K, M, +Serde<K>, +Drop<K>, +Schema<M>>(self: @A, table: felt252, keys: K) -> M;
    fn read_models<K, M, +Serde<K>, +Drop<K>, +Schema<M>, +Drop<M>>(
        self: @A, table: felt252, keys: Span<K>
    ) -> Array<M>;
    fn write_model<M, +Id<M>, +Schema<M>>(ref self: A, table: felt252, model: M);
    fn write_models<M, +Drop<M>, +Id<M>, +Schema<M>>(ref self: A, table: felt252, models: Array<M>);
}


impl StorageAuthorImpl<A, +Drop<A>, +IStoreSetWrite<A>, +IStoreRead<A>> of DatabaseAuthor<A> {
    fn read_model<K, M, +Serde<K>, +Drop<K>, +Schema<M>>(self: @A, table: felt252, keys: K) -> M {
        let serialized = self
            .store_read_entity(
                table, Schema::<M>::write_field_layouts(), entity_id_from_keys(@keys)
            );

        Schema::<M>::from_keys_and_serialized(keys, serialized, [].span())
    }
    fn read_models<K, M, +Drop<K>, +Serde<k>, +Schema<M>, +Drop<M>>(
        self: @A, table: felt252, keys: Array<K>
    ) -> Array<M> {
        entities_to_schemas(
            keys,
            self
                .store_read_entities(
                    table, Schema::<M>::write_field_layouts(), entity_ids_from_keys(keys.span())
                )
        )
    }
    fn write_model<M, +Drop<M>, +Id<M>, +Schema<M>>(ref self: A, table: felt252, model: M) {
        self
            .store_set_write_entity(
                table,
                Schema::<M>::schema_data(),
                model.id(),
                model.set_serialized(),
                model.write_serialized()
            )
    }
    fn write_models<M, +Drop<M>, +Id<M>, +Schema<M>>(
        ref self: A, table: felt252, models: Array<M>
    ) {
        self
            .store_set_write_entities(
                table, Schema::<M>::schema_data(), schemas_to_id_set_write(models)
            )
    }
}

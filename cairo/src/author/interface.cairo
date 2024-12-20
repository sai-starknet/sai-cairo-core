use sai::{meta::FieldLayout, schema::ModelSerialized};

#[starknet::interface]
pub trait IAuthor<TContractState> {
    fn storage_write_model(
        ref self: TContractState,
        table: felt252,
        publish_selectors: Span<felt252>,
        write_layout: Span<FieldLayout>,
        id: felt252,
        publish_values: Span<felt252>,
        write_values: Span<felt252>
    );
    fn storage_write_models(
        ref self: TContractState,
        table: felt252,
        publish_selectors: Span<felt252>,
        write_layout: Span<FieldLayout>,
        models: Array<ModelSerialized>
    );
}




trait TableAuthor<A>{
    fn read_model<K, M, +SchemaTrait<M>>(self: @A, keys: K) -> M;
    fn read_models<K, M, +SchemaTrait<M>>(self: @A, keys: Span<K>) -> Array<M>;
    fn write_model<M, +IdTrait<M>, +SchemaTrait<M>>(ref self: A, model: M);
    fn write_models<M, +IdTrait<M>, +SchemaTrait<M>>(ref self: A, models: Array<M>);
    fn write_entity<K, M, +Serde<K>, +SchemaTrait<M>>(ref self: A, id: K, entity: M);
    fn write_entities<K, M, +Serde<K>, +SchemaTrait<M>>(ref self: A, entities: Array<(K, M)>);
}





struct MySchema {
    #[key]
    key_1: felt252,
    #[key]
    key_2: felt252,
    #[set]
    pub_value: felt252,
    write_value: felt252
}


struct MySchema2 {
    #[key]
    key_1: felt252,
    #[key]
    key_2: felt252,
    #[sai::set]
    pub_value: felt252,
    write_value: felt252
}

trait ModelTrait<T> {
    fn new<S, +Serde<S>>(data: S) -> T;
    fn new_from_serialized(data: Span<felt252>) -> T;
    fn keys<K>(self: @T) -> K;
    fn set_fields<V>(self: @T) -> V;
    fn write_fields<V>(self: @T) -> V;
    fn add_keys<K>(self: @T, keys: K) -> T;
    fn add_set_fields<V>(self: @T, fields: V) -> T;
    fn add_write_fields<V>(self: @T, fields: V) -> T;
}



trait EntityTrait<T>{
    fn <K, M>(self: @T, fields: K) -> ;
    fn append_fields<K, M>(self: @T, fields: K) -> ;
}

struct MySchema{
    #[key]
    key_1: felt252,
    #[key]
    key_2: felt252,
    #[set]
    pub_value: felt252,
    write_value: felt252
}

struct MySchema1{
    #[id]
    key: felt252,
    write_value: felt252
}

let value: MySchema = something;
let value_1: MySchema1 = cast!(value)

let value_2: MySchema = cast!(value_1, key_1, key_2, pub_value)

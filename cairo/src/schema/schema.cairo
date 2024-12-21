use sai::{
    meta::FieldLayout, schema::{ModelSerialized}, store::{SchemaData, IdSetWrite},
    utils::entity_id_from_keys
};

/// Implemented on every Schema
pub trait Schema<T> {
    type Keys;
    fn table_selector() -> felt252;
    fn selector() -> felt252;
    fn schema_data() -> SchemaData;
    fn set_selectors() -> Span<felt252>;
    fn write_field_layouts() -> Span<FieldLayout>;
    fn keys(self: @T) -> @Self::Keys;
    fn set_serialized(self: @T) -> Span<felt252>;
    fn serialize_set(self: @T, ref output: Array<felt252>);
    fn write_serialized(self: @T) -> Span<felt252>;
    fn serialize_write(self: @T, ref output: Array<felt252>);
    fn from_keys_and_serialized(keys: Self::Keys, write: Span<felt252>, set: Span<felt252>) -> T;
}

pub trait SchemaGenerate<T> {
    fn _keys<K>(self: @T) -> @K;
    fn _serialize_set(self: @T, ref output: Array<felt252>);
    fn _serialize_write(self: @T, ref output: Array<felt252>);
    fn _from_keys_and_serialized<K>(keys: K, write: Span<felt252>, set: Span<felt252>) -> T;
}

/// Only on schemas with an id or field/s with key
pub trait Id<T> {
    fn id(self: @T) -> felt252;
    fn id_set_write(self: @T) -> IdSetWrite;
}


pub trait Keys<T> {
    fn id(self: @T) -> felt252;
    fn serialize_keys(self: @T) -> Span<felt252>;
}

type KeySchemaTuple<K, T> = (K, T);

impl KeySchemaTupleIdImpl<K, T, +Serde<K>, +Schema<T>> of Id<(K, T)> {
    fn id(self: @(K, T)) -> felt252 {
        let (k, _) = self;
        entity_id_from_keys(k)
    }
    fn id_set_write(self: @(K, T)) -> IdSetWrite {
        let (k, t) = self;
        let mut set = ArrayTrait::<felt252>::new();
        Serde::serialize(k, ref set);
        t.serialize_set(ref set);

        IdSetWrite { id: entity_id_from_keys(k), set: set.span(), write: t.write_serialized() }
    }
}

impl KeySchemaTupleSchemaImpl<K, T, +Serde<K>, +Schema<T>> of Schema<(K, T)> {
    type Keys = K;
    fn table_selector() -> felt252 {
        Schema::<T>::table_selector()
    }
    fn selector() -> felt252 {
        Schema::<T>::selector()
    }
    fn schema_data() -> SchemaData {
        Schema::<T>::schema_data()
    }
    fn set_selectors() -> Span<felt252> {
        Schema::<T>::set_selectors()
    }
    fn write_field_layouts() -> Span<FieldLayout> {
        Schema::<T>::write_field_layouts()
    }
    fn keys(self: @(K, T)) -> @K {
        let (k, _) = self;
        k
    }
    fn set_serialized(self: @(K, T)) -> Span<felt252> {
        let (_, t) = self;
        t.set_serialized()
    }
    fn serialize_set(self: @(K, T), ref output: Array<felt252>) {
        let (k, t) = self;
        Serde::serialize(k, ref output);
        t.serialize_set(ref output);
    }
    fn write_serialized(self: @(K, T)) -> Span<felt252> {
        let (_, t) = self;
        t.write_serialized()
    }
    fn serialize_write(self: @(K, T), ref output: Array<felt252>) {
        let (k, t) = self;
        Serde::serialize(k, ref output);
        t.serialize_write(ref output);
    }
    fn from_keys_and_serialized(keys: K, write: Span<felt252>, set: Span<felt252>) -> (K, T) {
        (keys, Schema::<T>::from_keys_and_serialized(Schema::<T>::Keys, write, set))
    }
}


trait ExampleTrait<T> {
    type Foo;
    fn foo(self: @T) -> @Self::Foo;
    fn bar(key: Self::Foo, value: Span<felt252>) -> T;
}

impl ExampleLink<K, T, +Serde<T>> of ExampleTrait<(K, T)> {
    type Foo = K;
    fn foo(self: @(K, T)) -> @K {
        let (k, _) = self;
        k
    }

    fn bar(key: K, mut value: Span<felt252>) -> (K, T) {
        (key, Serde::<T>::deserialize(ref value).unwrap())
    }
}

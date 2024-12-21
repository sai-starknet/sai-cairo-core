use sai::{
    meta::FieldLayout, store::{SchemaData, IdSetWrite, IdWrite, IdSet, SetWrite},
    utils::{entity_id_from_keys, serialize_inline}
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
    fn keys_serialized(self: @T) -> Span<felt252>;
    fn serialize_keys(self: @T, ref output: Array<felt252>);
    fn set_serialized(self: @T) -> Span<felt252>;
    fn serialize_set(self: @T, ref output: Array<felt252>);
    fn write_serialized(self: @T) -> Span<felt252>;
    fn serialize_write(self: @T, ref output: Array<felt252>);
    fn from_keys_and_serialized(keys: Self::Keys, write: Span<felt252>, set: Span<felt252>) -> T;
    fn set_write(self: @T) -> SetWrite;
    fn parse_keys<K, +Serde<K>, +Drop<K>>(key: K) -> Self::Keys;
}

/// Code generated for every schema
pub trait SchemaGenerate<T> {
    fn _keys<K, +Serde<K>>(self: @T) -> @K;
    fn _serialize_set(self: @T, ref output: Array<felt252>);
    fn _serialize_write(self: @T, ref output: Array<felt252>);
    fn _from_keys_and_serialized<K, +Serde<K>>(
        keys: K, write: Span<felt252>, set: Span<felt252>
    ) -> T;
    fn _set_selectors() -> Span<felt252>;
    fn _write_field_layouts() -> Span<FieldLayout>;
    fn _parse_keys<KI, KO>(key: KI) -> KO;
}

/// On Schemas without Ids
pub trait SchemaSanId<T> {
    fn from_serialized(write: Span<felt252>, set: Span<felt252>) -> T;
}

/// Only on schemas with an id or field/s with key
pub trait SchemaId<T> {
    fn id(self: @T) -> felt252;
    fn id_set_write(self: @T) -> IdSetWrite;
    fn id_write(self: @T) -> IdWrite;
    fn id_set(self: @T) -> IdSet;
}


pub trait Keys<T> {
    fn id(self: @T) -> felt252;
    fn serialize_keys(self: @T) -> Span<felt252>;
}

impl KeySchemaTupleIdImpl<K, T, +Serde<K>, +Schema<T>> of SchemaId<(K, T)> {
    fn id(self: @(K, T)) -> felt252 {
        let (k, _) = self;
        entity_id_from_keys(k)
    }
    fn id_set_write(self: @(K, T)) -> IdSetWrite {
        let (k, t) = self;
        IdSetWrite {
            id: entity_id_from_keys(k), set: t.set_serialized(), write: t.write_serialized()
        }
    }
    fn id_write(self: @(K, T)) -> IdWrite {
        let (k, t) = self;
        IdWrite { id: entity_id_from_keys(k), write: t.write_serialized() }
    }
    fn id_set(self: @(K, T)) -> IdSet {
        let (k, t) = self;
        IdSet { id: entity_id_from_keys(k), set: t.set_serialized() }
    }
}

pub impl StaticSchemaGeneratedImpl<
    T, K, const SELECTOR: felt252, const TABLE_SELECTOR: felt252, +Serde<K>, +SchemaGenerate<T>
> of Schema<T> {
    type Keys = K;
    fn table_selector() -> felt252 {
        TABLE_SELECTOR
    }
    fn selector() -> felt252 {
        SELECTOR
    }
    fn schema_data() -> SchemaData {
        SchemaData { selector: Self::selector(), write: Self::write_field_layouts(), }
    }
    fn set_selectors() -> Span<felt252> {
        SchemaGenerate::<T>::_set_selectors()
    }
    fn write_field_layouts() -> Span<FieldLayout> {
        SchemaGenerate::<T>::_write_field_layouts()
    }
    fn keys(self: @T) -> @K {
        self._keys()
    }
    fn keys_serialized(self: @T) -> Span<felt252> {
        serialize_inline(Self::keys(self))
    }
    fn serialize_keys(self: @T, ref output: Array<felt252>) {
        Serde::<K>::serialize(Self::keys(self), ref output)
    }
    fn set_serialized(self: @T) -> Span<felt252> {
        let mut output = ArrayTrait::<felt252>::new();
        self._serialize_set(ref output);
        output.span()
    }
    fn serialize_set(self: @T, ref output: Array<felt252>) {
        self._serialize_set(ref output)
    }
    fn write_serialized(self: @T) -> Span<felt252> {
        let mut output = ArrayTrait::<felt252>::new();
        self._serialize_write(ref output);
        output.span()
    }
    fn serialize_write(self: @T, ref output: Array<felt252>) {
        self._serialize_write(ref output)
    }
    fn from_keys_and_serialized(keys: K, write: Span<felt252>, set: Span<felt252>) -> T {
        SchemaGenerate::_from_keys_and_serialized(keys, write, set)
    }
    fn set_write(self: @T) -> SetWrite {
        SetWrite { set: Self::set_serialized(self), write: Self::write_serialized(self) }
    }
    fn parse_keys<K, +Serde<K>, +Drop<K>>(key: K) -> Self::Keys {
        SchemaGenerate::<T>::_parse_keys(key)
    }
}

impl KeySchemaTupleSchemaImpl<
    K, T, +Serde<K>, +Drop<K>, +Schema<T>, +SchemaSanId<T>
> of Schema<(K, T)> {
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
    fn keys_serialized(self: @(K, T)) -> Span<felt252> {
        let (k, _) = self;
        serialize_inline(k)
    }
    fn serialize_keys(self: @(K, T), ref output: Array<felt252>) {
        let (k, _) = self;
        Serde::<K>::serialize(k, ref output)
    }
    fn set_serialized(self: @(K, T)) -> Span<felt252> {
        let (_, t) = self;
        Schema::<T>::set_serialized(t)
    }
    fn serialize_set(self: @(K, T), ref output: Array<felt252>) {
        let (_, t) = self;
        Schema::<T>::serialize_set(t, ref output);
    }
    fn write_serialized(self: @(K, T)) -> Span<felt252> {
        let (_, t) = self;
        Schema::<T>::write_serialized(t)
    }
    fn serialize_write(self: @(K, T), ref output: Array<felt252>) {
        let (_, t) = self;
        Schema::<T>::serialize_write(t, ref output);
    }
    fn from_keys_and_serialized(keys: K, write: Span<felt252>, set: Span<felt252>) -> (K, T) {
        (keys, SchemaSanId::<T>::from_serialized(write, set))
    }
    fn set_write(self: @(K, T)) -> SetWrite {
        let (_, t) = self;
        Schema::<T>::set_write(t)
    }
    fn parse_keys<K, +Serde<K>, +Drop<K>>(key: K) -> Self::Keys {
        panic!("Not implemented")
    }
}


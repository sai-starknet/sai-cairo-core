use sai::{meta::{Layout, Introspect},};

#[derive(Drop, Copy)]
pub struct DatabaseTable<D> {
    pub database: D,
    pub selector: felt252,
}

pub trait Table<T> {
    const SELECTOR: felt252;
    fn selector(self: @T) -> felt252;
    fn schema(self: @T) -> Layout;
    fn database<D>(self: @T, database: D) -> DatabaseTable<D>;
}

pub impl TableImpl<T, const selector: felt252, +Introspect<T>> of Table<T> {
    const SELECTOR: felt252 = selector;
    fn selector(self: @T) -> felt252 {
        Self::SELECTOR
    }
    fn schema(self: @T) -> Layout {
        Introspect::<T>::layout()
    }
    fn database<D>(self: @T, database: D) -> DatabaseTable<D> {
        DatabaseTable { database, selector: Self::SELECTOR, }
    }
}


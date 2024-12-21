use starknet::ContractAddress;
use sai::{
    contract::Contract,
    store::{
        IStoreSet, IStoreSetDispatcher, IStoreSetDispatcherTrait, IStoreWrite,
        IStoreWriteDispatcher, IStoreWriteDispatcherTrait, IStoreSetWrite, IStoreSetWriteDispatcher,
        IStoreSetWriteDispatcherTrait, IStoreRead, IStoreReadDispatcher, IStoreReadDispatcherTrait,
        IdWrite, IdSet, IdSetWrite, SchemaData
    },
    meta::FieldLayout
};

pub impl IContractStoreSet of IStoreSet<Contract> {
    fn store_set_entity(
        ref self: Contract,
        table: felt252,
        schema_selector: felt252,
        id: felt252,
        values: Span<felt252>
    ) {
        IStoreSetDispatcher { contract_address: self.into() }
            .store_set_entity(table, schema_selector, id, values)
    }
    fn store_set_entities(
        ref self: Contract, table: felt252, schema_selector: felt252, entities: Array<IdSet>
    ) {
        IStoreSetDispatcher { contract_address: self.into() }
            .store_set_entities(table, schema_selector, entities)
    }
}

pub impl IContractStoreWrite of IStoreWrite<Contract> {
    fn store_write_entity(
        ref self: Contract, table: felt252, schema: SchemaData, id: felt252, values: Span<felt252>
    ) {
        IStoreWriteDispatcher { contract_address: self.into() }
            .store_write_entity(table, schema, id, values)
    }
    fn store_write_entities(
        ref self: Contract, table: felt252, schema: SchemaData, entities: Array<IdWrite>
    ) {
        IStoreWriteDispatcher { contract_address: self.into() }
            .store_write_entities(table, schema, entities)
    }
}

pub impl IContractStoreSetWrite of IStoreSetWrite<Contract> {
    fn store_set_write_entity(
        ref self: Contract,
        table: felt252,
        schema: SchemaData,
        id: felt252,
        set: Span<felt252>,
        write: Span<felt252>
    ) {
        IStoreSetWriteDispatcher { contract_address: self.into() }
            .store_set_write_entity(table, schema, id, set, write)
    }
    fn store_set_write_entities(
        ref self: Contract, table: felt252, schema: SchemaData, entities: Array<IdSetWrite>
    ) {
        IStoreSetWriteDispatcher { contract_address: self.into() }
            .store_set_write_entities(table, schema, entities)
    }
}

pub impl IContractStoreRead of IStoreRead<Contract> {
    fn store_read_entity(
        self: @Contract, table: felt252, fields: Span<FieldLayout>, id: felt252
    ) -> Span<felt252> {
        IStoreReadDispatcher { contract_address: (*self).into() }
            .store_read_entity(table, fields, id)
    }
    fn store_read_entities(
        self: @Contract, table: felt252, fields: Span<FieldLayout>, ids: Span<felt252>
    ) -> Array<Span<felt252>> {
        IStoreReadDispatcher { contract_address: (*self).into() }
            .store_read_entities(table, fields, ids)
    }
}

pub impl IContractAddressStoreSet of IStoreSet<ContractAddress> {
    fn store_set_entity(
        ref self: ContractAddress,
        table: felt252,
        schema_selector: felt252,
        id: felt252,
        values: Span<felt252>
    ) {
        IStoreSetDispatcher { contract_address: self }
            .store_set_entity(table, schema_selector, id, values)
    }
    fn store_set_entities(
        ref self: ContractAddress, table: felt252, schema_selector: felt252, entities: Array<IdSet>
    ) {
        IStoreSetDispatcher { contract_address: self }
            .store_set_entities(table, schema_selector, entities)
    }
}

pub impl IContractAddressStoreWrite of IStoreWrite<ContractAddress> {
    fn store_write_entity(
        ref self: ContractAddress,
        table: felt252,
        schema: SchemaData,
        id: felt252,
        values: Span<felt252>
    ) {
        IStoreWriteDispatcher { contract_address: self }
            .store_write_entity(table, schema, id, values)
    }
    fn store_write_entities(
        ref self: ContractAddress, table: felt252, schema: SchemaData, entities: Array<IdWrite>
    ) {
        IStoreWriteDispatcher { contract_address: self }
            .store_write_entities(table, schema, entities)
    }
}

pub impl IContractAddressStoreSetWrite of IStoreSetWrite<ContractAddress> {
    fn store_set_write_entity(
        ref self: ContractAddress,
        table: felt252,
        schema: SchemaData,
        id: felt252,
        set: Span<felt252>,
        write: Span<felt252>
    ) {
        IStoreSetWriteDispatcher { contract_address: self }
            .store_set_write_entity(table, schema, id, set, write)
    }
    fn store_set_write_entities(
        ref self: ContractAddress, table: felt252, schema: SchemaData, entities: Array<IdSetWrite>
    ) {
        IStoreSetWriteDispatcher { contract_address: self }
            .store_set_write_entities(table, schema, entities)
    }
}

pub impl IContractAddressStoreRead of IStoreRead<ContractAddress> {
    fn store_read_entity(
        self: @ContractAddress, table: felt252, fields: Span<FieldLayout>, id: felt252
    ) -> Span<felt252> {
        IStoreReadDispatcher { contract_address: *self }.store_read_entity(table, fields, id)
    }
    fn store_read_entities(
        self: @ContractAddress, table: felt252, fields: Span<FieldLayout>, ids: Span<felt252>
    ) -> Array<Span<felt252>> {
        IStoreReadDispatcher { contract_address: *self }.store_read_entities(table, fields, ids)
    }
}

use starknet::ContractAddress;
use sai::{
    meta::Schema, database::{IDatabaseDispatcher, IDatabaseDispatcherTrait, IDatabase},
    contract::{Contract,},
};

pub impl IDatabaseContractImpl of IDatabase<Contract> {
    fn read_entity(self: @Contract, table: felt252, id: felt252, schema: Schema) -> Array<felt252> {
        IDatabaseDispatcher { contract_address: (*self).into() }.read_entity(table, id, schema)
    }

    fn read_entities(
        self: @Contract, table: felt252, ids: Span<felt252>, schema: Schema
    ) -> Array<Array<felt252>> {
        IDatabaseDispatcher { contract_address: (*self).into() }.read_entities(table, ids, schema)
    }

    fn write_entity(
        ref self: Contract, table: felt252, id: felt252, schema: Schema, values: Span<felt252>
    ) {
        IDatabaseDispatcher { contract_address: self.into() }
            .write_entity(table, id, schema, values)
    }

    fn write_entities(
        ref self: Contract,
        table: felt252,
        ids: Span<felt252>,
        schema: Schema,
        values: Array<Span<felt252>>,
    ) {
        IDatabaseDispatcher { contract_address: self.into() }
            .write_entities(table, ids, schema, values)
    }
}

pub impl IDatabaseContractAddressImpl of IDatabase<ContractAddress> {
    fn read_entity(
        self: @ContractAddress, table: felt252, id: felt252, schema: Schema
    ) -> Array<felt252> {
        IDatabaseDispatcher { contract_address: *self }.read_entity(table, id, schema)
    }

    fn read_entities(
        self: @ContractAddress, table: felt252, ids: Span<felt252>, schema: Schema
    ) -> Array<Array<felt252>> {
        IDatabaseDispatcher { contract_address: *self }.read_entities(table, ids, schema)
    }

    fn write_entity(
        ref self: ContractAddress,
        table: felt252,
        id: felt252,
        schema: Schema,
        values: Span<felt252>
    ) {
        IDatabaseDispatcher { contract_address: self }.write_entity(table, id, schema, values)
    }

    fn write_entities(
        ref self: ContractAddress,
        table: felt252,
        ids: Span<felt252>,
        schema: Schema,
        values: Array<Span<felt252>>,
    ) {
        IDatabaseDispatcher { contract_address: self }.write_entities(table, ids, schema, values)
    }
}


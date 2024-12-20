use starknet::ContractAddress;
use sai::{
    meta::Schema, database::{IDatabaseDispatcher, IDatabaseDispatcherTrait, IDatabase, Entity},
    contract::{Contract,},
};

pub impl IDatabaseContractImpl of IDatabase<Contract> {
    fn read_entity(self: @Contract, table: felt252, schema: Schema, id: felt252) -> Span<felt252> {
        IDatabaseDispatcher { contract_address: (*self).into() }.read_entity(table, schema, id)
    }

    fn read_entities(
        self: @Contract, table: felt252, schema: Schema, ids: Span<felt252>
    ) -> Array<Span<felt252>> {
        IDatabaseDispatcher { contract_address: (*self).into() }.read_entities(table, schema, ids)
    }

    fn write_entity(
        ref self: Contract, table: felt252, schema: Schema, id: felt252, values: Span<felt252>
    ) {
        IDatabaseDispatcher { contract_address: self.into() }
            .write_entity(table, schema, id, values)
    }

    fn write_entities(ref self: Contract, table: felt252, schema: Schema, entities: Array<Entity>) {
        IDatabaseDispatcher { contract_address: self.into() }
            .write_entities(table, schema, entities)
    }
}

pub impl IDatabaseContractAddressImpl of IDatabase<ContractAddress> {
    fn read_entity(
        self: @ContractAddress, table: felt252, schema: Schema, id: felt252
    ) -> Span<felt252> {
        IDatabaseDispatcher { contract_address: *self }.read_entity(table, schema, id)
    }

    fn read_entities(
        self: @ContractAddress, table: felt252, schema: Schema, ids: Span<felt252>
    ) -> Array<Span<felt252>> {
        IDatabaseDispatcher { contract_address: *self }.read_entities(table, schema, ids)
    }

    fn write_entity(
        ref self: ContractAddress,
        table: felt252,
        schema: Schema,
        id: felt252,
        values: Span<felt252>
    ) {
        IDatabaseDispatcher { contract_address: self }.write_entity(table, schema, id, values)
    }

    fn write_entities(
        ref self: ContractAddress, table: felt252, schema: Schema, entities: Array<Entity>
    ) {
        IDatabaseDispatcher { contract_address: self }.write_entities(table, schema, entities)
    }
}


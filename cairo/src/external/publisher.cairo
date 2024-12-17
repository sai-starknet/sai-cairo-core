use starknet::ContractAddress;
use sai::{
    meta::Schema, publisher::{IPublisher, IPublisherDispatcher, IPublisherDispatcherTrait},
    contract::Contract,
};

pub impl IPublisherContractImpl of IPublisher<Contract> {
    fn set_entity(
        ref self: Contract, table: felt252, id: felt252, schema: Schema, values: Span<felt252>
    ) {
        IPublisherDispatcher { contract_address: self.into() }.set_entity(table, id, schema, values)
    }

    fn set_entities(
        ref self: Contract,
        table: felt252,
        ids: Span<felt252>,
        schema: Schema,
        values: Array<Span<felt252>>,
    ) {
        IPublisherDispatcher { contract_address: self.into() }
            .set_entities(table, ids, schema, values)
    }
}


impl IPublisherContractAddressImpl of IPublisher<ContractAddress> {
    fn set_entity(
        ref self: ContractAddress,
        table: felt252,
        id: felt252,
        schema: Schema,
        values: Span<felt252>
    ) {
        IPublisherDispatcher { contract_address: self }.set_entity(table, id, schema, values)
    }

    fn set_entities(
        ref self: ContractAddress,
        table: felt252,
        ids: Span<felt252>,
        schema: Schema,
        values: Array<Span<felt252>>,
    ) {
        IPublisherDispatcher { contract_address: self }.set_entities(table, ids, schema, values)
    }
}

use starknet::ContractAddress;


pub impl ContractAddressIntoContract of Into<ContractAddress, Contract> {
    fn into(self: ContractAddress) -> Contract {
        Contract { contract_address: self }
    }
}


pub impl ContractIntoContractAddress of Into<Contract, ContractAddress> {
    fn into(self: Contract) -> ContractAddress {
        self.contract_address
    }
}


#[derive(Drop, Copy)]
pub struct Contract {
    contract_address: ContractAddress,
}


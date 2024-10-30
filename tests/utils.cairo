// use starknet::ContractAddress;
// use snforge_std::{declare, cheatcodes::contract_class::{ContractClassTrait, DeclareResultTrait}};

// pub fn deploy_contract(initial_value: u32) -> ContractAddress {
//     // Declare the contract and unpack the result to get ContractClass
//     let declare_result = declare("counter_contract").unwrap();
//     let contract = declare_result.contract_class(); // Extract ContractClass

//     let constructor_args = array![initial_value.into()];
//     let (contract_address, _) = contract.deploy(@constructor_args).unwrap(); // Deploy contract

//     contract_address
// }

use core::result::ResultTrait;
use starknet::{ContractAddress};
use snforge_std::{declare, cheatcodes::contract_class::{ContractClassTrait, DeclareResultTrait}};

pub fn deploy_contract(kill_switch: bool) -> ContractAddress {
    let declare_result = declare("KillSwitch").unwrap();
    let declared_result = declare_result.contract_class();
    let constructor_args = array![kill_switch.into()];
    let (contract_address, _) = declared_result.deploy(@constructor_args).unwrap();
    contract_address
}

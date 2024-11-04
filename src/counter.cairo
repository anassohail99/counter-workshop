#[starknet::interface]
trait ICounter<TContractState> {
    fn get_counter(self: @TContractState) -> u32;
    fn increase_counter(ref self: TContractState);
}


#[starknet::contract]
mod counter_contract {
    use core::starknet::{ContractAddress};

    #[storage]
    struct Storage {
        counter: u32,
        kill_switch: ContractAddress,
    }


    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        CounterIncreased: CounterIncreased,
    }

    #[derive(Drop, starknet::Event)]
    struct CounterIncreased {
        value: u32,
    }


    #[constructor]
    fn constructor(
        ref self: ContractState, initial_value: u32, killSwitchAddress: ContractAddress
    ) {
        self.counter.write(initial_value);
        self.kill_switch.write(killSwitchAddress);
    }

    #[abi(embed_v0)]
    impl ContractCounter of super::ICounter<ContractState> {
        fn get_counter(self: @ContractState) -> u32 {
            self.counter.read()
        }

        fn increase_counter(ref self: ContractState) {
            let count: u32 = self.counter.read();
            self.counter.write(count + 1);
            self.emit(CounterIncreased { value: count + 1 });
        }
    }
}

#[starknet::interface]
trait ICounter<TContractState> {
    fn get_counter(self: @TContractState) -> u32;
    fn increase_counter(ref self: TContractState);
}


#[starknet::contract]
pub mod counter_contract {
    #[storage]
    struct Storage {
        counter: u32
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
    fn constructor(ref self: ContractState, initial_value: u32) {
        self.counter.write(initial_value);
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

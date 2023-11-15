program my_token.aleo {
	mapping account: address => u64;

	record MyToken {
		owner: address;
		amount: u64;
	}

	transition mint_public(public amount: u64)  {
		return then finalize(self.caller, amount);
	}
	finalize mint_public(owner: address, amount: u64) {
		let balance: u64 = Mapping::get_or_use(account, owner, 0u64);
		Mapping::set(account, owner, balance + amount);
	}

	transition transfer_public(public receiver: address, public amount: u64) {
		return then finalize(self.caller, receiver, amount);
	}
	finalize transfer_public(owner: address, receiver: address, amount: u64) {
		let owner_balance: u64 = Mapping::get(account, owner);
		let receiver_balance: u64 = Mapping::get_or_use(account, receiver, 0u64);

		Mapping::set(account, owner, owner_balance - amount);
		Mapping::set(account, receiver, receiver_balance + amount);
	}

	transition transfer_private(token: MyToken, receiver: address, amount: u64) -> (MyToken, MyToken) {
		let change: MyToken = MyToken {
			owner: token.owner,
			amount: token.amount - amount,
		};

		let received: MyToken = MyToken {
			owner: receiver,
			amount: token.amount + amount,
		};

		return (change, received);
	}

	transition transfer_private_to_public(token: MyToken, receiver: address, amount: u64) -> MyToken {
        let change: MyToken = MyToken {
            owner: token.owner,
            amount: token.amount - amount,
		};

        return change then finalize(receiver, amount);
	}
    finalize transfer_private_to_public(receiver: address, amount: u64) {
        let balance: u64 = Mapping::get_or_use(account, receiver, 0u64);
        Mapping::set(account, receiver, balance + amount);
    }

    transition transfer_public_to_private(receiver: address, amount: u64) -> MyToken {
        let token: MyToken = MyToken {
            owner: receiver,
            amount,
        };

        return token then finalize(self.caller, amount);
    }
    finalize transfer_public_to_private(owner: address, amount: u64) {
        let balance: u64 = Mapping::get_or_use(account, owner, 0u64);
        Mapping::set(account, owner, balance + amount);
    }
}

program my_token.aleo;

record MyToken:
    owner as address.private;
    amount as u64.private;


mapping account:
	key as address.public;
	value as u64.public;

function mint_public:
    input r0 as u64.public;
    async mint_public self.caller r0 into r1;
    output r1 as my_token.aleo/mint_public.future;

finalize mint_public:
    input r0 as address.public;
    input r1 as u64.public;
    get.or_use account[r0] 0u64 into r2;
    add r2 r1 into r3;
    set r3 into account[r0];


function transfer_public:
    input r0 as address.public;
    input r1 as u64.public;
    async transfer_public self.caller r0 r1 into r2;
    output r2 as my_token.aleo/transfer_public.future;

finalize transfer_public:
    input r0 as address.public;
    input r1 as address.public;
    input r2 as u64.public;
    get account[r0] into r3;
    get.or_use account[r1] 0u64 into r4;
    sub r3 r2 into r5;
    set r5 into account[r0];
    add r4 r2 into r6;
    set r6 into account[r1];


function transfer_private:
    input r0 as MyToken.record;
    input r1 as address.private;
    input r2 as u64.private;
    sub r0.amount r2 into r3;
    cast r0.owner r3 into r4 as MyToken.record;
    add r0.amount r2 into r5;
    cast r1 r5 into r6 as MyToken.record;
    output r4 as MyToken.record;
    output r6 as MyToken.record;


function transfer_private_to_public:
    input r0 as MyToken.record;
    input r1 as address.private;
    input r2 as u64.private;
    sub r0.amount r2 into r3;
    cast r0.owner r3 into r4 as MyToken.record;
    async transfer_private_to_public r1 r2 into r5;
    output r4 as MyToken.record;
    output r5 as my_token.aleo/transfer_private_to_public.future;

finalize transfer_private_to_public:
    input r0 as address.public;
    input r1 as u64.public;
    get.or_use account[r0] 0u64 into r2;
    add r2 r1 into r3;
    set r3 into account[r0];


function transfer_public_to_private:
    input r0 as address.private;
    input r1 as u64.private;
    cast r0 r1 into r2 as MyToken.record;
    async transfer_public_to_private self.caller r1 into r3;
    output r2 as MyToken.record;
    output r3 as my_token.aleo/transfer_public_to_private.future;

finalize transfer_public_to_private:
    input r0 as address.public;
    input r1 as u64.public;
    get.or_use account[r0] 0u64 into r2;
    add r2 r1 into r3;
    set r3 into account[r0];

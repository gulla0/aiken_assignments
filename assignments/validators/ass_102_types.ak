use cardano/script_context.{Minting, ScriptContext}
// use cardano/transaction.{OutputReference, Transaction, find_input, placeholder}
use cardano/transaction.{OutputReference, Transaction, placeholder}
use mocktail.{mock_utxo_ref}

pub type Rando1 {
    name: ByteArray,
    lucky_number: Int,
}

pub type Rando2 {
    alias: ByteArray,
    secret: ByteArray,
}
validator type_check_succeed {
  spend(
    datum: Option<Rando1>,
    redeemer: Rando2,
    _input: OutputReference,
    _tx: Transaction,
  ) {
    let x = when (datum, redeemer) is {
    (Some(Rando1{..}), Rando2{..}) -> True
    _ -> False
    }

    x?
  }

  else(_) {
    fail
  }
}

test m102_test_type_check_success() {
  trace @"validate for matching types of datum and redeemer"
  let datum_test = Some(Rando1{name: "Harsha", lucky_number: 10})
  let redeemer_test = Rando2{alias: "Harsha", secret: "1234567890"}

  type_check_succeed.spend(datum_test, redeemer_test, mock_utxo_ref(0, 0), placeholder)
}


// Without fail assertion this will fail!
// test m102_fail_test_always_succeed_spending_validator() {
test m102_fail_test_minting_endpoint() fail {
  let context =
    ScriptContext {
      transaction: placeholder,
      redeemer: Rando2{alias: "test", secret: "1"},
      info: Minting(#""),
    }
  !type_check_succeed.else(context)
}


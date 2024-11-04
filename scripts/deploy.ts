import {
  Account,
  CallData,
  Contract,
  RpcProvider,
  stark,
  shortString,
} from "starknet";
import * as dotenv from "dotenv";
import { getCompiledCode } from "./utils";

dotenv.config();

async function main() {
  const provider = new RpcProvider({
    nodeUrl: "https://cloud.argent-api.com/v1/starknet/sepolia/rpc/v0.7",
  });

  // initialize existing predeployed account 0
  console.log("ACCOUNT_ADDRESS=", process.env.DEPLOYER_ADDRESS);
  // console.log("ACCOUNT_PRIVATE_KEY=", process.env.DEPLOYER_PRIVATE_KEY);
  const privateKey0 = process.env.DEPLOYER_PRIVATE_KEY ?? "";
  const accountAddress0: string = process.env.DEPLOYER_ADDRESS ?? "";

  // console.log(
  //   "chain Id =",
  //   shortString.decodeShortString(await provider.getChainId()),
  //   ", rpc",
  //   await provider.getSpecVersion()
  // );
  console.log("Provider connected to Starknet");

  const account0 = new Account(
    provider,
    "0x015Ce4C1Abe257B9289B842E24AdEdf0AE6D185D431A7C4Ae4Be390931D07780",
    "0x05cacb1b7ff1d9cc521dbd6e45eeacd8b22bdfec0d15f4c46cc1ef51a62e0efb"
  );

  // Declare & deploy contract
  let sierraCode, casmCode;

  try {
    ({ sierraCode, casmCode } = await getCompiledCode(
      "workshop_counter_contract"
    ));
  } catch (error: any) {
    console.log("Failed to read contract files");
    process.exit(1);
  }
  const myCallData = new CallData(sierraCode.abi);
  const constructor = myCallData.compile("constructor", {
    initial_value: 100,
    killSwitchAddress:
      "0x05f7151ea24624e12dde7e1307f9048073196644aa54d74a9c579a257214b542",
    // ,    initial_owner: process.env.DEPLOYER_ADDRESS ?? "",
  });

  console.log("Nonce", account0);

  const deployResponse = await account0.declareAndDeploy({
    contract: sierraCode,
    casm: casmCode,
    constructorCalldata: constructor,
    salt: stark.randomAddress(),
  });
  console.log("Reached Here");
  // Connect the new contract instance :
  const myTestContract = new Contract(
    sierraCode.abi,
    deployResponse.deploy.contract_address,
    provider
  );
  console.log(
    `✅ Contract has been deploy with the address: ${myTestContract.address}`
  );
}
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

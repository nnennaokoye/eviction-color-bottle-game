import { ethers } from "hardhat";

async function main() {
  console.log("Deploying BottleGame contract...");

  const BottleGame = await ethers.getContractFactory("BottleGame");
  
  const bottleGame = await BottleGame.deploy();

  await bottleGame.waitForDeployment();

  const address = await bottleGame.getAddress();
  
  console.log("BottleGame deployed to:", address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
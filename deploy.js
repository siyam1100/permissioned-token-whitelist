const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  
  const token = await hre.ethers.deployContract("CompliantToken", [
    "SecurityAsset", 
    "SEC", 
    5000000
  ]);

  await token.waitForDeployment();
  console.log("Compliant Token deployed to:", await token.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

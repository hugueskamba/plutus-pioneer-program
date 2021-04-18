# Lecture 1 Notes

EUTxO Model: Extended Unspent Transaction Output Model, the accounting model that Cardano uses. Ethereum uses account based model which is similar to banks.

A transaction consumes UTxOs and produce new ones.

A transaction has an arbritrary number of inputs and outputs. Complete UTxO has to be used as input and a difference is sent back from one of the outputs.
The sum of input values must be equal to the sum of the output values (minus the Tx fees). If the transaction creates new tokens the total output value will be higher. If it burns tokens then total output value will be smaller.

A signature (public key) is added to the UTxO to authenticate it.

The EUTxO replaces the signature (public key addresses) by an arbritary script containing a logic (aka the Redeemer) for athentication.

In the case of Bitcoin, all the script sees is the redeemer to decide whether it is ok for the Tx to consume the UTxO. In Ethereum the Solidity scripts can see the whole state of the blockchain and open can therefore be unpredictable and unsecure.
Cardano takes a middle approach, the script can see the whole transaction that is being validated (reedeemer, inputs and outputs). A Plutus script makes use of that information to decide whether it is ok to consume the output. A datum is a piece of arbitrary data that can be associated with a UTxO in a addition to the value.

It is possible to check if a Tx will validate in a wallet before sending it to the network. Failed Tx in the network do not incur any fee loss. Ethereum is unpredictable and failed Tx incur gas fees.

EUTxO are passive and do not move unless there is a transaction.

Plutus scripts are therefore more secure because they do not consider the whole state of the blockchain (which is unknowable) but rather on the context of the transaction.

Usage of EUTxO is not tied to using Plutus as more languages will be supported in the future.

```
1. Get WSL2 on Windows
2. Get a normal distro (Ubuntu or Debian work fine)

    // Plutus container running in docker

1. In your wsl shell, in your linux ~/src (for example) do:

    git clone https://github.com/input-output-hk/plutus

2. Read the README file it will tell you how to get Nix
3. Install Nix

    curl -L https://nixos.org/nix/install | sh

4. Configure nix by adding the file /etc/nix/nix.conf (relaunch your shell)

    sandbox = false
    use-sqlite-wal = false
    substituters        = https://hydra.iohk.io https://iohk.cachix.org https://cache.nixos.org/
    trusted-public-keys = hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ= iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=

5. Build Plutus with the Nix command line in the README file

   nix build -f default.nix plutus.haskell.packages.plutus-core.components.library

6. Install Docker for Windows (relaunch your shell)
7. Launch Docker and make sure it is WSL2 enabled (in the settings)
8. Launch the Docker container from WSL using the README command line

    docker load < $(nix-build default.nix -A devcontainer)

    // VSCode

References:
https://code.visualstudio.com/docs/remote/wsl#_advanced-opening-a-wsl-2-folder-in-a-container

1. Get VSCode for Windows
2. Get the Remote - Containers extension
3. Go back into WSL into your source directory (~/src , maybe)
4. git clone https://github.com/input-output-hk/plutus-starter
5. cd plutus-starter
6. code .       // <-- this will install VSCode Server on your linux, wait for it
                // somehow I had to shutdown my vpn for that to download, should
                // not take long at all. :)
7. VSCode will launch in Windows and ask to reopen in the Dev Container: yes.
8. Open the CLI you will get a nifty [nix]: CLI
9. 'cabal update' then 'cabal build' and watch it build the Haskell
```


Since 
`nix-build default.nix -A devcontainer`
 is broken on Mac (https://github.com/NixOS/nixpkgs/issues/110665) 
attribute 'moby' missing, at /nix/store/blablabla


Here is a hacky way to build it
```
localhost $ cd ~/src/plutus
localhost $ docker run --rm -it -v ${PWD}:/opt/plutus lnl7/nix bash
docker $ cd /opt/plutus
docker $ vi /etc/nix/nix.conf
#  Add
# substituters        = https://hydra.iohk.io https://iohk.cachix.org https://cache.nixos.org/
# trusted-public-keys = hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ= iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=
docker $ nix-build default.nix -A devcontainer
…
…
Cooking the image...
Finished.
/nix/store/zwm4w25lchfclsgxlwl306yfhlw9h8k7-docker-image-plutus-devcontainer.tar.gz
docker $ cp /nix/store/zwm4w25lchfclsgxlwl306yfhlw9h8k7-docker-image-plutus-devcontainer.tar.gz .
docker $ exit # or EOF or howewher you exit your shell.
localhost $ docker load < zwm4w25lchfclsgxlwl306yfhlw9h8k7-docker-image-plutus-devcontainer.tar.gz
localhost $ rm zwm4w25lchfclsgxlwl306yfhlw9h8k7-docker-image-plutus-devcontainer.tar.gz
```


## How to start the playground server

1. Ensure the smart contract was built for the correct version of Plutus. Check that the `tag` attribute in the smart contract project `cabal.project` matches the checked out SHA of the local `plutus` repository.
1. Start a `nix-shell` from the `plutus` repository.
1. On the `nix-shell` go to `plutus/plutus-playground-client/` and run `plutus-playground-server` to start the server.
1. The server should be running on `http:://localhost:8080`.

## How to start the playground client

1. Ensure the smart contract was built for the correct version of Plutus. Check that the `tag` attribute in the smart contract project `cabal.project` matches the checked out SHA of the local `plutus` repository.
1. Start a `nix-shell` from the `plutus` repository.
1. On the `nix-shell` go to `plutus/plutus-playground-client/` and run `npm run start` to start the client.
1. The server should be running on `http:://localhost:8009`.


Help: https://www.youtube.com/watch?v=Cdu0gzCiYbY&ab_channel=LeetDev

```
1. clone Plutus git
2. git checkout the correct revision
3. install nix and set up the IOHK cache
4. nix-shell in /plutus => Everything else will be set up for you.
5. don't change the git revision and clone plutus-pioneer in /plutus
Those steps will give you the best foundation for the course.
```
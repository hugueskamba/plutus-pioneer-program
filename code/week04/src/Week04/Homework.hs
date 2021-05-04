{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE DeriveAnyClass    #-}
{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeApplications  #-}
{-# LANGUAGE TypeOperators     #-}

module Week04.Homework where

import Data.Aeson                 (FromJSON, ToJSON)
import Data.Functor               (void)
import Data.Text                  (Text, unpack)
import GHC.Generics               (Generic)
import Ledger
import Ledger.Ada                 as Ada
import Ledger.Constraints         as Constraints
import Plutus.Contract            as Contract
import Plutus.Trace.Emulator      as Emulator
import Wallet.Emulator.Wallet

data PayParams = PayParams
    { ppRecipient :: PubKeyHash
    , ppAmount  :: Integer
    } deriving (Show, Generic, FromJSON, ToJSON)

type PaySchema = BlockchainActions .\/ Endpoint "pay" PayParams

errorPayContract :: Contract () PaySchema Text ()
errorPayContract = do
    pp <- endpoint @"pay"
    let tx = mustPayToPubKey (ppRecipient pp) $ lovelaceValueOf $ ppAmount pp
    void $ submitTx tx

payContract :: Contract () PaySchema Void ()
payContract = do
    Contract.handleError
        (\err -> Contract.logError $ "Caught error: " ++ unpack err)
        errorPayContract
    payContract

-- A trace that invokes the pay endpoint of payContract on Wallet 1 twice,
-- each time with Wallet 2 as recipient, but with amounts given by the two
-- arguments. There should be a delay of one slot after each endpoint call.
payTrace :: Integer -> Integer -> EmulatorTrace ()
payTrace x y = do
    w1 <- activateContractWallet (Wallet 1) endpoints
    callEndpoint @"pay" w1 $ PayParams {
            ppRecipient = w2PubKeyHash,
            ppAmount = x
        }
    void $ Emulator.waitNSlots 1
    callEndpoint @"pay" w1 $ PayParams {
            ppRecipient = w2PubKeyHash,
            ppAmount = y
        }
    void $ Emulator.waitNSlots 1
    where w2PubKeyHash = pubKeyHash $ walletPubKey $ Wallet 2



payTest1 :: IO ()
payTest1 = runEmulatorTraceIO $ payTrace 1000000 2000000

payTest2 :: IO ()
payTest2 = runEmulatorTraceIO $ payTrace 1000000000 2000000

Here are the command lines to test your agent registry contract in clarinet console:

## 1. Start the console
```bash
clarinet console
```

## 2. Basic setup and read-only function tests
```clarity
;; Check the registry configuration
(contract-call? .agent-account-registry get-registry-config)

;; Check if specific addresses are attestors
(contract-call? .agent-account-registry is-attestor 'SPV9K21TBFAK4KNRJXF5DFP8N7W46G4V9RCJDC22)
(contract-call? .agent-account-registry is-attestor 'SP2GHGQRWSTM89SQMZXTQJ0GRHV93MSX9J84J7BEA)
(contract-call? .agent-account-registry is-attestor 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
```

## 3. Test auto-registration (as deployer)
```clarity
;; Auto-register an agent account (should work since you're the deployer)
(contract-call? .agent-account-registry auto-register-agent-account 
  'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM  ;; owner
  'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG)  ;; agent

;; Check if registration worked
(contract-call? .agent-account-registry get-agent-account-by-owner 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
(contract-call? .agent-account-registry get-agent-account-by-agent 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG)
```

## 4. Test registration with different sender (should fail)
```clarity
;; Try to register as someone else (should fail)
(as-contract (contract-call? .agent-account-registry auto-register-agent-account 
  'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG
  'ST2NEB84ASENDXKYGJPQW86YXQCEFEX2ZQPG87ND))
```

## 5. Test account info retrieval
```clarity
;; Get account info (replace with actual registered account address)
(contract-call? .agent-account-registry get-agent-account-info tx-sender)
(contract-call? .agent-account-registry get-attestation-level tx-sender)
(contract-call? .agent-account-registry is-account-attested tx-sender u1)
```

## 6. Test attestation functions
```clarity
;; Try to attest an account as attestor 1
(as-contract (contract-call? .agent-account-registry attest-agent-account tx-sender))

;; Check attestation status
(contract-call? .agent-account-registry has-attestor-signed 
  tx-sender 
  'SPV9K21TBFAK4KNRJXF5DFP8N7W46G4V9RCJDC22)

;; Get all attestors for an account
(contract-call? .agent-account-registry get-account-attestors tx-sender)
```

## 7. Test error conditions
```clarity
;; Try to register duplicate account (should fail)
(contract-call? .agent-account-registry auto-register-agent-account 
  'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM
  'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG)

;; Try to attest non-existent account (should fail)
(contract-call? .agent-account-registry attest-agent-account 'ST2NEB84ASENDXKYGJPQW86YXQCEFEX2ZQPG87ND)

;; Try to attest as non-attestor (should fail)
(as-contract (contract-call? .agent-account-registry attest-agent-account tx-sender))
```

## 8. Check current state
```clarity
;; Check current tx-sender (your address)
tx-sender

;; Check contract address
contract-caller

;; List all current data (this won't work directly, but you can check individual accounts)
```

## 9. Advanced testing with different addresses
```clarity
;; Simulate calls from attestor addresses
(begin 
  (print "Testing as attestor 1")
  (contract-call? .agent-account-registry attest-agent-account tx-sender))

;; Check final attestation level
(contract-call? .agent-account-registry get-attestation-level tx-sender)
```

## Tips for testing:
- Replace addresses with actual ones you want to test
- Use `::get_contracts` to see available contracts
- Use `::describe .agent-account-registry` to see all functions
- Each successful registration should increment attestation levels
- Watch for error codes (u801, u802, etc.) to debug issues

Start with the basic read-only functions first, then move to registration and attestation tests!
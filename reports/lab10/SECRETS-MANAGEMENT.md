# Lab 10 — Secrets Management

## 1. Decentralized secrets provisioning

The application supports decentralized secret provisioning through environment variables and a local `.env` file.

Implementation:
- `internal/config/config.go` uses Viper.
- `viper.AutomaticEnv()` enables environment variable loading.
- `.env` is loaded when available.
- `DB_PASSWORD` and `JWT_SECRET` are read by the application.
- `.env` is excluded from Git.
- `.env.example` contains placeholders, not real credentials.

Verification:
- Application configuration supports environment variables.
- Secret values are not committed in `.env.example`.

## 2. Centralized secrets provisioning

Tool: HashiCorp Vault (KV secrets engine).

Vault status:
- Initialized: true
- Sealed: false
- KV storage: `secret/`
- Demo secret path: `secret/mentorhub-lab10`
- Secret version: 1

Demonstration:
1. Connected to the running Vault container.
2. Used the Vault development token without displaying its value.
3. Stored demonstration values for `DB_PASSWORD` and `JWT_SECRET`.
4. Read the secret back using `vault kv get`.
5. Verified that both keys exist without printing their values.

Result: Centralized storage and retrieval were successfully demonstrated using Vault CLI.

## 3. Security notes and limitations

- The Vault instance runs in development mode.
- Its storage type is `inmem`; data may be lost after restart.
- The application is not yet directly integrated with Vault. Secret retrieval was demonstrated separately through the Vault CLI.
- Development credentials are for demonstration only and must not be reused in production.
- Production deployment should use persistent Vault storage, restricted policies, secure authentication, TLS, and token rotation.

## 4. Conclusion

Both decentralized provisioning (environment variables / `.env`) and centralized provisioning (HashiCorp Vault KV) were demonstrated.

Decentralized configuration is implemented in the application. Centralized storage and retrieval were verified independently through Vault CLI.

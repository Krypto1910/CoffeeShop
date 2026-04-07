# CoffeeShop
A functional coffee ordering app demonstrating a complete mobile-to-remote-server workflow. This project highlights the transition from local development to a secure, signed production environment.

🛠 Technical Implementation
- Advanced OAuth2 Flow: Implemented Google Sign-In by synchronizing SHA-1 fingerprints across Google Cloud Console and Firebase, resolving Redirect URI restrictions using a DuckDNS dynamic domain.
  
- Backend Integration: Architected a seamless connection to a remote PocketBase (Go-based) instance, managing RESTful API requests and persistent data storage.
  
- Production Build Pipeline: Configured Android Keystore (JKS) for secure app signing and handled R8/ProGuard obfuscation to ensure a stable, production-ready Release APK.

- Networking & Security: Enabled Cleartext Traffic handling and managed Network Security Configurations to facilitate secure communication between the Flutter frontend and the remote server.

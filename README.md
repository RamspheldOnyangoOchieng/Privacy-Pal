# Privacy Pal

Privacy Pal is a decentralized application designed to empower users with tools for privacy-preserving reporting and content moderation, built on the Internet Computer Protocol (ICP).

## Project Structure

This project follows a standard structure for applications on the Internet Computer, with distinct `frontend` and `backend` components.

- `src/backend`: Contains the Motoko-based ICP canisters responsible for core logic, data storage, moderation, and identity management.
- `src/frontend`: Houses the React and TypeScript-based user interface.
- `docs`: Comprehensive documentation covering architecture, API, and development guidelines.

## Core Technologies

### Backend (ICP Canisters)

- **Motoko**: The primary language for writing secure and efficient smart contracts (canisters) on the Internet Computer.

### Frontend

- **TypeScript/JavaScript**: For building a robust and type-safe user interface.
- **React**: A popular JavaScript library for building interactive UIs.

### Infrastructure

- **Internet Computer Protocol (ICP)**: The decentralized cloud platform hosting the application's backend canisters.
- **Internet Identity**: Provides secure, anonymous, and device-based authentication for users.

## Getting Started

To set up and run Privacy Pal locally, follow these steps:

### Prerequisites

- **DFX (Internet Computer SDK)**: Install DFX by following the instructions on the [official DFX documentation](https://sdk.dfinity.org/docs/index.html).
- **Node.js & npm**: Ensure you have Node.js (LTS version recommended) and npm installed.
- **Git**: For version control.

### Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/your-repo/privacy-pal.git
   cd privacy-pal
   ```

2. **Install frontend dependencies:**

   ```bash
   npm install
   ```

### Building and Deploying Canisters (Backend)

1. **Start the local Internet Computer replica:**

   ```bash
   dfx start --background
   ```

2. **Deploy the backend canisters:**

   ```bash
   dfx deploy
   ```

   This command will compile and deploy the `report`, `moderation`, `identity`, and `storage` canisters to your local replica.

### Running the Frontend

1. **Start the frontend development server:**

   ```bash
   npm start
   ```

   This will typically open the application in your web browser at `http://localhost:8080` (or a similar port).

## Canister Overview (Phase 1: Core Infrastructure)

As part of the initial phase, the following core canisters are set up:

- **Report Canister**: Handles the submission, status tracking, and retrieval of encrypted reports.
- **Moderation Canister**: Manages the moderation process, including vote submission and consensus calculation.
- **Identity Canister**: Provides anonymous session management and device-based authentication.
- **Storage Canister**: A generic canister for storing encrypted data, used by other canisters for persistent storage.

Common type definitions used across these canisters have been centralized in `src/backend/common/types/common_types.mo` for better organization and maintainability.

## Next Steps

- Implement advanced security features like zero-knowledge proofs.
- Enhance content moderation with AI components.
- Further develop the frontend user experience and add more pages/components.

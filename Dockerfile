FROM node:lts-buster

RUN apt-get update && apt-get upgrade -y && apt-get install apt-utils git-core curl cmake net-tools zsh -y
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
# contracts
RUN cd /root && git clone https://github.com/Kotsin/hbbft-posdao-contracts.git --single-branch --branch i-144-health-values
RUN cd /root/hbbft-posdao-contracts && npm ci && npm run compile && mkdir -p build/contracts && find artifacts/**/*.sol/*json -type f -exec cp '{}' build/contracts ';' && cd ..

# open ethereum
RUN cd /root && git clone https://github.com/surfingnerd/openethereum-3.x.git --single-branch --branch i26-random-value-in-header-and-system-call openethereum
RUN cd /root/openethereum && . "$HOME/.cargo/env" &&  rustup default 1.64 && RUSTFLAGS='-C target-cpu=native' && cargo build --release && cd ..

# honey badger testing
# RUN cd openethereum-3.x &&  RUSTFLAGS='-C target-cpu=native' && cargo build --release && cd ..
RUN cd /root && git clone https://github.com/surfingnerd/honey-badger-testing.git --single-branch --branch performance-tests
RUN cd /root/hbbft-posdao-contracts && mkdir -p build/contracts && find artifacts/contracts -name "*.json" -exec cp '{}' /root/hbbft-posdao-contracts/build/contracts/ ';'
RUN cd /root/honey-badger-testing && . "$HOME/.cargo/env" &&  npm ci && npm run build-open-ethereum && npm run testnet-fresh
# honey badger testing

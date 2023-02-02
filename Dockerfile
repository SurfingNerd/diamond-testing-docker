FROM node:16.18.1-buster


RUN apt-get update && apt-get upgrade -y && apt-get install apt-utils git-core curl cmake net-tools zsh -y
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
# ok, this is rather stupid, but some scripts require a deep directory structure.
# this bypasses some bugs.
RUN mkdir -p /root/dmd/network
# contracts
RUN cd /root/dmd/network && git clone https://github.com/dmdcoin/hbbft-posdao-contracts.git --single-branch --branch master
RUN cd /root/dmd/network/hbbft-posdao-contracts && npm ci && npm run compile && mkdir -p build/contracts && find artifacts/**/*.sol/*json -type f -exec cp '{}' build/contracts ';' && cd ..

# open ethereum
RUN cd /root/dmd/network && git clone https://github.com/dmdcoin/openethereum-3.x.git --single-branch --branch hbbft openethereum
RUN cd /root/dmd/network/openethereum && . "$HOME/.cargo/env" &&  rustup default 1.64 && RUSTFLAGS='-C target-cpu=native' && cargo build --release && cd ..

# honey badger testing
# RUN cd openethereum-3.x &&  RUSTFLAGS='-C target-cpu=native' && cargo build --release && cd ..
RUN cd /root/dmd/network && git clone https://github.com/dmdcoin/honey-badger-testing.git --single-branch --master
RUN cd /root/dmd/network/hbbft-posdao-contracts && mkdir -p build/contracts && find artifacts/contracts -name "*.json" -exec cp '{}' /root/dmd/network/hbbft-posdao-contracts/build/contracts/ ';'
RUN rm /root/dmd/network/hbbft-posdao-contracts/build/contracts/*.dbg.json
RUN cd /root/dmd/network/honey-badger-testing && . "$HOME/.cargo/env" && npm ci
RUN cd /root/dmd/network/honey-badger-testing && . "$HOME/.cargo/env" && npm run build-open-ethereum
RUN cd /root/dmd/network/honey-badger-testing && npm run 
RUN cd /root/dmd/network/honey-badger-testing && . "$HOME/.cargo/env" && npm run testnet-fresh
# honey badger testing





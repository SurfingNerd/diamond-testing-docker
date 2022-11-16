FROM node

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install apt-utils git-core curl net-tools zsh -y
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN . "$HOME/.cargo/env"
RUN cd /home/node

# contracts
RUN git clone https://github.com/Kotsin/hbbft-posdao-contracts.git --single-branch --branch i-144-health-values
RUN cd hbbft-posdao-contracts && npm ci && npm run compile && mkdir -p build/contracts && find artifacts/**/*.sol/*json -type f -exec cp '{}' build/contracts ';' && cd ..

# open ethereum
RUN git clone https://github.com/surfingnerd/openethereum-3.x.git --single-branch --branch i26-random-value-in-header-and-system-call openethereum

# honey badger testing
# RUN cd openethereum-3.x &&  RUSTFLAGS='-C target-cpu=native' && cargo build --release && cd ..
RUN git clone https://github.com/surfingnerd/honey-badger-testing.git --single-branch --branch performance-tests
RUN cd honey-badger-testing && npm ci && npm run build-open-ethereum && npm run testnet-fresh
# honey badger testing

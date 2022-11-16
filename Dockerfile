FROM node

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install apt-utils git-core curl net-tools zsh -y
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
RUN cd /home/node
RUN git clone https://github.com/Kotsin/hbbft-posdao-contracts.git --single-branch --branch i-144-health-values
RUN git clone https://github.com/surfingnerd/honey-badger-testing.git --single-branch --branch performance-tests
RUN git clone https://github.com/surfingnerd/openethereum-3.x.git --single-branch --branch https://github.com/surfingnerd/openethereum-3.x/tree/i26-random-value-in-header-and-system-call
# building
RUN cd hbbft-posdao-contracts && npm ci && npm run compile && cd ..
RUN cd openethereum-3.x && cargo build --release && cd ..

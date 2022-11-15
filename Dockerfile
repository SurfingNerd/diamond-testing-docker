FROM node

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install apt-utils git-core curl net-tools zsh -y
RUN cd /home/node
RUN git clone https://github.com/Kotsin/hbbft-posdao-contracts.git
RUN git clone https://github.com/dmdcoin/honey-badger-testing.git
RUN git clone https://github.com/dmdcoin/openethereum-3.x.git
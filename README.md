
bash into docker container:
`docker run -ti 8931426c4e4a /bin/zsh`


find artifacts/**/*.sol/*json -type f -exec cp '{}' build/contracts ';'

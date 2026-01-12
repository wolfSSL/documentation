#!/bin/bash

pandoc -s header.txt src/Intro.md src/build.md src/command_list.md src/bench.md src/ca.md src/crl.md src/dsaparam.md src/dhparam.md src/dgst.md src/ecparam.md src/enc.md src/genkey.md src/hash.md src/md5.md src/sha.md src/pkcs12.md src/pkey.md src/rand.md src/req.md src/rsa.md src/s_client.md d src/s_server.md src/verify.md src/x509.md src/Appendix01.md --toc -o wolfCLU_Manual.pdf

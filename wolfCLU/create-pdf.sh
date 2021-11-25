#!/bin/bash

pandoc src/Intro.md src/build.md src/command_list.md src/bench.md src/crl.md src/dgst.md src/ecparam.md src/enc.md src/genkey.md src/hash.md src/md5.md src/pkcs12.md src/pkey.md src/req.md src/rsa.md src/s_client.md src/verify.md src/x509.md --toc -o wolfCLU_Manual.pdf

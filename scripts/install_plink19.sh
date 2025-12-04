#!/bin/bash
cd ~
wget https://s3.amazonaws.com/plink1-assets/plink_linux_x86_64_20231018.zip
unzip plink_linux_x86_64_20231018.zip -d plink19
echo ""
echo "PLINK 1.9 installed. Run this before running admixture script:"
echo "  export PATH=\"\$HOME/plink19:\$PATH\""

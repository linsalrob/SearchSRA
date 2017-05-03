#!/bin/bash

# Set up the Jetstream CentOS image to search the SRA

sudo yum -y install tbb tbb-devel samtools
wget http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.8.2-1/sratoolkit.2.8.2-1-centos_linux64.tar.gz
tar xf sratoolkit.2.8.2-1-centos_linux64.tar.gz
sudo mkdir /usr/local/sratoolkit
sudo mv sratoolkit.2.8.2-1-centos_linux64  /usr/local/sratoolkit
sudo ln -s /usr/local/sratoolkit/sratoolkit.2.8.2-1-centos_linux64 /usr/local/sratoolkit/current
sudo sh -c "echo 'export PATH=\$PATH:/usr/local/sratoolkit/current/bin' > /etc/profile.d/sra.sh"
wget https://downloads.sourceforge.net/project/bowtie-bio/bowtie2/2.3.1/bowtie2-2.3.1-linux-x86_64.zip 
unzip bowtie2-2.3.1-linux-x86_64.zip
sudo mkdir /usr/local/bowtie2
sudo mv bowtie2-2.3.1 /usr/local/bowtie2/
sudo ln -s /usr/local/bowtie2/bowtie2-2.3.1/ /usr/local/bowtie2/current
sudo sh -c "echo 'export PATH=\$PATH:/usr/local/bowtie2/current' > /etc/profile.d/bowtie2.sh"
rm -f bowtie2-2.3.1-linux-x86_64.zip sratoolkit.2.8.2-1-centos_linux64.tar.gz
echo -e "hardstatus on\nhardstatus string "%w"\nhardstatus alwayslastline\n" > ~/.screenrc
source /etc/profile.d/bowtie2.sh
source /etc/profile.d/sra.sh

if [ ! -e compare2sra.sh ]; then
	echo "FATAL: WE DID NOT FIND \"compare2sra.sh\" ON THE REMOTE MACHINE"
	exit $E_BADARGS
fi

chmod +x compare2sra.sh

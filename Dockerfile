###### QNIBng image
FROM qnib/terminal:sensu

RUN yum install -y openssh-server openssh-clients && \
    mkdir -p /var/run/sshd && \
    sed -i -e 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config && \
    getent passwd sshd || useradd -g sshd sshd
# We do not care about the known_hosts-file and all the security
####### Highly unsecure... !1!! ###########
RUN echo "        StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
    echo "        UserKnownHostsFile=/dev/null" >> /etc/ssh/ssh_config && \
    echo "        AddressFamily inet" >> /etc/ssh/ssh_config
ADD opt/qnib/sshd/bin/start.sh /opt/qnib/sshd/bin/
ADD etc/supervisord.d/sshd.ini /etc/supervisord.d/
ADD etc/consul.d/sshd.json /etc/consul.d/
## Cluster users
RUN groupadd -g 3000 clusers && \
    useradd -u 3001 -G clusers -d /home/alice -m alice && \
    useradd -u 3002 -G clusers -d /home/bob -m bob && \
    useradd -u 3003 -G clusers -d /home/carol -m carol && \
    useradd -u 3004 -G clusers -d /home/dave -m dave && \
    useradd -u 3005 -G clusers -d /home/eve -m eve && \
    groupadd -g 4000 guests && \
    useradd -u 4001 -G guests -d /home/john -m john && \
    useradd -u 4002 -G guests -d /home/jane -m jane
ADD home/ /tmp/home/
RUN /tmp/home/usersetup.sh alice bob carol dave eve john jane && rm -rf /tmp/home
RUN yum install -y openmpi 
RUN echo "source /etc/profile" >> /etc/bashrc
RUN echo "module load mpi" >> /etc/bashrc

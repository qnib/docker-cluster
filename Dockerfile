###### QNIBng image
FROM qnib/slurmd:cos7

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
ADD home/ /tmp/home/
RUN /tmp/home/usersetup.sh alice bob carol dave eve john jane && rm -rf /tmp/home
RUN yum install -y openmpi
RUN echo "source /etc/profile" >> /etc/bashrc
RUN echo "module load mpi" >> /etc/bashrc

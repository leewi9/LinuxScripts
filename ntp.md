# Debain 12
sudo apt -y install ntpsec

sudo vim /etc/ntpsec/ntp.conf
#pool 0.debian.pool.ntp.org iburst
#pool 1.debian.pool.ntp.org iburst
#pool 2.debian.pool.ntp.org iburst
#pool 3.debian.pool.ntp.org iburst
pool time.nist.gov iburst 

sudo systemctl restart ntpsec

sudo ntpq -p  # verify status

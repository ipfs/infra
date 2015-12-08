venv/bin/activate:
	test -d venv || virtualenv venv

venv/bin/ansible: requirements.txt venv/bin/activate
	. venv/bin/activate && pip install -r requirements.txt

deps: venv/bin/ansible

cake: venv/bin/ansible ipfs_ref
	. venv/bin/activate && ansible-playbook solarnet.yml

IPFS_REPO = https://github.com/ipfs/go-ipfs.git
ipfs_ref : IPFS_REF = $(shell git ls-remote -q $(IPFS_REPO) master | awk "{print \$$1}")
ipfs_ref:
	sed -i'.bak' "s/ipfs_ref:.*/ipfs_ref: $(IPFS_REF)/" roles/ipfs/defaults/main.yml
	rm roles/ipfs/defaults/main.yml.bak

CJDNS_REPO = https://github.com/hyperboria/cjdns.git
cjdns_ref : CJDNS_REF = $(shell git ls-remote -q $(CJDNS_REPO) master | awk "{print \$$1}")
cjdns_ref:
	sed -i'.bak' "s/cjdns_ref:.*/cjdns_ref: $(CJDNS_REF)/" roles/cjdns/defaults/main.yml
	rm roles/cjdns/defaults/main.yml.bak

PINBOT_REPO = https://github.com/whyrusleeping/pinbot.git
pinbot_ref : PINBOT_REF = $(shell git ls-remote -q $(PINBOT_REPO) master | awk "{print \$$1}")
pinbot_ref:
	sed -i'.bak' "s/pinbot_ref:.*/pinbot_ref: $(PINBOT_REF)/" roles/pinbot/defaults/main.yml
	rm roles/pinbot/defaults/main.yml.bak

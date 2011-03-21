

REVISOR_OPTS = --cli --config revisor.conf --kickstart=anaconda-f11.ks \
                     --kickstart-include --kickstart-default --install-unified \
                     --model 'xsau-f11-i386' --yes


with-revisor:
	revisor $(REVISOR_OPTS) 

with-revisor-debug:
	revisor $(REVISOR_OPTS) --debug 10


PACKAGES=nodezoo-base nodezoo-github nodezoo-info \
				 nodezoo-npm nodezoo-search nodezoo-travis \
				 nodezoo-web nodezoo-updater nodezoo-dequeue

SERVICES=$(foreach service, $(PACKAGES), services/$(service))

.PHONY: clean dev-setup update

$(SERVICES):
	-git clone git@github.com:nodezoo/$(@F).git $@

clean:
	rm -rf services

setup: $(SERVICES)
url=$(shell gcloud run services describe test-ip --format='value(status.url)' --region us-central1 --platform managed)
uid=$(shell gcloud auth print-identity-token)
pid=$(shell gcloud config get-value core/project)

CMD_FILE := Makefile-cmd.sh

build:
	gcloud builds submit

clean:
	-gcloud container images delete gcr.io/$(pid)/test-ip --quiet
	-gcloud run services delete test-ip \
		--platform managed \
		--region us-central1 \
		--quiet

call-nat:
	@echo "Calling Node-JS Cloud Run service"
	@token=$(uid) url=$(url); \
	curl $$url \
		--request GET \
		--header "Authorization: Bearer $$token" \

call-cmd:
	@echo "Executing command:"
	@sed 's/^/  /' $(CMD_FILE)
	@curl "$(url)/exec" \
		--request POST \
		--header "Authorization: Bearer $(uid)" \
		--header "Content-Type: text/plain" \
		--data-binary "@$(CMD_FILE)"